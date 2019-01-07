# Kubernetes cluster on Google Cloud
> The guide is currently under construction!

![under construction]( underconstruction.png )

This guide provides steps on how to setup a [Kubernetes](https://kubernetes.io)
cluster on Google Cloud Platform using Terraform, Packer and Ansible.  It does
not utilize Google Kubernetes Engine (GKE) and rely explicitly on Google Cloud
compute instances.

### Overview
The overall process looks as follows:
1. Add your ssh public key to a project level metadata, which allows your to
   connect and have sudo privileges on any instance within the project.
2. Create a custom image with pre-installed Docker and Kubernetes packages based
   on Centos-7 built-in Google Cloud compute image.
3. Spin up a Kubernetes cluster in single master mode with 2 worker nodes.

### Prerequisites

#### Infra
* Google Cloud Project has to be created with billing enabled. 
  [Free tier](https://cloud.google.com/free/) account would be enough for
  spinning up the cluster in this guide.
* Google API service account with admin access to Cloud Compute Engine, 
  see [this guide](https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform) on how do that. 
  API account credentials JSON file must be downloaded and placed on your
  workstation.
* Ssh key pair should be generated

#### Software
* [ gcloud ](https://cloud.google.com/sdk/install)
* [ terraform ](https://www.terraform.io/downloads.html)
* [ packer ](https://www.packer.io/downloads.html)
* [ ansible ](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* [ direnv ](https://direnv.net) (optional)

#### Testing related software
* [shellcheck](https://github.com/koalaman/shellcheck)
* [yamllint](https://github.com/adrienverge/yamllint)
* [ansible-lint](https://github.com/ansible/ansible-lint)
* [Python3](https://www.python.org/downloads/)

#### Environment variables
In order to handle credentials it is convenient to use some file with exports. [ direnv ](https://direnv.net) utility can help to automate loading the environment variables when you chdir into some folder, [here is an example](envrc_example). Create *.envrc* file and adjust it according to your needs beforehand. Just do not forget to add the exclusion to [.gitignore](.gitignore) file.
The .envcr file should consist of the following:
```bash
export TF_ADMIN="your_project_name"
export TF_CREDS="$HOME/your_service_account_filename.json"

export GOOGLE_PROJECT=${TF_ADMIN}
export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
export GOOGLE_CLOUD_KEYFILE_JSON=${TF_CREDS}
export CLOUDSDK_COMPUTE_REGION="your_region"
export CLOUDSDK_COMPUTE_ZONE="your_zone"

export TF_VAR_project=${TF_ADMIN}
export TF_VAR_region=${CLOUDSDK_COMPUTE_REGION}
export TF_VAR_zone=${CLOUDSDK_COMPUTE_ZONE}
export TF_VAR_ssh_public_key="$HOME/.ssh/your_ssh_public_key_filename.pub"
export TF_VAR_ssh_user="your_ssh_key_username"
```
#### Remote backend configuration
You can store terraform backend file either in the repository root or inside a
remote storage in GCP. The second is a bit more convenient if you're going to
use this from different workstations or along with some other contributors.  

To create a remote backend storage perform the commands:
```bash
gsutil mb -p ${TF_ADMIN} gs://${TF_ADMIN}
gsutil versioning set on gs://${TF_ADMIN}

cat > backend.tf <<EOF
terraform {
 backend "gcs" {
   bucket  = "${TF_ADMIN}"
   prefix  = "terraform/state"
   project = "${TF_ADMIN}"
 }
}
EOF
```
## Installing

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

## Authors

* **Maksim Milykh** - *Initial work* - [aidmax](https://github.com/aidmax)

## Acknowledgments

* TBD
* TBD
* TBD

