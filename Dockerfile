FROM node:20-alpine

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache python3 make g++ curl

# Copy application code
COPY . .

# Install Node.js dependencies (production only)
RUN cd backend && npm install --production && cd ..

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:3000 || exit 1

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Start application
CMD ["node", "backend/server.js"]
