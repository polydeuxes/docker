FROM debian:buster-slim

# Install necessary tools
RUN apt-get update && \
    apt-get install -y \
    curl \
    gnupg2 \
    wget \
    libgtk-3-0 \
    libx11-xcb1 \
    libxss1 \
    libasound2 \
    libgbm1 \
    git

# Download and install VS Code
RUN wget -qO- "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O /tmp/code.deb && \
    dpkg -i /tmp/code.deb && \
    rm /tmp/code.deb

# Cleanup
RUN apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Create a non-root user
RUN useradd -m coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to non-root user
USER coder
WORKDIR /home/coder

# Download and install the rust-analyzer VS Code extension
RUN wget https://github.com/rust-lang/rust-analyzer/releases/download/2023-10-30/rust-analyzer-linux-x64.vsix && \
    code --install-extension rust-analyzer-linux-x64.vsix && \
    rm rust-analyzer-linux-x64.vsix

# Copy the start script
COPY start.sh /home/coder/start.sh

# Make the start script executable
RUN chmod +x /home/coder/start.sh

# Expose the code-server port
EXPOSE 8080

# Start code-server using the start script
ENTRYPOINT ["/home/coder/start.sh"]
