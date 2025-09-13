# Use official Node.js LTS image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy app source code
COPY . .

# Expose port (assuming your app listens on 3000)
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
