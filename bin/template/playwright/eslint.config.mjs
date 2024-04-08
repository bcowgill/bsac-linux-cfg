import globals from "globals";
import pluginJs from "@eslint/js";
import playwright from 'eslint-plugin-playwright';

// npm run eslint 2> eslint.log 
//console.warn(`eslint configuration available globals`, globals)

export default [
  {languageOptions: { globals: { ...globals.browser, ...globals.node } }},
  pluginJs.configs.recommended,
  playwright.configs['flat/recommended'],
];
