'use strict';

/**
 * Style values that must name a token instead of stating a number.
 *
 * Border widths are absent on purpose: `borderWidth: 1` and
 * `StyleSheet.hairlineWidth` are the only two values a border ever takes, and
 * neither belongs in the spacing scale.
 */
const SPACED_PROPERTIES = new Set([
  'padding',
  'paddingTop',
  'paddingRight',
  'paddingBottom',
  'paddingLeft',
  'paddingHorizontal',
  'paddingVertical',
  'margin',
  'marginTop',
  'marginRight',
  'marginBottom',
  'marginLeft',
  'marginHorizontal',
  'marginVertical',
  'gap',
  'rowGap',
  'columnGap',
  'borderRadius',
  'borderTopLeftRadius',
  'borderTopRightRadius',
  'borderBottomLeftRadius',
  'borderBottomRightRadius',
  'fontSize',
  'lineHeight',
  'letterSpacing',
]);

/**
 * `0` means "none" rather than a measurement, and a style that resets a value
 * should not have to reach for a token to say so.
 */
const ALLOWED_NUMBERS = new Set([0]);

const COLOR_PATTERN = /^#(?:[0-9a-fA-F]{3,4}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$/;
const COLOR_FUNCTION_PATTERN = /^(?:rgb|rgba|hsl|hsla)\(/i;
const ALPHA_SUFFIX_PATTERN = /^[0-9a-fA-F]{2}$/;

/** `transparent` is the absence of a colour, not a colour the palette owns. */
const ALLOWED_COLOR_KEYWORDS = new Set(['transparent']);

function isColorLiteral(value) {
  if (typeof value !== 'string') return false;
  if (ALLOWED_COLOR_KEYWORDS.has(value)) return false;

  return COLOR_PATTERN.test(value) || COLOR_FUNCTION_PATTERN.test(value);
}

/** Unwraps `-4` and the like, which parse as a unary expression, not a literal. */
function numericValue(node) {
  if (node.type === 'Literal' && typeof node.value === 'number') {
    return node.value;
  }
  if (
    node.type === 'UnaryExpression' &&
    node.operator === '-' &&
    node.argument.type === 'Literal' &&
    typeof node.argument.value === 'number'
  ) {
    return -node.argument.value;
  }
  return null;
}

function propertyName(node) {
  if (node.key.type === 'Identifier' && !node.computed) return node.key.name;
  if (node.key.type === 'Literal' && typeof node.key.value === 'string') return node.key.value;
  return null;
}

/** @type {import('eslint').Rule.RuleModule} */
const rule = {
  meta: {
    type: 'problem',
    docs: {
      description:
        'Require colours and measurements to come from @lumy/theme rather than being stated inline.',
    },
    schema: [],
    messages: {
      color:
        'Use a colour token from @lumy/theme instead of "{{value}}". If the palette has no token for it, add one.',
      measurement:
        'Use Spacing, Radius, or the type scale from @lumy/theme instead of {{value}} for "{{property}}".',
      alpha:
        'Compositing an alpha onto a token produces a colour the palette does not define. Add the translucent value to @lumy/theme instead.',
    },
  },

  create(context) {
    return {
      Literal(node) {
        if (!isColorLiteral(node.value)) return;

        context.report({ node, messageId: 'color', data: { value: node.value } });
      },

      // `${colors.text}80` composites an alpha onto a token, which quietly
      // produces a colour the palette never agreed to. Matched narrowly — one
      // interpolation followed by exactly two hex digits and nothing else — so
      // that ordinary strings beginning with a hash are left alone.
      TemplateLiteral(node) {
        if (node.expressions.length !== 1 || node.quasis.length !== 2) return;

        const [lead, tail] = node.quasis;
        if (lead.value.cooked !== '') return;
        if (!ALPHA_SUFFIX_PATTERN.test(tail.value.cooked ?? '')) return;

        context.report({ node, messageId: 'alpha' });
      },

      Property(node) {
        const name = propertyName(node);
        if (name === null || !SPACED_PROPERTIES.has(name)) return;

        const value = numericValue(node.value);
        if (value === null || ALLOWED_NUMBERS.has(value)) return;

        context.report({
          node: node.value,
          messageId: 'measurement',
          data: { value: String(value), property: name },
        });
      },
    };
  },
};

module.exports = rule;
