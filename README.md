# PyDocker
A simple Python Docker workspace template for developing Python projects within Docker containers.

You could use this template to start/containerize a development environment for your Python project.

## Usage

1. Congfigure

    **docker-compose.yml**

    ```yaml
    build:
      context: .
      dockerfile: Dockerfile
      args:
        PROJECT_NAME: "my-project" # Name you project and  init for you
        UBUNTU_VERSION: "22.04"    # Choose ubuntu version
        PYTHON_VERSION: "3.10"     # Choose python version
    develop:
      watch:
        - action: sync
          path: ./my-project       # Don't forget to modify the default folder name to your project name here!
    ```

2. Start the development environment:

    ```bash
    $ docker compose up -d 
    ```

    Now you will find that your `{PROJECT_NAME}` folder appears in the current directory and the container is running.

    From,

    ```
    .
    ├── ...
    ├── Dockerfile
    ├── docker-compose.yml
    ```

    to,

    ```
    .
    ├── ...
    ├── {PROJECT_NAME}
        # See more details in https://docs.astral.sh/uv/concepts/projects/init/#applications.
        ├── (Default uv project structure)
    ├── Dockerfile
    ├── docker-compose.yml
    ```

3. Access docker container terminal with:

    ```bash
    $ docker exec -it dev /bin/bash
    ```

    Exit terminal with `CTRL + D`.

4. Stop docker container with:

    ```bash
    $ docker compose down
    ```

5. Add packages

    - See more details in [UV Document](https://docs.astral.sh/uv/concepts/projects/dependencies/#adding-dependencies).

    e.g. Install cuda available `torch`:
    
    ```bash
    $ uv lock --index https://download.pytorch.org/whl/cu118
    $ uv add numpy==1.26.4  torch==2.1.2
    ```

    P.S. [Torch-CUDA-PYTHON compatible version table](https://github.com/liuyuweitarek/Pytorch-Docker-Builder/blob/main/image-builder/config/compatible_versions.json)

## Q&A

1. **How to use GPU in container?**

    For gpu usage, ensure your system meets the following requirements:

    1. **Windows users need to enable WSL**  
        
        To run Docker with GPU support on Windows, you must enable Windows Subsystem for Linux (WSL).  
        
        Follow the instructions here: [Setting up WSL](https://liuyuweitarek.github.io/python-poetry-wsl2-ubuntu-gpu-docker-template/getting_started/prerequisites/windows-wsl.html).

    2. **Install Docker**  
        
        **Windows users:** Download and install [Docker Desktop](https://liuyuweitarek.github.io/python-poetry-wsl2-ubuntu-gpu-docker-template/getting_started/prerequisites/docker.html).  
        
        **Linux users:** Install Docker Engine following the instructions [here](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository).

    3. **Install CUDA Toolkit**  
        
        Ensure that your system has the CUDA Toolkit installed, which is necessary for GPU acceleration.  
        
        Refer to the guide: [Installing CUDA Toolkit](https://liuyuweitarek.github.io/python-poetry-wsl2-ubuntu-gpu-docker-template/getting_started/prerequisites/cuda-toolkit.html).

    4. **Install NVIDIA Container Toolkit**  
        
        This is required to enable Docker containers to use the GPU.  
        
        Follow the instructions to install the NVIDIA Container Toolkit [here](https://liuyuweitarek.github.io/python-poetry-wsl2-ubuntu-gpu-docker-template/getting_started/prerequisites/nvidia-container-toolkit.html).

    5 Test your gpu util with `test_gpu_util.py`.

2. **Do I need to reinstall packages in the container once it closed?**

    No need. The packages you intalled in the container will still be remained. All packages will be kept in the `{your-project-name}/.venv` which will be mounted to the container.