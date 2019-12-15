1. Create an AWS IAM service role (allow Kubernetes to create AWS resources)
2. Create EKS VPC : ./create-eks-vpc.sh CapstoneProject amazon-eks-vpc.yml
3. Create EKS : ./create-eks.sh

'''
{
    "cluster": {
        "name": "production",
        "arn": "arn:aws:eks:us-west-2:505488625686:cluster/production",
        "createdAt": 1576418734.719,
        "version": "1.14",
        "roleArn": "arn:aws:iam::505488625686:role/eksrole",
        "resourcesVpcConfig": {
            "subnetIds": [
                "subnet-00134669cc62e7c06",
                "subnet-0e083cb1a4af7ae37",
                "subnet-0f82d0c173ac5ceb1"
            ],
            "securityGroupIds": [
                "sg-03fdc8666ff8d65a7"
            ],
            "vpcId": "vpc-0fc0debaff522b5f7",
            "endpointPublicAccess": true,
            "endpointPrivateAccess": false
        },
        "logging": {
            "clusterLogging": [
                {
                    "types": [
                        "api",
                        "audit",
                        "authenticator",
                        "controllerManager",
                        "scheduler"
                    ],
                    "enabled": false
                }
            ]
        },
        "status": "CREATING",
        "certificateAuthority": {},
        "platformVersion": "eks.5",
        "tags": {}
    }
}
'''

You can ping status of cluster: 
```
aws eks --region us-west-2 describe-cluster --name production --query cluster.status
```

4. Install kubetcl (tool to manage kubernetes clusters)
```
sudo apt-get update && sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
```

5. Install Amazon’s authenticator for kubectl and IAM.
```
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator
chmod +x aws-iam-authenticator
sudo mv aws-iam-authenticator /usr/bin/aws-iam-authenticator
```

6. Update kubeconfig file with the information on the new cluster so that kubectl can communicate with it

```
./update-kubeconfig.sh 
->Added new context arn:aws:eks:us-west-2:505488625686:cluster/production to /home/sorix/.kube/config
```

7. Test configuration: ```kubectl get svc```

8. Launch worker nodes into the EKS cluster ```./launch-kubernetes-worker-nodes.sh```

9. Note the value for NodeInstanceRole as you will need it for the next step — allowing the worker nodes to join our Kubernetes cluster.

To do this, first download the AWS authenticator configuration map: aws-auth-cm.yml and update with NodeInstanceRole

```
kubectl apply -f aws-auth-cm.yml
```


