# ESLint Shopware Docker Image

Docker image for ESLint 8 with Shopware and Vue-specific plugins for use in CI/CD pipelines.

## Docker Image

[![GitHub Container Registry][ghcr-shield]][ghcr]

The image is available at:
```
ghcr.io/aragon999/eslint-shopware:latest
```

## Included Packages

This image includes ESLint 8 with the following plugins and parsers:

- **eslint** - Core ESLint linter
- **eslint-config-airbnb-base** - Airbnb's base JavaScript style guide
- **@shopware-ag/eslint-config-base** - Shopware's base ESLint configuration
- **eslint-plugin-vue** - Vue.js linting rules
- **eslint-plugin-vuejs-accessibility** - Accessibility rules for Vue.js
- **eslint-plugin-twig-vue** - Twig template support in Vue
- **eslint-plugin-inclusive-language** - Promotes inclusive language in code
- **vue-eslint-parser** - Parser for Vue single-file components
- **@babel/eslint-parser** - Babel parser for modern JavaScript
- **@babel/core** - Babel core for transpilation support

## Usage

ESLint is installed in `/app/` with all dependencies. Your code should be mounted at `/code/`.

### Docker Run

```bash
docker run --rm -v $(pwd):/code ghcr.io/aragon999/eslint-shopware:latest eslint --color .
```

### GitLab CI Integration

#### Basic Integration

This integration runs as a pipeline job. If any issues are found that are not
silenced by the configuration, the job (and pipeline) fails.

```yaml
eslint:
  needs: []
  image: ghcr.io/aragon999/eslint-shopware:latest
  before_script:
    - touch dummy.js
  script:
    - eslint --color .
```

Notes:
- Touching dummy.js prevents ESLint from complaining that it had no files to lint.
- If you don't want to customize the rules that are used, add `--no-config-lookup` to the commandline.

#### GitLab Code Quality Integration

This integration runs as a pipeline job, too. Other than the simple
integration above, it doesn't fail the job if any issues are found.
Instead, it makes all issues available via GitLab's
[Code Quality][gitlab-code-quality] feature.

```yaml
eslint:
  artifacts:
    reports:
      codequality: gl-codequality.json
  image: ghcr.io/aragon999/eslint-shopware:latest
  needs: []
  script:
    # ESLint exits with 1 in case it finds any issues, which is not an
    # error in the context of the pipeline. If it encounters an internal
    # problem, it exits with 2 instead.
    - eslint --format gitlab . > gl-codequality.json || [ $? == 1 ]
```

### GitHub Actions Integration

```yaml
jobs:
  eslint:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/aragon999/eslint-shopware:latest
    steps:
      - uses: actions/checkout@v4
      - name: Run ESLint
        run: eslint --color .
```

## Configuration

Place your `.eslintrc.js`, `.eslintrc.json`, or equivalent configuration file in your project root. The image will automatically detect and use it.

Example `.eslintrc.js` for Shopware projects:

```javascript
module.exports = {
    root: true,
    extends: [
        'eslint:recommended',
        'airbnb-base',
        '@shopware-ag/eslint-config-base',
        'plugin:vue/recommended',
        'plugin:vuejs-accessibility/recommended',
    ],
    parser: 'vue-eslint-parser',
    env: {
        browser: true,
        node: true,
        es6: true,
    },
    globals: {
        Shopware: true,
    },
    plugins: [
        'twig-vue',
        'inclusive-language',
        'vuejs-accessibility',
    ],
    parserOptions: {
        parser: '@babel/eslint-parser',
        ecmaVersion: 6,
        sourceType: 'module',
        requireConfigFile: false,
    },
    rules: {
        'comma-dangle': ['error', 'always-multiline'],
        'one-var': ['error', 'never'],
        'no-console': ['error', { allow: ['warn', 'error'] }],
        'prefer-const': 'warn',
        quotes: ['warn', 'single'],
        indent: ['warn', 4, {
            SwitchCase: 1,
        }],
        'inclusive-language/use-inclusive-words': 'error',
    },
};
```

## Building Locally

```bash
docker build -t eslint-shopware .
```

## Support

For issues and questions, please use the [GitHub Issues][issues] page.

[ghcr-shield]: https://img.shields.io/badge/GHCR-latest-blue
[ghcr]: https://github.com/aragon999/eslint-shopware/pkgs/container/eslint-shopware
[issues]: https://github.com/aragon999/eslint-shopware/issues
[gitlab-code-quality]: https://docs.gitlab.com/ee/ci/testing/code_quality.html
