## Pasos para ejecutar en local:
0a. crear contenedor con el motor de Postgres:
  docker run --rm -d -p 5432:5432 --name postgres postgres:10.4
0b. crear tablas y añadir datos a la base de datos
  docker exec -it postgres psql -U postgres
    en el prompt de psql copiar y pegar el contenido del fichero:
      C:\bootcamp-devops-lemoncode\Github\02-orquestacion\exercises\01-monolith\todo-app\todos_db.sql
    para salir del prompt teclear \q
  o
    cd C:\bootcamp-devops-lemoncode\Github\02-orquestacion\exercises\01-monolith\todo-app\
    docker exec -i postgres psql -U postgres < todos_db.sql

1a. crear fichero con las variables de entorno:
  C:\bootcamp-devops-lemoncode\Github\02-orquestacion\exercises\01-monolith\todo-app\.env
  NODE_ENV=develop
  PORT=3000
  DB_HOST=localhost
  DB_USER=postgres
  DB_PASSWORD=postgres
  DB_PORT=5432
  DB_NAME=todos_db
  DB_VERSION=10.4
1b. ejecutar npm install en C:\bootcamp-devops-lemoncode\Github\02-orquestacion\exercises\01-monolith\todo-app\
1c. ejecutar npm install en C:\bootcamp-devops-lemoncode\Github\02-orquestacion\exercises\01-monolith\todo-app\frontend\
con esto se generarán las dependencias.
3. desde el último directorio ejecutar npm run start:dev:server
4. desde un navegador acceder a http://localhost:8081 para probar la web.


## Pasos dados con todoapp para crear y subir imagen Docker:
0. crear red para que se vean los contenedores.
  docker create network lemoncode
1. crear contenedor para Postgres:
  docker run -d --network lemoncode -p 5432:5432 -v todos:/var/lib/postgresql/data --name postgres postgres:10.4
  si la bd está sin inicializar:
    cd C:\bootcamp-devops-lemoncode\Github\02-orquestacion\exercises\01-monolith\todo-app\
    docker exec -i postgres psql -U postgres < todos_db.sql
    (como hemos creado un volumen al correr el contenedor no será necesario volver a inicializar)
2. Crear imagen utilizando el Dockerfile en C:\bootcamp-devops-lemoncode\Entregables\02-Kubernetes\01-monolith\todo-app: 
	docker build -t atobajas/lc-todo-monolith:sql .
3. Subir imagen a mi registry Docker Hub:
	# Es necesario subir la imagen al registry para poder utilizar en Kubernetes.
	docker push atobajas/lc-todo-monolith:sql
4. Para probar el contenedor http://localhost:8080 (en este caso usará el port 3000 aunque nosotros presentemos el 8080)
	# Para ejecutar comandos en multi linea separador es :
	#  Powershell: `
	#  CMD: ^
	#  bash: \  
	docker run -d --network lemoncode -p 8080:3000 \
	  -e NODE_ENV=production \
	  -e PORT=3000 \
	  -e DB_HOST=postgres \
	  -e DB_USER=postgres \
	  -e DB_PASSWORD=postgres \
	  -e DB_PORT=5432 \
	  -e DB_NAME=todos_db \
	  -e DB_VERSION=10.4 \
	  --name lc-todo-sql \
	  atobajas/lc-todo-monolith:sql


## Kubernetes
# Preparativos de creación de imagen y subida al registry.
1. Crear imagen utilizando el Dockerfile en C:\bootcamp-devops-lemoncode\Entregables\02-Kubernetes\01-monolith\todo-app: 
	docker build -t atobajas/lc-todo-monolith:sql .
2. Subir imagen a mi registry Docker Hub:
	# Es necesario subir la imagen al registry para poder utilizar en Kubernetes.
	docker push atobajas/lc-todo-monolith:sql

# Para crear de forma imperativa un configmap que tenga una colección con nuestras variables de entorno:
 kubectl create cm apiconfig --from-literal NODE_ENV=production --from-literal PORT=3000 ... etc.

# Situarnos en C:\bootcamp-devops-lemoncode\Entregables\02-Kubernetes\01-monolith\todo-app\laboratorio

#Crear persistencia de datos.
1. Storageclass
  kubectl apply -f todoappsql-storageclass.yml
2. Persistentvolumen
  kubectl apply -f todoappsql-persistentvolume.yml
3. Claim para Postgres del anterior persistentvolumen
  kubectl apply -f todoappsql-persistentvolumeclaim.yml

# POSTGRES (con estado)
  kubectl apply -f todopostgres-statefulset-configmap-envFrom.yml

# FRONT/BACKEND
# Desplegar el configmap.
  kubectl apply -f todoappsql-configmap.yml

# Desplegar deploy web (front/back) usando configmap y el service desde fichero.
  kubectl apply -f todoappsql-deploy.yml

Para hacer pruebas desde un navegador del pc: 
  http://localhost:3000/