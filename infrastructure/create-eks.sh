aws eks create-cluster \
--region us-west-2 \
--name production \
--role-arn arn:aws:iam::505488625686:role/eksrole \
--resources-vpc-config subnetIds=subnet-00134669cc62e7c06,subnet-0e083cb1a4af7ae37,subnet-0f82d0c173ac5ceb1,\
securityGroupIds=sg-03fdc8666ff8d65a7