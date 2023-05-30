## Install Minio on OpenG2P Cluster

- Run the following commands from the current directory to install minio, on openg2p cluster.
  ```sh
  helm repo add bitnami https://charts.bitnami.com/bitnami
  kubectl create ns minio
  helm -n minio install minio bitnami/minio -f values-minio.yaml
  ```