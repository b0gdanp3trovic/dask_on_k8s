docker run -d -p 5000:5000 --name kind-registry registry:2
docker network disconnect kind kind-registry
docker build -t dask-jupyter:latest -f Dockerfile.jupyter .
docker tag dask-jupyter:latest localhost:5000/dask-jupyter:latest
docker push localhost:5000/dask-jupyter:latest
docker network connect kind kind-registry