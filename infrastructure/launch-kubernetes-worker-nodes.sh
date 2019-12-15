aws cloudformation create-stack \
--stack-name=capstone-project-worker-nodes  \
--parameters=file://kubernetes-worker-nodes-parameters.json \
--template-body=file://amazon-eks-nodegroup.yml \
--region=us-west-2 \
--capabilities CAPABILITY_NAMED_IAM
