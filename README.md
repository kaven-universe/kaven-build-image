# [kaven-build-image](https://github.com/kaven-universe/kaven-build-image)

[kavenzero/kaven-build-image](https://hub.docker.com/r/kavenzero/kaven-build-image)

## Overview

This Docker project contains a Dockerfile that builds a Docker image with the following components:

* .NET SDK LTS(8.0)
* Docker CLI
* Node.js LTS(22.x)
* GitHub CLI
* Other development tools

The image is designed for development and CI/CD workflows, providing a comprehensive environment with a variety of development tools.

## Running a Docker Container

To run a container from the built Docker image, use the following command:

```bash
docker run --rm -it --entrypoint /bin/bash kavenzero/kaven-build-image:latest
```

This command starts an interactive (`-it`) container using the built Docker image and opens a shell (`/bin/bash`).
