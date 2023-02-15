module.exports = {
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    // MUSTDO resolve this when eslint fully supports typescript5
    // 'plugin:@typescript-eslint/recommended-requiring-type-checking',
    // "plugin:@typescript-eslint/strict",
    "prettier"
  ],
  parser: '@typescript-eslint/parser',
  plugins: ['@typescript-eslint'],
  parserOptions: {
    // MUSTDO resolve this when eslint fully supports typescript5
    project: false,  // suggestion is true with recommended-requiring-type-checking
    tsconfigRootDir: __dirname,
  },
  root: true,
};
