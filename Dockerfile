FROM alpine:3.8

MAINTAINER Maksim Milykh <aidmax@mail.ru>

ENV TERRAFORM_VERSION=0.11.10
ENV PACKER_VERSION=1.3.3
ENV PIP_VERSION=18.1

COPY . /workspace/
WORKDIR /workspace

USER root

RUN apk add --no-cache curl unzip bash python py-pip git openssh libffi-dev jq grep && \
    apk --no-cache add --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev python3-dev make && \
    pip install pip==${PIP_VERSION}
    
# Install Terraform
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    terraform init

# Install Packer
RUN curl https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -o packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm -f packer_${PACKER_VERSION}_linux_amd64.zip  && \
    ln -s /usr/local/bin/packer /usr/local/bin/packer-io

# Install shellcheck
RUN wget https://github.com/koalaman/shellcheck/releases/download/latest/shellcheck-latest.linux.x86_64.tar.xz && \
    tar xvfJ shellcheck-latest.linux.x86_64.tar.xz && \
    chmod +x shellcheck-latest/shellcheck && \
    mv shellcheck-latest/shellcheck /usr/bin/shellcheck && \
    rm shellcheck-latest.linux.x86_64.tar.xz && \
    rm -rf shellcheck-latest

# Install yamllint and ansible-lint
RUN pip install yamllint ansible-lint

RUN ./test.sh    
