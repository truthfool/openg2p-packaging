# OpenG2P Packaging

This repo contains scripts and instructions for packaging different components or implementations of OpenG2P into a docker and instructions to install them.

## Packaging Instructions

- Enter `packaging` folder
    ```sh
    cd packaging
    ```
- Configure packages.txt file. This file includes all openg2p modules to be packaged into a new docker. Each line describes one package to include, and the structure of each line looks like this.
    ```
    package_name = git://<github branch name>//<github url to pull from>
    package2_name = file://<path of the package in local system>
    ```
  - Any underscore in the package name will be converted to hyphen during installation. For example:
    ```
    package_name = git://<github branch name>//<github url to pull from>
    ```
    This is internally converted to `package-name`. 
- The above configuration can be made via environment variables also.
  - Any variable with the `G2P_PACKAGE_` prefix will be considered as package to install i.e., `G2P_PACKAGE_<package_name>`. For example;
    ```
    G2P_PACKAGE_package3_name=git://<github branch name>//<github url to pull from>
    ```
  - These env variables can be added in `.env` file (in the same folder). The `.env` file will automatically be considered.
  - If same package is available in `packages.txt`, `.env` and environment variable, then this will the preference order in which they are considered (highest to lowest).
    - `.env` file
    - Environment variable.
    - `packages.txt`
  - So use the `.env` to overload packages from `packages.txt` 
- Run the following to package:
    ```sh
    ./package.sh
    ```
- After packaging, run the following to build docker image:
    ```sh
    docker build . -t <docker image name>
    ```
- Then push the image.
    ```
    docker push <docker image name>
    ```
- Notes:
  - The above uses bitnami's odoo image as base.
  - This script also pulls in any OCA dependencies configured, in `oca_dependencies.txt` inside each package. Use this env variable to change the version of OCA dependencies to be pulled, `OCA_DEPENDENCY_VERSION` (defaults to `15.0`).
  - This also installs any python requirements configured in `requirements.txt` inside each package.

## Installation on Kubernetes Cluster
- This uses bitnami's odoo helm chart, as base.
- Go to helm directory.
- Run:
    ```sh
    ./install.sh 
    ```
- If use different docker image or tag use:
    ```sh
    ./install --set odoo.image.repository=<docker image name> --set odoo.image.tag=<docker image tag>
    ```

## Post Install Setup.
- Once server is up, login as admin. And enter `debug mode` on odoo.
- Go to _Settings_ -> _Technical_ -> _System Parameters_.
  - Confiugre `web.base.url` to your required base url.
  - Create another system parameter, with name `web.base.url.freeze`, and value `True`.
- Go to Apps sections on UI, click on _Update Apps List_ action on top.
- Search through and install required G2P Apps & Modules.
- After all apps are installed, proceed to create users and assigning roles.
- Donot use `admin` user after this step. Log back in as regular user.
- Configure `ID Types` on `Registry` -> `Configuration`. 


## Licenses

This repository is licensed under [MPL-2.0](LICENSE).

