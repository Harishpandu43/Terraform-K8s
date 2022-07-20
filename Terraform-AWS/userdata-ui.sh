#!/bin/bash
yum install -y docker
yum install -y awslogs
systemctl enable docker
systemctl start docker
systemctl enable awslogsd
systemctl start awslogsd

docker run -d --log-driver=awslogs --log-opt awslogs-region=ap-south-1 --log-opt awslogs-group=sigma-apiserver --log-opt awslogs-create-group=true -p 80:8080 --env spring.datasource.username=postgres --env spring.datasource.password=postgres --env spring.datasource.url=jdbc:postgresql://sigma-db-postgres.c67d3uautcvu.us-west-2.rds.amazonaws.com:5432/smartbankapp harishpandu43/sba_api_image