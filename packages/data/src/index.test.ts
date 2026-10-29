import { existsSync, readFileSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

import { describe, expect, it } from 'vitest';

const SRC = join(dirname(fileURLToPath(import.meta.url)));

const IMPORT = /(?:^|\n)\s*(?:import|export)[\s\S]*?from\s+'([^']+)'/g;

/** Every module reachable from `entry`, following relative imports only. */
function localGraph(entry: string): Set<string> {
  const seen = new Set<string>();
  const queue = [entry];

  while (queue.length > 0) {
    const file = queue.pop();
    if (file === undefined || seen.has(file)) continue;
    seen.add(file);

    const source = readFileSync(file, 'utf8');
    for (const [, specifier] of source.matchAll(IMPORT)) {
      if (!specifier.startsWith('.')) continue;

      const base = resolve(dirname(file), specifier);
      const resolved = [`${base}.ts`, join(base, 'index.ts')].find((path) => existsSync(path));
      if (resolved === undefined) throw new Error(`Cannot resolve ${specifier} from ${file}`);

      queue.push(resolved);
    }
  }

  return seen;
}

/** Every package `entry` and what it imports depend on. */
function packagesReachedFrom(entry: string): Set<string> {
  const packages = new Set<string>();

  for (const file of localGraph(entry)) {
    const source = readFileSync(file, 'utf8');
    for (const [, specifier] of source.matchAll(IMPORT)) {
      if (specifier.startsWith('.')) continue;
      packages.add(specifier);
    }
  }

  return packages;
}

describe('what the app can reach', () => {
  it('never reaches a Drizzle runtime', () => {
    // Drizzle describes the schema and generates the migration SQL; it does
    // not execute anything, and it is not something Metro should ever be
    // asked to bundle. `src/schema` is reachable from the tests and the
    // generator and from nowhere else.
    const packages = [...packagesReachedFrom(join(SRC, 'index.ts'))];

    expect(packages.filter((name) => name.startsWith('drizzle'))).toEqual([]);
  });

  it('never reaches the node driver', () => {
    const packages = packagesReachedFrom(join(SRC, 'index.ts'));

    expect(packages).not.toContain('node:sqlite');
  });

  it('reaches only expo-sqlite from the app adapter', () => {
    expect([...packagesReachedFrom(join(SRC, 'adapters/expoSqlite.ts'))]).toEqual(['expo-sqlite']);
  });
});
