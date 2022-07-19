#!/bin/bash
yum install -y docker
yum install -y awslogs
systemctl enable docker
systemctl start docker
systemctl enable awslogsd
systemctl start awslogsd

docker run --log-driver=awslogs --log-opt awslogs-region=ap-south-1 --log-opt awslogs-group=sigma-frontend --log-opt awslogs-create-group=true -p 80:3000 --env REACT_APP_API_URL=http://sigma-api-lb-4155720960e99c9b.elb.us-west-2.amazonaws.com:80/ -d harishpandu43/sba-frontend