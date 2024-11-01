FROM python:3.9-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip

RUN curl -fsSL https://ollama.com/install.sh | sh

# Create a non-root user
RUN adduser --disabled-password --gecos '' ollama_user

# Set the working directory
WORKDIR /home/ollama_user

# Change ownership of the Ollama directory
RUN mkdir -p /home/ollama_user/.ollama && chown -R ollama_user:ollama_user /home/ollama_user/.ollama

# Copy the custom start script and set permissions
COPY start.sh /home/ollama_user/start.sh
RUN chmod +x /home/ollama_user/start.sh && chown ollama_user:ollama_user /home/ollama_user/start.sh

# Switch to the non-root user
USER ollama_user

# Set environment variables to listen on all interfaces and specify the model directory
ENV OLLAMA_HOST=0.0.0.0
ENV OLLAMA_MODELS_DIR=/home/ollama_user/.ollama/models

# Set the entrypoint to the custom script
ENTRYPOINT ["/bin/bash", "/home/ollama_user/start.sh"]
