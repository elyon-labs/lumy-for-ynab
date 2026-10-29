'use strict';

const noStyleLiterals = require('./no-style-literals');

/**
 * Keeps the design system from being bypassed.
 *
 * `@lumy/theme` owns every colour and measurement. This plugin is applied to
 * everything that consumes those tokens, and not to the package that defines
 * them.
 */
const plugin = {
  meta: { name: '@lumy/eslint-plugin' },
  rules: {
    'no-style-literals': noStyleLiterals,
  },
};

module.exports = plugin;
module.exports.configs = {
  recommended: {
    plugins: { '@lumy': plugin },
    rules: { '@lumy/no-style-literals': 'error' },
  },
};
