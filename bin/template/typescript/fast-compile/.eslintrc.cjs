module.exports = {
  extends: [
   //   "react-app",
      "plugin:import/errors",
      "plugin:import/warnings",
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    // MUSTDO(BSAC) resolve this when eslint fully supports typescript5
    // 'plugin:@typescript-eslint/recommended-requiring-type-checking',
    // "plugin:@typescript-eslint/strict",
    // "plugin:react-hooks/recommended"
    "prettier"
  ],
  parser: '@typescript-eslint/parser',
  plugins: [
      "import",
    '@typescript-eslint'
      // "cypress"
  ],
  //  "env": {
  //    "cypress/globals": true
  //  },
  //  "globals": {
  //  },
  parserOptions: {
    // MUSTDO(BSAC) resolve this when eslint fully supports typescript5
    project: false,  // suggestion is true with recommended-requiring-type-checking
    tsconfigRootDir: __dirname,
  },
  root: true,
    "rules": {
      "no-console": [
        "error"
      ],
      "no-fallthrough": [
        "error"
      ],
      "import/order": [
        "error",
        {
          "groups": [
            "builtin",
            "external",
            "internal",
            "parent",
            "sibling",
            "index"
          ]
        }
      ]
    },
};
