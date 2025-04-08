# example-voting-app monitored and scanned by Sysdig

Build secure pipeline with Jenkins and push binaries to repository that are scanned by Sysdig

## Why Sysdig

Sysdig tools designed for cloud native environment and offer benefits like unified security monitoring across hybrid environments and real-time threat detection.

#### Unified Security Monitoring:
Sysdig provide a single platform for monitoring and securing containers, Kubernetes, and cloud environments, simplifying management and reducing the need for multiple tools.

#### Real-time Threat Detection:
Sysdig enables real-time threat detection and response, allowing organizations to identify and address potential issues quickly, rather than waiting for post-incident analysis.

#### Simplified Compliance:
Sysdig's comprehensive security features and real-time visibility make it easier to demonstrate compliance with industry regulations and standards.

#### Resource Efficiency:
Consolidating security functions into a single platform, Sysdig can help reduce the need for specialized personnel and resources, leading to cost savings.

#### Enhanced Visibility:
Sysdig provides deep visibility into containerized environments, enabling teams to understand application performance, security posture, and identify potential vulnerabilities.

#### Automated Security:
Sysdig offer automated security features, such as vulnerability scanning, runtime protection, and threat detection, reducing the burden on security teams.

#### Focus on the most pressing issues:
Sysdig enables users to autotune the solution to focus on the most pressing issues and filter rules.

#### Easy to use and customize:
The UI is simple and intuitive, making it easy to create and extend dashboards, which is especially helpful when facing production issues.

#### Open Source Foundation:
Sysdig is built on the open-source Falco rules engine, which makes it simple to detect suspicious activity.

#### Machine Learning:
Sysdig Secure provides image scanning, ML based run-time protection.


## Getting Started

These instruction will give you a copy of the project up and running on
your k8s cluster for development and testing purposes. See deployment
for notes on deploying the project.

### Prerequisites

