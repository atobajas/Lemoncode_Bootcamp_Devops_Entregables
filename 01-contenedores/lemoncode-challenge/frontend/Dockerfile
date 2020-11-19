FROM node:latest
ENV NODE_ENV=production
ENV REACT_APP_API_URL=http://localhost:5000/api/topics
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../
COPY . .
EXPOSE 3000
CMD ["npm", "start"]