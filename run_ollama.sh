#!/bin/sh

echo "Starting Ollama server..."
ollama serve &  # Start Ollama in the background

echo "Ollama is ready, creating the model..."

ollama create phi -f /root/.ollama/models

pkill -f "ollama serve"

ollama serve