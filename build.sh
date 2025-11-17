#!/bin/bash

echo "🔨 Building Pioneer 3-AT Docker Image..."
docker-compose build --no-cache
echo "✅ Build complete!"
