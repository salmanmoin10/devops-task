# Use official Node.js LTS image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy app source code and explicitly the image file
COPY . .
COPY logoswayatt.png . 

# Expose port
EXPOSE 8080

# Start the app
CMD ["npm", "start"]
