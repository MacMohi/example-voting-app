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


### Sysdig Monitor

The Sysdig Monitor Advisor describes the major components of the interface and the navigation options.
![image alt](https://github.com/MacMohi/example-voting-app/blob/1171d438959e4d89f536b398cbddabe898d46fda/images/sysdig_advisor.png)
