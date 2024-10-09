# syntax=docker/dockerfile:1.9
FROM ubuntu:noble

# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.4.18 /uv /bin/uv

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    git

# Install the project with intermediate layers
WORKDIR /app

# First, install the dependencies
ADD uv.lock /app/uv.lock
ADD pyproject.toml /app/pyproject.toml
RUN uv sync --frozen --no-install-project --no-dev

# Then, install the rest of the project
ADD . /app
RUN uv sync --frozen --no-dev

CMD ["uv", "run", "hello.py"]
