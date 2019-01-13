FROM alpine:3.8

MAINTAINER Maksim Milykh <aidmax@mail.ru>

ENV TERRAFORM_VERSION=0.11.10
ENV PACKER_VERSION=1.3.3


USER root
# RUN apk --no-cache add curl unzip python py-pip gettext procps jq && \
#     apk --no-cache add --virtual=build gcc libffi-dev musl-dev openssl-dev python-dev python3-dev make && \
#     pip install pip==${PIP_VERSION} && \
#     pip install awscli s3cmd azure-cli==${AZURE_CLI_VERSION} && \
#     apk del --purge build

RUN apk add --no-cache \
    curl \
    unzip \
    bash \
    python \
    py-pip \
    git \
    openssh \
    make \
    libffi-dev \
    jq  
    
# Install Terraform
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install Packer
RUN curl https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip -o packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip -d /usr/local/bin && \
    rm -f packer_${PACKER_VERSION}_linux_amd64.zip  && \
    ln -s /usr/local/bin/packer /usr/local/bin/packer-io
    
CMD terraform version && packer version
