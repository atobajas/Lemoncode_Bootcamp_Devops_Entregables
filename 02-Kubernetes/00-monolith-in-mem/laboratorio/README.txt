# Pasos para ejecutar en local:
1. ejecutar npm install en C:\bootcamp-devops-lemoncode\Github\02-orquestacion\exercises\01-monolith\todo-app\
2. ejecutar npm install en C:\bootcamp-devops-lemoncode\Github\02-orquestacion\exercises\01-monolith\todo-app\frontend\
con esto se generarán las dependencias.
3. desde el último directorio ejecutar npm run start:dev:server
4. desde un navegador acceder a http://localhost:8081 para probar la web.


# Pasos dados con todoapp para crear y subir imagen Docker:
1. Crear imagen utilizando el Dockerfile en C:\bootcamp-devops-lemoncode\Entregables\02-Kubernetes\00-monolith-in-mem\todo-app: 
	docker build -t atobajas/lc-todo-monolith .
2. Subir imagen a mi registry Docker Hub:
	# Es necesario subir la imagen al  registry para poder utilizar en Kubernetes.
	docker push atobajas/lc-todo-monolith:latest
3. Para probar el contenedor http://localhost:8080 (en este caso usará el port 3000 aunque nosotros presentemos el 8080)
	# Para ejecutar comandos en multi linea separador es :
	#  Powershell: `
	#  CMD: ^
	#  bash: \  
	docker run -d -p 8080:3000 \
	    -e NODE_ENV=production \
	    -e PORT=3000 \
	    atobajas/lc-todo-monolith


# Kubernetes
# Con este comando se ve el yaml para el deploy.
kubectl create deploy todoapp --image=atobajas/lc-todo-monolith --dry-run=client -o yaml

# Con este comando se ve el yaml del servicio.
kubectl expose deployment/todoapp --port 8080 --target-port=8080 --name todoapp-svc --type LoadBalancer --dry-run=client -o yaml

# Para desplegar el deploy y el servicio del fichero todoapp-deploy.yml
kubectl create -f ./todoapp-deploy.yml

# Para eliminar el deploy y el servicio del fichero todoapp-deploy.yml
kubectl delete -f ./todoapp-deploy.yml