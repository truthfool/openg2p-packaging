# Infrastructure

## K8S infra setup

- Configure firewall based on rules [here](https://docs.rke2.io/install/requirements/#networking) on each node. (TODO: automate this, with ansible and ufw).
- For the firs server node:
  - Configure `rke2-server.conf.primary.template`,
  - Ssh into node place the file to this path: `/etc/rancher/rke2/config.yaml`.
  - Run this to get download rke2.
    ```sh
    curl -sfL https://get.rke2.io | sh -
    ```
  - Run this to start rke2 server:
    ```sh
    systemctl enable rke2-server
    systemctl start rke2-server
    ```
- For subsequent server and agent nodes:
  - Configure `rke2-server.conf.subsequent.template` and `rke2-agent.conf.template`, with relevant ips for each node.
  - Ssh into each node place the relevant file to this path: `/etc/rancher/rke2/config.yaml`, based on whether its a worker, or manager/server. (If worker use agent file. If manager/server use server file).
  - Run this to get download rke2.
    ```sh
    curl -sfL https://get.rke2.io | sh -
    ```
  - To start rke2, use this 
    ```
    systemctl enable rke2-server
    systemctl start rke2-server
    ```
    or, based on server or agent.
    ```
    systemctl enable rke2-agent
    systemctl start rke2-agent
    ```
- TODO: automate above, with ansible.

## Istio Install

- To install istio and ingress, configure the istio-operator.yaml, and run
  ```
  istioctl operator init
  kubectl apply -f istio-operator.yaml
  ```

## Rancher Install
- Setup a different rke2 cluster, for rancher. But DONOT remove the stock ingress controller, in server config. No need to install istio.
- To install rancher use this:
  ```
  helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
  helm repo update
  helm install rancher rancher-latest/rancher \
    --namespace cattle-system \
    --create-namespace \
    --set hostname=rancher.openg2p.org \
    --set ingress.tls.source=tls-rancher-ingress
  ```
  - Configure/Create tls secret accordingly.
## Longhorn Install
- Use this to install longhorn. 
  [Longhorn Install as a Rancher App](https://longhorn.io/docs/1.3.2/deploy/install/install-with-rancher/)

## Keycloak Install
- Run the following to install Keycloak.
  ```
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo update
  helm install keycloak bitnami/keycloak \
    -n keycloak \
    --create-namespace \
    --version "7.1.18" \
    --set ingress.hostname=keycloak.openg2p.org \
    --set ingress.extraTls[0].hosts[0]=keycloak.openg2p.org \
    -f keycloak-values.yaml
  ```

## Integrate Rancher and Keycloak
- Integrate rancher and keycloak using this, [Rancher Auth - Keycloak (SAML)](https://docs.ranchermanager.rancher.io/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/authentication-config/configure-keycloak-saml)

## Import OpenG2P Cluster into Rancher.
- Navigate to Cluster Management section in Rancher.
- Click on `Import Existing` cluster. And follow the steps to import the openg2p cluster.