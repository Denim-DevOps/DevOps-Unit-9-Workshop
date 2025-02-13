FROM python:3.11

# Install the Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Terraform
RUN apt-get update && apt-get install -y gnupg software-properties-common
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update && apt-get install terraform

# Install npm/Node
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - &&\
apt-get install -y nodejs

# Install Terraform CDK (and associate dependencies)
RUN npm install --global cdktf-cli@latest
RUN pip install --user pipenv