module.exports = {
    "env": {
        "browser": true,
        "commonjs": true,
        "es6": true,
        "jest": true,
        "node": true
    },
    "extends": [
        "plugin:prettier/recommended",
        "plugin:react/recommended"
    ],
    "settings": {
        "react": {
            "version": "16.0"
        }
    },
    "parserOptions": {
        "ecmaVersion": "2019",
        "ecmaFeatures": {
            "jsx": true
        },
        "sourceType": "module"
    },
    "plugins": [
        "react"
    ],
    "globals": {},
    "rules": {
        "indent": [
            "off",
            "tab"
        ],
        "linebreak-style": [
            "error",
            "unix"
        ],
        "quotes": [
            "error",
            "single"
        ],
        "semi": [
            "error",
            "never"
        ]
    }
};
