import globals from "globals";
import pluginJs from "@eslint/js";
import tseslint from "typescript-eslint";
import playwright from 'eslint-plugin-playwright';


export default [
  {languageOptions: { globals: { ...globals.browser, ...globals.node } }},
  pluginJs.configs.recommended,
  playwright.configs['flat/recommended'],
  ...tseslint.configs.recommended,
];
