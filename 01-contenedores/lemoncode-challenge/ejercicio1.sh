# Para ejecutar comandos en multi linea separador es :
#  Powershell: `
#  CMD: ^
#  bash: \

# 1. Creamos una red bridge para el frontend, backend y el gestor de base de datos.
# al no ser la red bridge por defecto SI funciona el DNS resolver de Docker.
docker network create lemoncode-challenge
___________________________________________________________________________________

# 2. Creamos contenedor de Mongo
# Si no existe el volume mongo-volume se creará al generar el contenedor.
# también podríamos utlizar -v mongo-volume:/data/db en lugar de --mount
docker run --name mymongo -d `
    -p 27017:27017 `
    --network lemoncode-challenge `
    --mount src=mongo-volume,dst=/data/db `
    mongo
___________________________________________________________________________________

# 3. Creamos imagen ASP.NET Core para Backend
# Fichero Dockerfile
# en este caso la variable de entorno no la meto en la imagen y tendremos que dársela en cada
# container que generemos de dicha imagen.
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app
# Copia csproj
COPY *.csproj ./
# restaura las dependencias y las herramientas de un proyecto
RUN dotnet restore
# Copia todo y  everything else and build
COPY . ./
# compila la aplicación, lee sus dependencias especificadas en el archivo de proyecto y publica el conjunto resultante de archivos en un directorio
RUN dotnet publish -c Release -o out
# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
ENV MONGO_URI=mongodb://mymongo:27017
WORKDIR /app
EXPOSE 80
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "backend.dll"]

# Creamos imagen custom
docker build --tag backend .

# Creamos contenedor del API backend
docker run --name mybackend -d `
  -p 5000:80 `
  --network lemoncode-challenge `
  backend
  
# 4. Creamos imagen Node.js para Frontend React
# Fichero Dockerfile
# en este caso la variable de entorno la meto en la imagen y NO tendremos que dársela en cada
# container que generemos de dicha imagen.
FROM node:latest
ENV NODE_ENV=production
ENV REACT_APP_API_URL=http://localhost:5000/api/topics
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent && mv node_modules ../
COPY . .
EXPOSE 3000
CMD ["npm", "start"]

# Creamos imagen custom
docker build --tag frontend .

# Creamos contenedor del Frontend React
 docker run --name myfrontend -d `
   --network lemoncode-challenge `
   -p 3000:3000 `
   frontend
___________________________________________________________________________________

# Ver que los contenedores están en la red deseada.
 docker network inspect lemoncode-challenge