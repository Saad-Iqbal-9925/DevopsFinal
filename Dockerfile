# ---------- Build stage ----------
FROM node:22-alpine AS builder

WORKDIR /app

# Cache dependencies
COPY package*.json ./
RUN npm install

# Copy source
COPY . .

# Build frontend
RUN npm run build


# ---------- Runtime stage ----------
FROM node:22-alpine

WORKDIR /app

# Install production dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Copy runtime files only
COPY --from=builder /app/index.js ./
COPY --from=builder /app/dist ./dist

EXPOSE 5000

CMD ["npm", "start"]



