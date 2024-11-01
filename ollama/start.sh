#!/bin/bash

# Start the Ollama service
ollama serve &

# Wait for the service to start
sleep 10

# Run the model and specify the correct directory
export OLLAMA_MODELS_DIR=/home/ollama_user/.ollama/models
ollama run llama3.2

# Keep the container running
tail -f /dev/null
