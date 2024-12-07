# Dockerfile for building Node.js image
FROM node:14

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and install dependencies
COPY backend ./backend
COPY frontend ./frontend
RUN npm install ./backend

# Expose the app's port
EXPOSE 3000

# ENV MONGODB_URL='mongodb://127.0.0.1:27017'
# Assuming that the container name of the mongodb is mongodb - in order to access the mongodb server using docker network:
    # We are using ${DOCKER_CONTAINER_NAME}:// to access the second container via network
ENV MONGODB_URL='mongodb://mongodb:27017'

# Run the app when the container starts
ENTRYPOINT ["node", "backend/index.js"]
