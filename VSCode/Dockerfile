FROM debian:bullseye-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget git build-essential llvm clang libssl-dev pkg-config cmake python3 curl \
    gnupg2 libgtk-3-0 libx11-xcb1 libxss1 libasound2 libgbm1 libnspr4 libnss3 \
    libxkbfile1 xdg-utils ca-certificates locales sudo net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home/app

RUN useradd -m app && echo "app ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && chown -R app:app /home/app

USER app

# Set environment variables for Rust
ENV RUSTUP_HOME=/home/app/.rustup \
    CARGO_HOME=/home/app/.cargo \
    PATH=/home/app/.cargo/bin:$PATH

# Install Rust for the 'app' user
RUN set -eux; \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
    rustup target add wasm32-unknown-unknown

#https://github.com/coder/code-server/releases
RUN curl -fsSL -o install-code-server.sh https://code-server.dev/install.sh && \
    sh install-code-server.sh && rm install-code-server.sh

RUN wget https://open-vsx.org/api/rust-lang/rust/0.7.8/file/rust-lang.rust-0.7.8.vsix

#https://github.com/rust-lang/rust-analyzer/releases/tag/2023-10-30
RUN wget https://github.com/rust-lang/rust-analyzer/releases/download/2023-10-30/rust-analyzer-linux-x64.vsix

RUN touch /home/app/.bash_profile && \
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> /home/app/.bash_profile

EXPOSE 8080

COPY start.sh /home/app/start.sh
USER root
RUN chmod +x /home/app/start.sh
USER app

CMD ["/home/app/start.sh"]
