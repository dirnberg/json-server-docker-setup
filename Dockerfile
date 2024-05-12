FROM node:latest
WORKDIR /app
RUN npm install -g json-server
RUN echo '{"cars":[{"id":1,"brand":"opel","model":"corsa"},{"id":2,"brand":"ford","model":"fiesta"}]}' > /app/db.json
EXPOSE 8080
CMD ["json-server", "--watch", "/app/db.json", "--port", "8080", "--host", "0.0.0.0"]
