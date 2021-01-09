# Pasos dados con todoapp para crear y subir imagen Docker:
1. Crear imagen utilizando el Dockerfile: docker build -t atobajas/lc-todo-monolith .
2. Para probar el contenedor  http://localhost:8080 (en este caso usará el port 3000 aunque nosotros presentemos el 8080)
  docker run -d -p 8080:3000 \
    -e NODE_ENV=production \
    -e PORT=3000 \
    atobajas/lc-todo-monolith
3. docker push atobajas/lc-todo-monolith:latest

# Con este comando se ve el yaml para el deploy.
kubectl create deploy todoapp --image=atobajas/lc-todo-monolith --dry-run=client -o yaml

# Con este comando se ve el yaml del servicio.
kubectl expose deployment/todoapp --port 8080 --target-port=8080 --name todoapp-svc --type LoadBalancer --dry-run=client -o yaml

# Para desplegar el deploy y el servicio del fichero todoapp-deploy.yml
kubectl create -f ./todoapp-deploy.yml