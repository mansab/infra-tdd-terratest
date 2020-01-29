FROM clojure AS builder

RUN mkdir -p /usr/src/common-utils
WORKDIR /usr/src/common-utils
COPY ./common-utils/ /usr/src/common-utils/

FROM openjdk:14-alpine3.10 AS runner