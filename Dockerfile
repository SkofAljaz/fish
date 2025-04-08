FROM rust:alpine3.21 AS builder

RUN date +%s > /time
RUN apk update && apk add musl-dev
RUN echo "$SOURCE_DATE_EPOCH" > /epoch
WORKDIR /build
ENV CARGO_INCREMENTAL=0
COPY . .
RUN cargo build --release

FROM alpine:3.21 AS runner

RUN date +%s > /time
RUN addgroup runner && adduser -S runner -G runner
WORKDIR /app
COPY --from=builder --chown=runner:runner /time .
COPY --from=builder --chown=runner:runner /epoch .
COPY --from=builder --chown=runner:runner /build/target/release/fish .
USER runner
ENTRYPOINT [ "/app/fish" ]
