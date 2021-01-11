## Pasos para ejecutar en local:
1. ejecutar npm install en C:\bootcamp-devops-lemoncode\Github\02-orquestacion\exercises\02-distributed\todo-api\
2. ejecutar npm install en C:\bootcamp-devops-lemoncode\Github\02-orquestacion\exercises\02-distributed\todo-front\
con esto se generarán las dependencias. Sólo es necesario la primera vez o por cambios del código fuente.
3. desde cada directorio anterior ejecutar npm start en sendas consolas
4. desde un navegador acceder a http://localhost para probar la web.


## Pasos para crear y subir imagenes Docker:
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
	docker run -d -p 8080:80 --name todo-front atobajas/todo-front
Desde nuestro ordenador navegar a http://localhost:8080

## Kubernetes
# Preparativos de creación de imagen y subida al registry.
1a. Crear imagen utilizando el Dockerfile en C:\bootcamp-devops-lemoncode\Entregables\02-Kubernetes\02-distributed\todo-front: 
	docker build -t atobajas/todo-front:v1 --build-arg API_HOST=http://lc-todo.edu .
1b. Crear imagen utilizando el Dockerfile en C:\bootcamp-devops-lemoncode\Entregables\02-Kubernetes\02-distributed\todo-api:
	docker build -t atobajas/todo-api .
2a. Subir imagen a mi registry Docker Hub:
	# Es necesario subir la imagen al registry para poder utilizar en Kubernetes.
	docker push atobajas/todo-front:v1
2b. Subir imagen a mi registry Docker Hub:
	# Es necesario subir la imagen al registry para poder utilizar en Kubernetes.
	docker push atobajas/todo-api .

# Con este comando se ve el yaml para el deploy.
kubectl create deploy todo-api-distributed --image=atobajas/todo-api --dry-run=client -o yaml
kubectl create deploy todo-front-distributed --image=atobajas/todo-front:v1 --dry-run=client -o yaml

# Con este comando se ve el yaml del servicio.
kubectl expose deployment/todo-api-distributed --port 3000 --name todo-api-distributed-svc --type ClusterIP --dry-run=client -o yaml
kubectl expose deployment/todo-front-distributed --port 80 --name todo-front-distributed-svc --type ClusterIP --dry-run=client -o yaml

# Para desplegar los deploys y el service desde fichero.
kubectl create -f ./todoapi-deploy.yml
kubectl create -f ./todofront-deploy.yml

# Para eliminar los deploys y el service desde fichero.
kubectl delete -f ./todoapi-deploy.yml
kubectl delete -f ./todofront-deploy.yml

# Para hacer pruebas desde nuestro ordenador sin el servicio Ingress.
 kubectl port-forward service/todo-api-distributed-svc 3000:3000
 kubectl port-forward service/todo-front-distributed-svc 8080:80
   y desde un navegador web acceder a http://localhost:8080

# Para crear de forma imperativa un configmap que tenga una colección con nuestras variables de entorno:
 kubectl create cm apiconfig --from-literal NODE_ENV=production --from-literal PORT=3000

# Para desplegar los deploys con configmap (2 opciones) y el service desde fichero.
  kubectl create -f ./todoapi-deploy-configmap-env.yml
  kubectl create -f ./todoapi-deploy-configmap-envFrom.yml

# Instalar controlador Ingress NGINX en Docker Desktop. 
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.43.0/deploy/static/provider/cloud/deploy.yaml
     (si se utiliza Minikube ver: https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/)
  kubectl get svc -n ingress-nginx (para ver la ip externa del controlador Ingress)

# Para desplegar los Ingress. (no existe comando kubectl imperativo)
  kubectl create -f ./todoapi-ingress.yml
  kubectl create -f ./todofront-ingress.yml
  Desde nuestro odenador navegar a http://lc-todo.edu