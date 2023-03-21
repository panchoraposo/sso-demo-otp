FROM node:19-alpine3.16
WORKDIR /app
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    git clone https://github.com/panchoraposo/sso-demo-otp 
WORKDIR /app/sso-demo-otp
RUN npm install
EXPOSE 3000
CMD ["npm", "run", "dev"]