const { defineConfig } = require('eslint/config');
const expoConfig = require('eslint-config-expo/flat');

const lumy = require('@lumy/eslint-plugin');

module.exports = defineConfig([
  expoConfig,
  lumy.configs.recommended,
  {
    ignores: ['dist/*', '.expo/*'],
  },
]);
