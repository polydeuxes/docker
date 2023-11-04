FROM debian:buster-slim

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    wget \
    libgtk-3-0 \
    libx11-xcb1 \
    libxss1 \
    libasound2 \
    libgbm1 \
    git \
    libnspr4 \
    libnss3 \
    libxkbfile1 \
    xdg-utils && \
    rm -rf /var/lib/apt/lists/*

# Download and install VS Code
RUN wget -qO- "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O /tmp/code.deb && \
    dpkg -i /tmp/code.deb || apt-get -f install -y && \
    rm /tmp/code.deb

# Install Rust and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Create a non-root user and give them passwordless sudo privileges
RUN useradd -m coder && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Change the owner of the home directory to the 'coder' user
RUN chown -R coder:coder /home/coder

# Switch to 'coder' user from here on
USER coder
WORKDIR /home/coder

# Add the start-up script
COPY --chown=coder:coder start.sh /home/coder/start.sh

# Give execution permissions to the start-up script
RUN chmod +x /home/coder/start.sh

# Download and install the rust-analyzer VS Code extension
RUN wget https://github.com/rust-lang/rust-analyzer/releases/download/2023-10-30/rust-analyzer-linux-x64.vsix && \
    code --install-extension rust-analyzer-linux-x64.vsix && \
    rm rust-analyzer-linux-x64.vsix

# Expose the port for code-server
EXPOSE 8080

# Use the start-up script to initiate the code-server
CMD ["/home/coder/start.sh"]
