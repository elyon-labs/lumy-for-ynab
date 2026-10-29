/**
 * Stands in for `react-native` under vitest, which cannot load the real package
 * outside a Metro bundle. Only the surface the pure modules touch is here; add
 * to it as tests reach further into the app.
 */
export const Platform = {
  OS: 'ios' as 'ios' | 'android',
  select<T>(options: { ios?: T; android?: T; default?: T }): T | undefined {
    return options[Platform.OS] ?? options.default;
  },
};
