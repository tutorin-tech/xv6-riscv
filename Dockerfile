FROM ubuntu:24.04

LABEL maintainer="Evgeny Golyshev <eugulixes@gmail.com>"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
   ca-certificates \
   bc \
   curl \
   gcc-riscv64-linux-gnu \
   libc6-riscv64-cross \
   make \
   qemu-system-misc \
   build-essential \
   clang \
   lld \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && if [ -x /usr/bin/riscv64-linux-gnu-gcc ]; then ln -sf /usr/bin/riscv64-linux-gnu-gcc /usr/bin/gcc; fi \
 && if [ -f /usr/riscv64-linux-gnu/lib/ld-linux-riscv64-lp64d.so.1 ]; then ln -sf /usr/riscv64-linux-gnu/lib/ld-linux-riscv64-lp64d.so.1 /lib/ld-linux-riscv64-lp64d.so.1; fi \
 && if [ -f /usr/riscv64-linux-gnu/lib/libc.so.6 ]; then ln -sf /usr/riscv64-linux-gnu/lib/libc.so.6 /lib/libc.so.6; fi

ENV RUSTUP_HOME=/usr/local/rustup CARGO_HOME=/usr/local/cargo
RUN curl https://sh.rustup.rs -sSf | RUSTUP_HOME=/usr/local/rustup CARGO_HOME=/usr/local/cargo sh -s -- -y --no-modify-path \
 && /usr/local/cargo/bin/rustup target add riscv64gc-unknown-none-elf || true \
 && ln -sf /usr/local/cargo/bin/cargo /usr/local/bin/cargo \
 && ln -sf /usr/local/cargo/bin/rustc /usr/local/bin/rustc \
 && ln -sf /usr/local/cargo/bin/rustup /usr/local/bin/rustup \
 && chmod -R a+rX /usr/local/cargo /usr/local/rustup \
 && chown -R root:root /usr/local/cargo /usr/local/rustup

USER ubuntu

WORKDIR /xv6-riscv
