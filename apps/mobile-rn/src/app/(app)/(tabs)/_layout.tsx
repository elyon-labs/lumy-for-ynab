import { Tabs } from 'expo-router';
import { useTranslation } from 'react-i18next';

import { FontSize } from '@lumy/theme';
import { Icon, useColors } from '@lumy/ui';

/**
 * The three tabs, each with its own stack.
 *
 * There is no side navigation. The Flutter app's `side_navigation_menu.dart`
 * is on the desktop branch of its adaptive layout and renders above 1024pt,
 * which a portrait-locked phone and tablet build never reaches — its own
 * tablets get this same tab bar.
 */
export default function TabsLayout() {
  const { t } = useTranslation();
  const colors = useColors();

  return (
    <Tabs
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: colors.primary,
        tabBarInactiveTintColor: colors.textFaint,
        tabBarStyle: { backgroundColor: colors.surface, borderTopColor: colors.border },
        tabBarLabelStyle: { fontSize: FontSize.caption },
      }}
    >
      <Tabs.Screen
        name="budget"
        options={{
          title: t('navigation.budget'),
          tabBarIcon: ({ focused }) => (
            <Icon name={focused ? 'wallet' : 'wallet-outline'} tone={focused ? 'primary' : 'faint'} />
          ),
        }}
      />
      <Tabs.Screen
        name="reports"
        options={{
          title: t('navigation.reports'),
          tabBarIcon: ({ focused }) => (
            <Icon
              name={focused ? 'analytics' : 'analytics-outline'}
              tone={focused ? 'primary' : 'faint'}
            />
          ),
        }}
      />
      <Tabs.Screen
        name="settings"
        options={{
          title: t('navigation.settings'),
          tabBarIcon: ({ focused }) => (
            <Icon name={focused ? 'cog' : 'cog-outline'} tone={focused ? 'primary' : 'faint'} />
          ),
        }}
      />
    </Tabs>
  );
}
