# Base image: .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0

# Environment variables
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV PATH="/root/.dotnet/tools:${PATH}"

# Install Docker and development tools in a single layer
RUN curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh get-docker.sh \
    && rm get-docker.sh \
    && apt-get -y update \
    && apt-get install -y build-essential libvips-dev git \
    && dotnet tool install --global KCmd \
    && curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

# Verify installations and versions
RUN echo 'dotnet version:' $(dotnet --version) \
    && echo 'kcmd:' $(kcmd where) \
    && echo 'docker version:' $(docker -v) \
    && echo 'node version:' $(node -v) \
    && echo 'npm version:' $(npm -v) \
    && echo 'python version:' $(python3 --version) \
    && echo 'git version:' $(git --version)
