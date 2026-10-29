import { defineConfig } from 'eslint/config';
import expoConfig from 'eslint-config-expo/flat.js';

import lumy from '@lumy/eslint-plugin';

export default defineConfig([expoConfig, lumy.configs.recommended]);
