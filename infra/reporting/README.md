# Reporting Framework

- For the purposes of the current integration, we will be using [mosip/reporting](https://github.com/mosip/reporting) framework

## Instructions

- Run the following to install Elasticsearch Stack
  ```sh
  ./es-install.sh
  ```
- Run the following to install reporting
  ```sh
  ./install.sh
  ```
- Modify virtualservice.yaml with correct hostnames. And apply. Using:
  ```sh
  kubectl -n reporting apply -f virtualservice.yaml
  ```
