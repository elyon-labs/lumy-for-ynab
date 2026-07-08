import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
  redirects: {
    "/release_notes": "/release-notes",
    "/release_notes/": "/release-notes/",
  },
});
