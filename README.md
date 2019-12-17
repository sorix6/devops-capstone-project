## [DEVOPS ENGINEER - CAPSTONE PROJECT]

This project consists in developping a CI/CD pipeline for micro services applications with rolling deployment. 

#### Important scripts and files

- In the `infrastructure` folder:
    * create-eks-vpc.sh - creation of the VPC for the EKS
    * create-eks.sh - creation of the EKS cluster
    * update-kubeconfig.sh - update kubeconfig file with the information on the new cluster so that kubectl can communicate with it
    * launch-kubernetes-worker-nodes.sh - launch worker nodes 

    ! This will return a NodeInstanceRole that needs to be updated in the `aws-auth-cm.yml` file

    ! In order for the worker nodes to join our Kubernetes cluster:
    `kubectl apply -f aws-auth-cm.yml`

#### Other useful commands

- Ping status of cluster: 
```aws eks --region us-west-2 describe-cluster --name capstone-project --query cluster.status```

- Test Kubernetes configuration: ```kubectl get svc```

#### Jenkins pipeline

![Project overview](https://raw.githubusercontent.com/sorix6/devops-capstone-project/master/screenshots/jenkins.jpg)

##### Typographical checking (aka “linting”)

Screenshot of build failing due to linting error

![Project overview](https://raw.githubusercontent.com/sorix6/devops-capstone-project/master/screenshots/linting_error.jpg)

Screenshot of linting step passing successfully

![Project overview](https://raw.githubusercontent.com/sorix6/devops-capstone-project/master/screenshots/no_linting_error.jpg)

##### Rollout deployment

The file `deployment/capstone-project.yml` defines the configuration for the rolling deployment.

* A deployment named capstone-project is created (metadata.name field)
* The deployment creates 3 replicated pods
* Select pods with the label `capstone-project`
* The template field contains the following sub-fields:

    - The pods are labeled app: capstone-project
    - The specification of the pod's template (template.spec field); this indicates that the pods run one container, capstone-project, which runs the sorix6/capstone-project

In order to create the deployment, run the command: 
`kubectl apply -f ./deployment/capstone-project.yml`, in order to create the deployment.

In order to update the deployment (update the pods to use the latest version of the Docker Hub image), the Jenkins file contains the following command:

`kubectl set image deployment/capstone-project nginx=sorix6/capstone-project:latest --record`

##### Build console output

```
Started by user admin
Obtained Jenkinsfile from git https://github.com/sorix6/devops-capstone-project
Running in Durability level: MAX_SURVIVABILITY
[Pipeline] Start of Pipeline
[Pipeline] node
Running on Jenkins in /var/lib/jenkins/workspace/devops-capstone-project
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Declarative: Checkout SCM)
[Pipeline] checkout
No credentials specified
 > git rev-parse --is-inside-work-tree # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/sorix6/devops-capstone-project # timeout=10
Fetching upstream changes from https://github.com/sorix6/devops-capstone-project
 > git --version # timeout=10
 > git fetch --tags --progress -- https://github.com/sorix6/devops-capstone-project +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git rev-parse refs/remotes/origin/origin/master^{commit} # timeout=10
Checking out Revision 775781a8104639df05bbe5b5aecd52e15df7c6c0 (refs/remotes/origin/master)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 775781a8104639df05bbe5b5aecd52e15df7c6c0 # timeout=10
Commit message: "Updated Jenkins file with command to display rollout status"
 > git rev-list --no-walk 181f093e9dd49ed5eefa46e9101970c6915dd917 # timeout=10
[Pipeline] }
[Pipeline] // stage
[Pipeline] withEnv
[Pipeline] {
[Pipeline] withEnv
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Checking out git repo)
[Pipeline] script
[Pipeline] {
[Pipeline] echo
Checkout Git repository
[Pipeline] checkout
No credentials specified
 > git rev-parse --is-inside-work-tree # timeout=10
Fetching changes from the remote Git repository
 > git config remote.origin.url https://github.com/sorix6/devops-capstone-project # timeout=10
Fetching upstream changes from https://github.com/sorix6/devops-capstone-project
 > git --version # timeout=10
 > git fetch --tags --progress -- https://github.com/sorix6/devops-capstone-project +refs/heads/*:refs/remotes/origin/* # timeout=10
 > git rev-parse refs/remotes/origin/master^{commit} # timeout=10
 > git rev-parse refs/remotes/origin/origin/master^{commit} # timeout=10
Checking out Revision 775781a8104639df05bbe5b5aecd52e15df7c6c0 (refs/remotes/origin/master)
 > git config core.sparsecheckout # timeout=10
 > git checkout -f 775781a8104639df05bbe5b5aecd52e15df7c6c0 # timeout=10
Commit message: "Updated Jenkins file with command to display rollout status"
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Linting)
[Pipeline] script
[Pipeline] {
[Pipeline] echo
Linting...
[Pipeline] isUnix
[Pipeline] sh
+ docker inspect -f . hadolint/hadolint:latest-debian
.
[Pipeline] withDockerContainer
Jenkins does not seem to be running inside a container
$ docker run -t -d -u 111:115 -w /var/lib/jenkins/workspace/devops-capstone-project -v /var/lib/jenkins/workspace/devops-capstone-project:/var/lib/jenkins/workspace/devops-capstone-project:rw,z -v /var/lib/jenkins/workspace/devops-capstone-project@tmp:/var/lib/jenkins/workspace/devops-capstone-project@tmp:rw,z -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** -e ******** hadolint/hadolint:latest-debian cat
$ docker top 23ae4872064c9a03e9a1488f170122df364f5ed1dba5d8a4ceea0d7ee5010f20 -eo pid,comm
[Pipeline] {
[Pipeline] sh
+ truncate -s 0 linting_results.log
[Pipeline] sh
+ tee -a linting_results.log
+ hadolint ./Dockerfile
[Pipeline] sh
+ stat --printf=%s linting_results.log
+ lintErrors=0
+ [ 0 -gt 0 ]
+ echo No errors were found on your Dockerfile
No errors were found on your Dockerfile
[Pipeline] }
$ docker stop --time=1 23ae4872064c9a03e9a1488f170122df364f5ed1dba5d8a4ceea0d7ee5010f20
$ docker rm -f 23ae4872064c9a03e9a1488f170122df364f5ed1dba5d8a4ceea0d7ee5010f20
[Pipeline] // withDockerContainer
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Building image and pushing to Dockerhub)
[Pipeline] script
[Pipeline] {
[Pipeline] isUnix
[Pipeline] sh
+ docker build -t sorix6/capstone-project .
Sending build context to Docker daemon  758.3kB

Step 1/5 : FROM nginx:1.17
 ---> 231d40e811cd
Step 2/5 : COPY linux_tweet_app/index.html /usr/share/nginx/html
 ---> Using cache
 ---> f834ccdcfa19
Step 3/5 : COPY linux_tweet_app/linux.png /usr/share/nginx/html
 ---> Using cache
 ---> c52a19f87e61
Step 4/5 : EXPOSE 80 443
 ---> Using cache
 ---> 8c160cdec886
Step 5/5 : CMD ["nginx", "-g", "daemon off;"]
 ---> Using cache
 ---> 4347d8a22a03
Successfully built 4347d8a22a03
Successfully tagged sorix6/capstone-project:latest
[Pipeline] withEnv
[Pipeline] {
[Pipeline] withDockerRegistry
$ docker login -u sorix6 -p ******** https://index.docker.io/v1/
Login Succeeded
[Pipeline] {
[Pipeline] isUnix
[Pipeline] sh
+ docker tag sorix6/capstone-project sorix6/capstone-project:latest
[Pipeline] isUnix
[Pipeline] sh
+ docker push sorix6/capstone-project:latest
The push refers to repository [docker.io/sorix6/capstone-project]
e3dfd2c7a43b: Preparing
7f001e7397e2: Preparing
4fc1aa8003a3: Preparing
5fb987d2e54d: Preparing
831c5620387f: Preparing
4fc1aa8003a3: Layer already exists
e3dfd2c7a43b: Layer already exists
7f001e7397e2: Layer already exists
5fb987d2e54d: Layer already exists
831c5620387f: Layer already exists
latest: digest: sha256:07a5ae19aeef9da6f0f3c3b0cbb7732f27b3d790ea46ae5cc745fdcc7983f953 size: 1363
[Pipeline] }
[Pipeline] // withDockerRegistry
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Deploying to AWS)
[Pipeline] script
[Pipeline] {
[Pipeline] dir
Running in /var/lib/jenkins/workspace/devops-capstone-project
[Pipeline] {
[Pipeline] withAWS
Constructing AWS CredentialsSetting AWS region us-west-2 
 [Pipeline] {
[Pipeline] sh
+ ./infrastructure/update-kubeconfig.sh
Updated context arn:aws:eks:us-west-2:505488625686:cluster/capstone-project in /var/lib/jenkins/.kube/config
[Pipeline] sh
+ kubectl apply -f ./infrastructure/aws-auth-cm.yml
configmap/aws-auth unchanged
[Pipeline] sh
+ kubectl apply -f ./deployment/capstone-project.yml
deployment.apps/capstone-project created
[Pipeline] sh
+ kubectl get pods
NAME                                READY     STATUS              RESTARTS   AGE
capstone-project-6dfb8d8f96-7zmwk   0/1       ContainerCreating   0          1s
capstone-project-6dfb8d8f96-9df7x   0/1       ContainerCreating   0          1s
capstone-project-6dfb8d8f96-qrf8m   0/1       ContainerCreating   0          1s
[Pipeline] sh
+ kubectl get nodes
NAME                                            STATUS    ROLES     AGE       VERSION
ip-192-168-156-210.us-west-2.compute.internal   Ready     <none>    9m5s      v1.14.7-eks-1861c5
ip-192-168-194-147.us-west-2.compute.internal   Ready     <none>    9m4s      v1.14.7-eks-1861c5
ip-192-168-94-108.us-west-2.compute.internal    Ready     <none>    9m1s      v1.14.7-eks-1861c5
[Pipeline] sh
+ kubectl rollout status deployment.v1.apps/capstone-project
deployment "capstone-project" successfully rolled out
[Pipeline] }
[Pipeline] // withAWS
[Pipeline] }
[Pipeline] // dir
[Pipeline] }
[Pipeline] // script
[Pipeline] }
[Pipeline] // stage
[Pipeline] stage
[Pipeline] { (Remove Unused docker image)
[Pipeline] sh
+ docker rmi sorix6/capstone-project
Untagged: sorix6/capstone-project:latest
[Pipeline] }
[Pipeline] // stage
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // withEnv
[Pipeline] }
[Pipeline] // node
[Pipeline] End of Pipeline
Finished: SUCCESS
```

##### Additional resources

* The source code for the example application was forked from https://github.com/dockersamples/linux_tweet_app
* https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
* https://www.mirantis.com/blog/introduction-to-yaml-creating-a-kubernetes-deployment/
* https://puppet.com/docs/pipelines-for-containers/free/kubernetes-spec.html
* https://success.docker.com/article/how-to-control-container-placement-in-kubernetes-deployments