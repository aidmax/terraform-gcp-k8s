# Kubernetes cluster on Google Cloud


This guide provides steps on how to setup a [Kubernetes](https://kubernetes.io)
cluster on Google Cloud Platform using Terraform, Packer and Ansible.  It does
not utilize Google Kubernetes Engine (GKE) and rely explicitly on Google Cloud
compute instances.

### Overview
The overall process looks as follows:
1. Add your ssh public key to a project level metadata, which allows your to
   connect and have sudo privileges on any instance within the project.
2. Create a custom CentOS-7 image with pre-installed Docker and Kubernetes
   packages using Packer and Ansible playbook.
3. Spin up a bunch of compute instances and provision a minimal viable
   Kubernetes cluster based on that image. Cluster creation is done in single
   master mode with 2 workers using [kubeadm](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/) utility.

### Costs
For `us-central1` region monthly preemtible price is:
* n1-standard-2 instance (master) -  *$14.60*
* f1-micro instance (nodes) - you receive free usage equivalent to the number of
  total hours within the current month, enough to run one instance without
  interruption for the entire month. 

[Free tier](https://cloud.google.com/free/) account would be enough for spinning
up the cluster in this guide.

See complete pricing info [here](https://cloud.google.com/compute/pricing)

By default, all the instances configured with preemtible schedule to reduce
overall cost. You can change it in `is_preemtible`variable [here](variables.tf)

### Pre-Requisites

#### Infra
* Google Cloud Project has to be created with billing enabled. 
* Google API service account with admin access to Cloud Compute Engine, 
  see [this guide](https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform) on how do that. 
  API account credentials JSON file has to be downloaded and placed on your
  workstation.
* SSH key pair should be generated in advance

#### Software
* [ gcloud ](https://cloud.google.com/sdk/install)
* [ terraform ](https://www.terraform.io/downloads.html)
* [ packer ](https://www.packer.io/downloads.html)
* [ ansible ](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* [jq](https://stedolan.github.io/jq/)
* [ direnv ](https://direnv.net) (optional)

You can install those on Mac using next oneliner:
```bash
brew install terraform packer ansible jq direnv
```

#### Testing related software
* [shellcheck](https://github.com/koalaman/shellcheck)
* [yamllint](https://github.com/adrienverge/yamllint)
* [ansible-lint](https://github.com/ansible/ansible-lint)
* [Python3](https://www.python.org/downloads/)

#### Environment variables
In order to handle credentials it is convenient to use some file with exports. [ direnv ](https://direnv.net) utility can help to automate loading the environment variables when you chdir into some folder, [here is an example](envrc_example). Create *.envrc* file and adjust it according to your needs beforehand. Just do not forget to add the exclusion to [.gitignore](.gitignore) file. 
The .envcr file should contain the following:
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
export TF_VAR_ssh_private_key="$HOME/.ssh/your_ssh_private_key_filename"
export TF_VAR_ssh_user="your_ssh_key_username"
```
In case of using `direnv` add the following line at the end of the ~/.bashrc or
.bash_profile file:
```bash
eval "$(direnv hook bash)"
```
and allow it to update your environment variables:
```bash
direnv allow
```
#### Remote backend configuration (optional)
You can store terraform backend file either in the repository root or inside a
remote storage in GCP. The second is a bit more convenient if you're going to
use this from different workstations or along with some other contributors.  

To create a remote backend storage perform the following commands in repository
root **after** git clone (see `Installing` section below):
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
#### SSH
Please make sure that key you use is loaded into your ssh-agent. See details
[here](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)

to check that `ssh-add -l` or `ssh-add -L`

## Installing

```bash
# Perform pre-requisite steps

# Clone this repo
git clone git@github.com:aidmax/terraform-gcp-k8s.git

# Create an image and push it to GCP
packer/build.sh

# (Optional) Setup remote backend (see above)

# Init terraform
terraform init
terraform plan
terraform apply

# Cleaning up (deleting cluster)
terraform destroy
```

## Running the tests

Using `test.sh` file located in repository root you can make some basic linting
and formatting corrections. This script requires testing utilities installed,
see pre-requisites [ above ](#Testing related software).

## Implementation details
Here some details which you may find useful:
* Terraform creates a VM based on the image linked via image_family `k8s` and retrieves the latest by default. So, whenever you update the image `terraform plan` and `terraform apply` commands will force you to re-create the cluster. 

## Built With

* [Terraform](https://www.terraform.io) - Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently
* [Packer](https://packer.io) - Packer is an open source tool for creating identical machine images for multiple platforms from a single source configuration
* [Ansible](https://ansible.com) - Ansible is a radically simple IT automation engine that automates cloud provisioning, configuration management, application deployment, intra-service orchestration, and many other IT needs

## TODO
* reserve static ip address for master using [this](https://www.terraform.io/docs/providers/google/r/compute_address.html)

## License
MIT
See [LICENSE](LICENSE)

## Contributing

TBD

## Authors

* **Maksim Milykh** - *Initial work* - [aidmax](https://github.com/aidmax)

## Acknowledgments

* TBD
* TBD
* TBD

