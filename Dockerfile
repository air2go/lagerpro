FROM python:3.11-slim

WORKDIR /app

# Installiere System-Dependencies
RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    sqlite3 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Kopiere Backend
COPY backend/ ./backend/
COPY frontend/ ./frontend/

# Installiere Python Dependencies (falls vorhanden)
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# Installiere Node Dependencies
RUN cd backend && npm install && cd ..

# Expose Port
EXPOSE 3000

# Health Check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:3000 || exit 1

# Start Application
CMD ["node", "backend/server.js"]
