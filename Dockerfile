ARG PROJECT_NAME \
    UBUNTU_VERSION \
    PYTHON_VERSION \
    POETRY_VERSION

FROM ubuntu:${UBUNTU_VERSION}

ARG PROJECT_NAME=${PROJECT_NAME} \
    UBUNTU_VERSION=${UBUNTU_VERSION} \
    PYTHON_VERSION=${PYTHON_VERSION} \
    POETRY_VERSION=${POETRY_VERSION}

ENV ROOT_DIR=/code \
  PROJECT_DIR=${PROJECT_NAME} \
  DEBIAN_FRONTEND=noninteractive \ 
  # Python configuration:
  PYTHON_VERSION=${PYTHON_VERSION} \
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \ 
  PYTHONDONTWRITEBYTECODE=1 \
  # Poetry's configuration:
  POETRY_VERSION=${POETRY_VERSION} \
  POETRY_HOME=/opt/poetry \
  POETRY_CACHE_DIR=/tmp/poetry_cache \
  POETRY_REQUESTS_TIMEOUT=3000 \
  POETRY_NO_INTERACTION=1 \
  POETRY_VIRTUALENVS_PREFER_ACTIVE_PYTHON=1 \
  POETRY_VIRTUALENVS_CREATE=0 \
  # NVIDIA configuration:
  NVIDIA_DRIVER_CAPABILITIES=${NVIDIA_DRIVER_CAPABILITIES:-compute,utility}

RUN apt-get update \
  && apt install --no-install-recommends -y curl wget build-essential gpg-agent software-properties-common \
  && add-apt-repository ppa:deadsnakes/ppa \
  && apt install -y python${PYTHON_VERSION}-venv python-is-python3 python3-pip \
  && ln -sf /usr/bin/python${PYTHON_VERSION} /usr/bin/python \
  && ln -sf /usr/bin/python${PYTHON_VERSION} /usr/bin/python3 \
  && curl -sSL https://install.python-poetry.org | python \
  && apt clean \
  && rm -rf /var/lib/apt/lists/*

ENV PATH=${POETRY_HOME}/bin:$PATH \
  PYTHONPATH=/usr/lib/python${PYTHON_VERSION}/site-packages:${PYTHONPATH}

WORKDIR /code


# COPY entrypoint.sh entrypoint.sh
RUN printf '#!/bin/bash\n\
if [ ! -d $PROJECT_DIR ]; then\n\
    poetry new $PROJECT_DIR;\n\
fi\n\
\n\
cd $PROJECT_DIR;\n\
\n\
if [ -f "pyproject.toml" ]; then\n\
    poetry install;\n\
fi\n\
\n\
exec "$@"\n' > /usr/local/bin/entrypoint.sh \
  && chmod +x /usr/local/bin/entrypoint.sh

# Ensure entrypoint is set in the same layer to reference the script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
