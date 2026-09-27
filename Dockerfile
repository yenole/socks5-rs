FROM rust:1-bookworm AS builder
WORKDIR /app
COPY Cargo.toml Cargo.lock* ./
COPY src ./src
RUN cargo build --release

FROM debian:bookworm-slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --system --no-create-home --uid 10001 socks5
COPY --from=builder /app/target/release/socks5-rs /usr/local/bin/socks5-rs
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
USER socks5
EXPOSE 8080/tcp 8080/udp
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["-b", "0.0.0.0", "-p", "8080"]
