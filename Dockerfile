# 1. Pull the official NGINX web server image from Docker Hub (Alpine is a tiny, fast Linux version)
FROM nginx:alpine

# 2. Delete the default NGINX index page
RUN rm /usr/share/nginx/html/index.html

# 3. Copy OUR custom index.html from your laptop into the container image
COPY index.html /usr/share/nginx/html/index.html

# 4. Expose port 80 so traffic can reach the web server
EXPOSE 80