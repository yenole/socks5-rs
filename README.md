[![Build](https://github.com/WANG-lp/socks5-rs/workflows/Rust-CI/badge.svg)](https://github.com/WANG-lp/socks5-rs/actions) 

# socks5-rs

A lightweight and fast socks5 server written in Rust

Fully async I/O with Tokio! 

## Features

- `CONNECT` (TCP) and `UDP ASSOCIATE` (UDP) commands (RFC 1928)
- IPv4, IPv6 and domain-name targets
- Optional username/password authentication (RFC 1929)
- DNS resolution on the proxy side (`socks5h`), trying every resolved address
- Half-close aware, back-pressured TCP relay with large I/O buffers

Recommend to use it in a trusted network (e.g., with [wireguard](https://www.wireguard.com/)),
or enable username/password authentication when exposing it more widely.

NOTE: `BIND` is intentionally not implemented; it is rejected with
`Command not supported` (REP `0x07`).

## Docker 镜像

GitHub Actions 仅在推送 `v*` 格式的 Git tag（例如 `v2.0.0`）时构建多架构镜像（`linux/amd64`、`linux/arm64`），并发布到 GitHub Container Registry：

```bash
docker pull ghcr.io/yenole/socks5-rs:latest
docker run --rm -p 8080:8080/tcp -p 8080:8080/udp ghcr.io/yenole/socks5-rs:latest
```

需要认证时，通过 Docker 环境变量 `SOCKS5_USERNAME` 和 `SOCKS5_PASSWORD` 同时设置用户名和密码。Docker 启动脚本会将其转换为程序所需的 `-u`、`-P` 参数；Rust 程序本身无需读取环境变量：

```bash
docker run --rm \\
  -p 8080:8080/tcp -p 8080:8080/udp \\
  -e SOCKS5_USERNAME=alice \\
  -e SOCKS5_PASSWORD='your-secret' \\
  ghcr.io/yenole/socks5-rs:latest
```

两个环境变量必须同时提供，单独设置其中一个会报错退出。不设置时不启用认证。首次从 GHCR 拉取时，如果仓库包为私有，请先登录并确保包可见性允许访问。

## Compiling
install Rust toolchain: [click here to install Rust](https://www.rust-lang.org/tools/install) 


### From crates.io

```bash
cargo install socks5-rs
```

### From source

```bash
git clone git@github.com:WANG-lp/socks5-rs.git
cd socks5-rs
cargo build --release
```


## Usage

`./target/release/socks5-rs -h`

```bash
A lightweight and fast SOCKS5 server written in Rust

Usage: socks5-rs [OPTIONS]

Options:
  -b, --bind <BIND>            Address to bind [default: 127.0.0.1]
  -p, --port <PORT>            Port to listen on [default: 8080]
  -t, --work-threads <N>       Number of worker threads [default: 4]
  -u, --username <USERNAME>    Username for auth (RFC 1929); requires --password
  -P, --password <PASSWORD>    Password for auth (RFC 1929); requires --username
      --handshake-timeout <S>  Handshake/request timeout in seconds [default: 15]
      --connect-timeout <S>    Outbound CONNECT timeout in seconds [default: 15]
  -h, --help                   Print help
  -V, --version                Print version
```

Examples:

```bash
# open proxy on all interfaces
./target/release/socks5-rs -b 0.0.0.0 -p 8080

# require username/password authentication
./target/release/socks5-rs -b 0.0.0.0 -p 8080 -u alice -P s3cret
```
