aws cloudformation update-stack \
--stack-name=capstone-project-worker-nodes  \
--parameters=file://${1} \
--template-body=file://${2} \
--region=us-west-2 \
--capabilities CAPABILITY_NAMED_IAM
