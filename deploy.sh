docker build -t switchaphon/multi-client:latest -t switchaphon/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t switchaphon/multi-server:latest -t switchaphon/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t switchaphon/multi-worker:latest -t switchaphon/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push switchaphon/multi-client:latest
docker push switchaphon/multi-server:latest
docker push switchaphon/multi-worker:latest

docker push switchaphon/multi-client:$SHA
docker push switchaphon/multi-server:$SHA
docker push switchaphon/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=switchaphon/multi-server:$SHA
kubectl set image deployments/client-deployment client=switchaphon/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=switchaphon/multi-worker:$SHA