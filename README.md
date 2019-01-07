# Kubernetes cluster on Google Cloud

This guide provides steps on how to setup a k8s cluster on Google Cloud Platform using Terraform, Packer and Ansible.
It does not utilize Google Kubernetes Engine (GKE) and rely explicitly on Google Cloud compute instances.

### Prerequisites

#### Infra
* Google Cloud Project has to be created with billing enabled. Free tier account would be enough for spinning up the cluster in this guide.
* Google API service account with admin access to Cloud Compute Engine, see [this guide](https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform) on how do that. API account credentials JSON file must be downloaded and placed on your workstation.
* Ssh key pair should be generated

#### Software
* [ gcloud ](https://cloud.google.com/sdk/install)
* [ terraform ]
* [ packer ]
* [ ansible ]
* [ direnv ] (optional)
```
TBD
```

### Installing

TBD

## Running the tests

TBD


## Deployment

TBD

## Built With

* [Terraform](https://www.terraform.io) - Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently
* [Packer](https://packer.io) - Packer is an open source tool for creating identical machine images for multiple platforms from a single source configuration
* [Ansible](https://ansible.com) - Ansible is a radically simple IT automation engine that automates cloud provisioning, configuration management, application deployment, intra-service orchestration, and many other IT needs

## Contributing

TBD

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Maksim Milykh ** - *Initial work* - [aidmax](https://github.com/aidmax)

## Acknowledgments

* TBD
* TBD
* TBD

