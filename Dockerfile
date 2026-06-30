# Base image: .NET SDK
FROM mcr.microsoft.com/dotnet/sdk:10.0

# Environment variables
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV PNPM_HOME="/root/pnpm"
ENV PATH="${PNPM_HOME}/bin:${PATH}"
ENV PATH="/root/.dotnet/tools:${PATH}"
ENV PATH="/usr/local/bin/gh/bin:${PATH}"

# Install Docker, development tools, GitHub CLI, Node.js, and acme.sh in a single layer
RUN apt-get -y update \
    && apt-get install -y git jq nano build-essential libvips-dev \
    # Docker
    && curl -fsSL https://get.docker.com -o get-docker.sh \
    && sh get-docker.sh \
    && rm get-docker.sh \
    # .NET tool
    && dotnet tool install --global KCmd \
    # Node.js & pnpm
    && curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g pnpm \
    && pnpm add -g kaven-utils \
    # GitHub CLI
    && latest_release_url=$(curl -s https://api.github.com/repos/cli/cli/releases/latest \
        | jq -r '.assets[] | select(.name | test("linux_amd64.tar.gz$")) | .browser_download_url') \
    && curl -fsSL $latest_release_url -o /tmp/gh.tar.gz \
    && mkdir -p /usr/local/bin/gh \
    && tar -xzf /tmp/gh.tar.gz -C /usr/local/bin/gh --strip-components=1 \
    && chmod +x /usr/local/bin/gh/bin/gh \
    && rm /tmp/gh.tar.gz \
    # Cleanup
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Verify installations and versions
RUN echo 'dotnet version:' $(dotnet --version) \
    && echo 'kcmd:' $(kcmd where) \
    && echo 'docker version:' $(docker -v) \
    && echo 'node version:' $(node -v) \
    && echo 'npm version:' $(npm -v) \
    && echo 'pnpm version:' $(pnpm -v) \
    && echo 'ku version:' $(ku -v) \
    && echo 'python version:' $(python3 --version) \
    && echo 'git version:' $(git --version) \
    && echo 'GitHub CLI version:' $(gh --version)