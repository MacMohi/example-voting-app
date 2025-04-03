FROM ubuntu:latest

ARG HOME=/home/ubuntu

# install dependencies and prerequisites
RUN apt -y update && apt -y  install vim curl unzip git

WORKDIR $HOME

# copy Azure credentials
COPY ".azure" $HOME/.azure
RUN chown -R ubuntu:ubuntu .azure

# install kubernetes
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x kubectl && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && rm kubectl
# helm tool already available on my host, otherwise get it from here: https://helm.sh/docs/intro/install/
COPY "helm_3-17-2/helm" /usr/local/bin

# install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# connect to Azure subscription, you may connect to any managed k8s service
RUN az account set --subscription XXXXXbbe-YYYY-416d-XXX-ZZZZbXXXXY
RUN az aks get-credentials --resource-group default-resource --name voting-cluster --overwrite-existing

RUN git clone https://github.com/dockersamples/example-voting-app.git
RUN chown -R ubuntu:ubuntu .

USER ubuntu

CMD ["/bin/bash"]