FROM node:alpine3.18 as build

# declare build time env varialbes
ARG VITE_PROD_API_URL
ARG VITE_PROD_REDIRECTION_URL

#set default values of env variables
ENV VITE_PROD_API_URL=${VITE_PROD_API_URL}
ENV VITE_PROD_REDIRECTION_URL=${VITE_PROD_REDIRECTION_URL}

#build app
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

#serve with nginx
FROM nginx:1.23-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf *
#copy fils from dist to nginx
COPY --from=build /app/dist .
# COPY --from=build /app/build .
EXPOSE 80
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]