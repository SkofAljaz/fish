FROM rust:alpine3.21 AS builder

RUN apk update && apk add musl-dev
WORKDIR /build
ENV CARGO_INCREMENTAL=0
COPY . .
RUN cargo build --release

FROM alpine:3.21 AS runner

RUN addgroup runner && adduser -S runner -G runner
WORKDIR /app
COPY --from=builder --chown=runner:runner /build/target/release/fish .
USER runner
ENTRYPOINT [ "/app/fish" ]
