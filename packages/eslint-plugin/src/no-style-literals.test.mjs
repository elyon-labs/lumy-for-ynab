import { RuleTester } from 'eslint';
import { describe, it } from 'vitest';

import rule from './no-style-literals.js';

RuleTester.describe = describe;
RuleTester.it = it;

const ruleTester = new RuleTester({
  languageOptions: { ecmaVersion: 2022, sourceType: 'module' },
});

ruleTester.run('no-style-literals', rule, {
  valid: [
    { code: 'const style = { color: colors.text };' },
    { code: 'const style = { padding: Spacing.edge };' },
    { code: 'const style = { borderRadius: Radius.card };' },
    { code: 'const style = { fontSize: FontSize.body, lineHeight: LineHeight.body };' },
    // Resetting a value is not a measurement.
    { code: 'const style = { padding: 0, marginTop: 0 };' },
    // The absence of a colour.
    { code: 'const style = { backgroundColor: "transparent" };' },
    // Borders take 1 or a hairline and nothing else, so they are not policed.
    { code: 'const style = { borderWidth: 1 };' },
    { code: 'const style = { borderWidth: StyleSheet.hairlineWidth };' },
    // Not a measurement property.
    { code: 'const style = { flex: 1, minHeight: 48, opacity: 0.4 };' },
    // Not a colour.
    { code: 'const id = "#general";' },
    { code: 'const heading = `# ${title}`;' },
    { code: 'const label = `${count} items`;' },
    { code: 'const url = `${base}/budgets`;' },
  ],

  invalid: [
    {
      code: 'const style = { color: "#5C43D6" };',
      errors: [{ messageId: 'color' }],
    },
    {
      code: 'const style = { color: "#fff" };',
      errors: [{ messageId: 'color' }],
    },
    {
      code: 'const style = { backgroundColor: "#1C1D1EA6" };',
      errors: [{ messageId: 'color' }],
    },
    {
      code: 'const style = { backgroundColor: "rgba(0, 0, 0, 0.5)" };',
      errors: [{ messageId: 'color' }],
    },
    {
      code: 'const style = { backgroundColor: `${colors.text}80` };',
      errors: [{ messageId: 'alpha' }],
    },
    {
      code: 'const style = { padding: 16 };',
      errors: [{ messageId: 'measurement', data: { value: '16', property: 'padding' } }],
    },
    {
      code: 'const style = { marginTop: -8 };',
      errors: [{ messageId: 'measurement' }],
    },
    {
      code: 'const style = { gap: 12, borderRadius: 16 };',
      errors: [{ messageId: 'measurement' }, { messageId: 'measurement' }],
    },
    {
      code: 'const style = { fontSize: 15 };',
      errors: [{ messageId: 'measurement' }],
    },
    {
      code: 'const style = { "paddingHorizontal": 24 };',
      errors: [{ messageId: 'measurement' }],
    },
    // A colour reached through a prop rather than a style object is still a
    // colour literal.
    {
      code: 'const element = <View backgroundColor="#000000" />;',
      languageOptions: { parserOptions: { ecmaFeatures: { jsx: true } } },
      errors: [{ messageId: 'color' }],
    },
  ],
});
