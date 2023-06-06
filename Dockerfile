# Stage 1: Compile and Build angular codebase
# Use official node image as the base image
FROM node:latest as builder
# Set the working directory
WORKDIR /app
# Add the source code to app
COPY package.json package-lock.json ./
# Install all the dependencies
RUN npm install --force
COPY . .
# Generate the build of the application
RUN npm run build

FROM nginx:1.20
# Angular
ENV JSFOLDER=/opt/app/*.js
COPY ./nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /opt/app && chown -R nginx:nginx /opt/app && chmod -R 775 /opt/app
RUN chown -R nginx:nginx /var/cache/nginx && \
   chown -R nginx:nginx /var/log/nginx && \
   chown -R nginx:nginx /etc/nginx/conf.d
RUN touch /var/run/nginx.pid && \
   chown -R nginx:nginx /var/run/nginx.pid
RUN chgrp -R root /var/cache/nginx /var/run /var/log/nginx /var/run/nginx.pid && \
   chmod -R 775 /var/cache/nginx /var/run /var/log/nginx /var/run/nginx.pid
COPY ./start-nginx.sh /usr/bin/start-nginx.sh
RUN chmod +x /usr/bin/start-nginx.sh

EXPOSE 3000 
WORKDIR /opt/app
# Angular
COPY --from=builder --chown=nginx /app/build . 
RUN chmod -R a+rw /opt/app
USER nginx
ENTRYPOINT [ "start-nginx.sh" ]