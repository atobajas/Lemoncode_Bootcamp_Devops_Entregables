docker-compose up (con -d se inicia todo en background)
docker-compose up --build (se generará la imagen cada vez que se lanze e compose)
docker compose down # elimina todos los contenedores parados (no borra volumenes)
docker-compose down --volumes
docker-compose ps
docker-compose stop
docker-compose rm
docker compose restart

#Listar todos los proyectos que se están ejecutando
docker ps -a --filter "label=com.docker.compose.project" -q | xargs docker inspect --format='{{index .Config.Labels "com.docker.compose.project"}}'| sort | uniq
