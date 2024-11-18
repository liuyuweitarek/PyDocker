# PyDocker
A simple Python Docker workspace template for developing Python projects within Docker containers.

Features:

- Easy to use with `docker-compose`.
- For Python 3.8+, you can also use with `poetry` to manage Python packages.
- GPU support.

## Usage
1. Congfigure

    **docker-compose.yml**

    ```yaml
    build:
      context: .
      dockerfile: Dockerfile
      args:
        PROJECT_NAME: "python-playground" # Name you project and  init for you
        UBUNTU_VERSION: "22.04"    # Choose ubuntu version
        PYTHON_VERSION: "3.10"     # Choose python version
        POETRY_VERSION: "1.8.1"    # Choose poetry version
    ```

2. Start the development environment:

    ```bash
    $ docker-compose up -d 
    ```

3. Access docker container terminal with:

    ```bash
    $ docker exec -it python-playground /bin/bash
    ```

    Exit terminal with `CTRL + D`.

4. Stop docker container with:

    ```bash
    $ docker compose down
    ```

5. Add packages

    - See more details in [Poetry Document](https://python-poetry.org/docs/).

    e.g. Install cuda available `torch`:
    
    ```bash
    $ poetry source add --priority=explicit pytorch-gpu https://download.pytorch.org/whl/cu118
    $ poetry add --source pytorch-gpu torch torchvision torchaudio
    ```

## How to Retain Installed Packages in the Container from the Last Development Session?

Needed to rebuild the Docker image.

On your terminal:

```bash
$ docker compose down
$ docker compose up --build -d
```