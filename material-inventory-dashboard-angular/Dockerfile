# Stage 1: Build the Angular application
FROM node:18 AS build

# Set working directory in container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all application code
COPY . .

# Build the Angular application for production
RUN npm run build -- --configuration production

# Stage 2: Serve the Angular application using Nginx
FROM nginx:alpine

# Copy the built application from the previous stage
COPY --from=build /app/dist/material-inventory-dashboard-angular/browser /usr/share/nginx/html

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Add custom nginx config
COPY nginx.conf /etc/nginx/conf.d

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
