FROM node:24.11.1-alpine

WORKDIR /app/

COPY app /app/

# Node
ENV PATH "$PATH:/app/node_modules/.bin/"
RUN apk add --no-cache git && \
    yarn install --frozen-lockfile && \
    git clone --depth 1 https://github.com/shopware/shopware.git /tmp/shopware && \
    cp -r /tmp/shopware/src/Administration/Resources/app/administration/twigVuePlugin /tmp/eslint-plugin-twig-vue && \
    cd /tmp/eslint-plugin-twig-vue && \
    yarn install && \
    yarn pack --filename /tmp/eslint-plugin-twig-vue.tgz && \
    cd /app && \
    yarn add file:/tmp/eslint-plugin-twig-vue.tgz && \
    yarn cache clean && \
    rm -rf /tmp/shopware /tmp/eslint-plugin-twig-vue /tmp/eslint-plugin-twig-vue.tgz && \
    apk del git
ENV NODE_PATH=/app/node_modules/

WORKDIR /code/

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF

# Labels
LABEL \
    maintainer="Max <max@swk-web.com>" \
    org.label-schema.description="ESLint 8 with Shopware/Vue plugins in a container" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="ESLint Shopware" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://github.com/aragon999/eslint-shopware" \
    org.label-schema.usage="https://github.com/aragon999/eslint-shopware/blob/main/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/aragon999/eslint-shopware" \
    org.label-schema.vendor="aragon999"
