#Build docker images (2 tags: latest & generated id)
docker build -t switchaphon/multi-client:latest -t switchaphon/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t switchaphon/multi-server:latest -t switchaphon/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t switchaphon/multi-worker:latest -t switchaphon/multi-worker:$SHA -f ./worker/Dockerfile ./worker

#Push docker images to docker hub
docker push switchaphon/multi-client:latest
docker push switchaphon/multi-server:latest
docker push switchaphon/multi-worker:latest

docker push switchaphon/multi-client:$SHA
docker push switchaphon/multi-server:$SHA
docker push switchaphon/multi-worker:$SHA

#Apply k8s configuration files in folder ./k8s
kubectl -f ./k8s

#Deployment k8s deployment. Format: kubectl set image deployment/<deployment-config.file> <container-name>=<docker-hub-id>/<image-name>:<tag-version>
kubectl set image deployments/server-deployment server=switchaphon/multi-server:$SHA
kubectl set image deployments/client-deployment client=switchaphon/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=switchaphon/multi-worker:$SHA