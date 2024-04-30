# Base image: .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0

# Environment variables
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV PATH="/root/.dotnet/tools:${PATH}"
ENV PATH="/usr/local/bin/gh/bin:${PATH}"

# Install Docker, development tools, and GitHub CLI in a single layer
RUN curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh get-docker.sh \
    && rm get-docker.sh \
    && apt-get -y update \
    && apt-get install -y build-essential libvips-dev git jq \
    && dotnet tool install --global KCmd \
    && curl -sL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    # Install GitHub CLI
    && latest_release_url=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | jq -r '.assets[] | select(.name | endswith("linux_amd64.tar.gz")) | .browser_download_url') \
    && curl -L $latest_release_url -o /tmp/gh.tar.gz \
    && mkdir -p /usr/local/bin/gh \
    && tar -xzf /tmp/gh.tar.gz -C /usr/local/bin/gh --strip-components=1 \
    && chmod +x /usr/local/bin/gh/bin/gh \
    && rm /tmp/gh.tar.gz

# Verify installations and versions
RUN echo 'dotnet version:' $(dotnet --version) \
    && echo 'kcmd:' $(kcmd where) \
    && echo 'docker version:' $(docker -v) \
    && echo 'node version:' $(node -v) \
    && echo 'npm version:' $(npm -v) \
    && echo 'python version:' $(python3 --version) \
    && echo 'git version:' $(git --version) \
    && echo 'GitHub CLI version:' $(gh --version)