Requirements for the software and other tools to build, test and push thre artifacts to your repository.
- These tools should be already installed: [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git), [Docker](https://docs.docker.com/engine/install/) and k8s client or [kubectl](https://kubernetes.io/docs/tasks/tools/)
- Sysdig Monitor, [request a demo here](https://sysdig.com/z-request-a-demo/)
- helm, [install from here](https://helm.sh/docs/intro/install/)
- and [Jenkins](https://www.jenkins.io/doc/book/installing/)

### Building project

Install the classig voting app into your cluster.
This example shows how it's done using docker
```sh
docker build -t myspace/voting.app:your.tag .
docker run myspace/voting.app:your.tag
```

Inside docker, change directory to example-voting-app and run the app in k8s
```sh
kubectl create -f k8s-specifications/
```

For more information how to build it, [please refer to github link](https://github.com/dockersamples/example-voting-app)

Open the application and you should see the voting page
![image alt](https://github.com/MacMohi/example-voting-app/blob/cef7479ccdb217fdff6e90ea4e719de0cfb20b77/images/vote_cats_dogs.png)


### Inject the Sysdig Agent on your k8s cluster

For more information, visit the [Sysdig documentation](https://docs.sysdig.com/en/sysdig-monitor/kubernetes/).

The Sysdig Monitor onboarding page also provides information how to install the agent on k8s
![image alt](https://github.com/MacMohi/example-voting-app/blob/cc00f007a35eb9c46109844315bdb3be0c679858/images/install_sysdig_agent.png)


## Sysdig Monitor

The Sysdig Monitor Advisor describes the major components of the interface and the navigation options.

In the Sysdig Monitor Advisor section, you can view your cluster's resource usage (CPU, memory) compared to the requests and limits set for your pods and containers, helping you identify potential resource misconfigurations and optimize resource allocation.

![image alt](https://github.com/MacMohi/example-voting-app/blob/1171d438959e4d89f536b398cbddabe898d46fda/images/sysdig_advisor.png)

#### By comparing usage to requests and limits, you can pinpoint situations where: 
- **Requests are too high**: Your pods might be requesting more resources than they actually need, leading to wasted resources.
- **Limits are too low**: Your pods might be hitting resource limits, causing performance issues or even pod evictions.
- **Requests are too low**: Your pods might be struggling to get enough resources, leading to throttling or instability

### Dashboard
Creating a Dashbard can be simply used using using PromQL queries. For more information about PromQL [refer to this page](https://docs.sysdig.com/en/sysdig-monitor/using-promql-query/)

For this example I created for queries to show on the Dashboard:

Show CPU consumption in percentage value
```sh
sysdig_host_cpu_used_percent
```
The memory consumption
```sh
sum by (kube_cluster_name, kube_namespace_name, kube_workload_type, kube_workload_name) (sysdig_container_memory_used_bytes)
```
CPU Cores used within kubernetes namespace
```sh
sum by (kube_namespace_name) (sysdig_container_cpu_cores_used)
```
Memory consumption by namespaces "sysdig-agent" and "default" where the voting app is deployed in.
```sh
sum by (kube_cluster_name, kube_namespace_name) (sysdig_container_memory_used_bytes)
```

The Dashboard would lool like this one
![image alt](https://github.com/MacMohi/example-voting-app/blob/9dde529b910e044f8757be56dd140a834b41e778/images/Dashboard_PromQL.png)

## Sysdig Secure

Scanning the image beeing used for the Voting App shows this results:

![image alt](https://github.com/MacMohi/example-voting-app/blob/5881c0ef8e43d74cd6f70d75b6abfec60f08634e/images/scan-images.png)

This result view indicates vulnerabilities, misconfigurations, and license violations, categorized by severity and type. Vulnerabilities with fixes available and those in images actively in use are highlighted as highest risk, requiring immediate attention.

Additinally to the used image for Voting App, the vote, result and worker imgages are built and scanned with the cli scanner.
This step is done within the CI process in Jenkins as you see in the [jenkins-pipeline.txt](https://github.com/MacMohi/example-voting-app/blob/5881c0ef8e43d74cd6f70d75b6abfec60f08634e/jenkins-pipeline.txt)
```sh
stage('Scanning all images') {
            steps {
                sh '''
                VERSION=$(curl -L -s https://download.sysdig.com/scanning/sysdig-cli-scanner/latest_version.txt)
                curl -LO "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/${VERSION}/linux/amd64/sysdig-cli-scanner"
                chmod +x ./sysdig-cli-scanner
                '''
                
                withCredentials([string(credentialsId: 'SECRET_API_TOKEN', variable: 'SECURE_API_TOKEN')]) {
                    script {
                        try {
                            sh "./sysdig-cli-scanner -a $SYSDIG_ENDPOINT docker://$DOCKER_IMAGE_VOTE"
                        } catch (e) {
                            println "Sysdig CLI Scanner failed, but let's continue with the whole demonstration: {e}"
                        }
                        try {
                            sh "./sysdig-cli-scanner -a $SYSDIG_ENDPOINT docker://$DOCKER_IMAGE_RESULT"
                        } catch (e) {
                            println "Sysdig CLI Scanner failed, but let's continue with the whole demonstration: {e}"
                        }
                        try {
                            sh "./sysdig-cli-scanner -a $SYSDIG_ENDPOINT docker://$DOCKER_IMAGE_WORKER"
                        } catch (e) {
                            println "Sysdig CLI Scanner failed, but let's continue with the whole demonstration: {e}"
                        }
                    }
                }
            }
        }
```



### Create a policy
Policy menu on the left | Policies (context menu). Create and save the policy.
![image alt](https://github.com/MacMohi/example-voting-app/blob/d7b2bbfe82a1a4f7130d06060d71356741c06699/images/creating-policy.png)

To use the policy in the pipeline while scanning an image with sysdig-cli-scanner, add option **--policy < your-policy-name >**
```sh
sh "./sysdig-cli-scanner -a $SYSDIG_ENDPOINT docker://$DOCKER_IMAGE_VOTE" --policy high-critical-not-fixed-yet
```


### Activity Audit
Threats menu on the left | Activi Audit (context menu). You can monitor the activities in you pods.
For example, when specific files are added or removed, it will be shown in this Activity view.
![image alt](https://github.com/MacMohi/example-voting-app/blob/91047e83e073b9b9c2b4bd989a065dc53f2f16d8/images/forensics-activity.png)
