
FROM node:20 AS build

WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./

RUN npm install

# Copy rest of the project
COPY . .

# Build Angular app (production)
RUN npm run build

# =========================
# Stage 2: Serve with Nginx
# =========================
FROM nginx:alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy Angular build output very very imp: kind of mapping angular index file to nginx index file
COPY --from=build /app/dist/my-angular-app/browser /usr/share/nginx/html

# Custom nginx config (for Angular routing) configuring
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
