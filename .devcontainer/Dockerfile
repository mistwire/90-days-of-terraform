FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG TERRAFORM_VERSION=1.10.3
ARG GO_VERSION=1.22.5

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    git \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_$(dpkg --print-architecture).zip" -o terraform.zip \
    && unzip terraform.zip -d /usr/local/bin/ \
    && rm terraform.zip \
    && terraform version

# Install Go
RUN curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-$(dpkg --print-architecture).tar.gz" -o go.tar.gz \
    && tar -C /usr/local -xzf go.tar.gz \
    && rm go.tar.gz

ENV PATH="/usr/local/go/bin:${PATH}"

# Install AWS CLI v2
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ]; then ARCH="x86_64"; elif [ "$ARCH" = "arm64" ]; then ARCH="aarch64"; fi \
    && curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o awscliv2.zip \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws
