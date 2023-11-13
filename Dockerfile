# Stage 1: Build the application in a node environment
FROM node:14-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Uncomment if you have a build step
# RUN npm run build

# Stage 2: Setup the production environment
FROM node:14-alpine as production
ENV NODE_ENV=production
WORKDIR /app

# Copy everything from the builder stage
COPY --from=builder /app .

# Install only production dependencies
RUN npm install --only=production

# Use a non-root user for better security
USER node

# Expose the port the app runs on
EXPOSE 8080

# Run the application
# Make sure to point to the correct path for server.js
CMD [ "node", "server.js" ]

# Healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD node healthcheck.js

# Labels for documentation
LABEL maintainer="hknisci01@gmail.com"
LABEL version="1.0"
LABEL description="This is the production stage of our multi-stage Docker build."
