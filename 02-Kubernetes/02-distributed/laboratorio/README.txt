# Pasos para ejecutar en local:
1. ejecutar npm install en C:\bootcamp-devops-lemoncode\Github\02-orquestacion\exercises\02-distributed\todo-api\
2. ejecutar npm install en C:\bootcamp-devops-lemoncode\Github\02-orquestacion\exercises\02-distributed\todo-front\
con esto se generarán las dependencias. Sólo es necesario la primera vez o por cambios del código fuente.
3. desde cada directorio anterior ejecutar npm start en sendas consolas
4. desde un navegador acceder a http://localhost para probar la web.


# Pasos dados para crear y subir imagenes Docker:
# API backend.
1. Crear imagen utilizando el Dockerfile en C:\bootcamp-devops-lemoncode\Entregables\02-Kubernetes\02-distributed\todo-api: 
	docker build -t atobajas/todo-api .
2. Subir imagen a mi registry Docker Hub:
	# Es necesario subir la imagen al  registry para poder utilizar en Kubernetes.
	docker push atobajas/todo-api
3. Para probar el contenedor http://localhost:3000/api
	# Para ejecutar comandos en multi linea separador es :
	#  Powershell: `
	#  CMD: ^
	#  bash: \  
	docker run -d -p 3000:3000 \
	    -e NODE_ENV=production \
	    -e PORT=3000 \
	    --name todo-api \
	    atobajas/todo-api
# Frontend.
1. Crear imagen utilizando el Dockerfile en C:\bootcamp-devops-lemoncode\Entregables\02-Kubernetes\02-distributed\todo-front: 
	docker build -t atobajas/todo-front --build-arg API_HOST=http://localhost:3000 .
2. Subir imagen a mi registry Docker Hub:
	# Es necesario subir la imagen al registry para poder utilizar en Kubernetes.
	docker push atobajas/todo-front
3. Para probar el contenedor http://localhost
	docker run -d -p 80:80 --name todo-front atobajas/todo-front


# Kubernetes
# Con este comando se ve el yaml para el deploy.
kubectl create deploy todo-api-distributed --image=atobajas/todo-api --dry-run=client -o yaml
kubectl create deploy todo-front-distributed --image=atobajas/todo-front --dry-run=client -o yaml

# Con este comando se ve el yaml del servicio.
kubectl expose deployment/todo-api-distributed --port 3000 --name todo-api-distributed-svc --type ClusterIP --dry-run=client -o yaml
kubectl expose deployment/todo-front-distributed --port 80 --name todo-front-distributed-svc --type ClusterIP --dry-run=client -o yaml

# Para desplegar los desplieges y el servicios desde fichero.
kubectl create -f ./todo-api-distributed-deploy.yml
kubectl create -f ./todo-front-distributed-deploy.yml

# Para eliminar los desplieges y el servicios desde fichero.
kubectl delete -f ./todo-api-distributed-deploy.yml
kubectl delete -f ./todo-front-distributed-deploy.yml

# Para hacer pruebas desde nuestro ordenador sin el servicio Ingress.
 kubectl port-forward service/todo-api-distributed-svc 3000:3000
 kubectl port-forward service/todo-api-distributed-svc 8080:80
y desde un navegador web acceder a http://localhost:8080