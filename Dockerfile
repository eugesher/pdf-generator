FROM node:14.17.5-alpine

# If you also need fonts then add this - Select any fonts from here https://wiki.alpinelinux.org/wiki/Fonts
# Just replace ttf-ubuntu-font-family with fonts that you need
RUN apk --update add ttf-ubuntu-font-family fontconfig && rm -rf /var/cache/apk/*

# if ever you need to change phantom js version number in future ENV comes handy as it can be used as a dynamic variable
ENV PHANTOMJS_VERSION=2.1.1

# magic command
RUN apk add --no-cache curl && \
    cd /tmp && curl -Ls https://github.com/dustinblackman/phantomized/releases/download/${PHANTOMJS_VERSION}/dockerized-phantomjs.tar.gz | tar xz && \
    cp -R lib lib64 / && \
    cp -R usr/lib/x86_64-linux-gnu /usr/lib && \
    cp -R usr/share /usr/share && \
    cp -R etc/fonts /etc && \
    curl -k -Ls https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2 | tar -jxf - && \
    cp phantomjs-${PHANTOMJS_VERSION}-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && \
    rm -fR phantomjs-${PHANTOMJS_VERSION}-linux-x86_64 && \
    apk del curl

# magic command if you don't want to use ENV dynamic phantomjs version
RUN apk add --no-cache curl && \
    cd /tmp && curl -Ls https://github.com/dustinblackman/phantomized/releases/download/2.1.1/dockerized-phantomjs.tar.gz | tar xz && \
    cp -R lib lib64 / && \
    cp -R usr/lib/x86_64-linux-gnu /usr/lib && \
    cp -R usr/share /usr/share && \
    cp -R etc/fonts /etc && \
    curl -k -Ls https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 | tar -jxf - &&\
    cp phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && \
    rm -fR phantomjs-2.1.1-linux-x86_64 && \
    apk del curl

WORKDIR /usr/src/app
COPY . .
RUN npm install -g npm@latest
RUN npm install -g rimraf
RUN npm install
RUN npm run build
CMD ["node", "./dist/main.js"]
