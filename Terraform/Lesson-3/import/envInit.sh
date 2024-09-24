#!/bin/bash

# Variables
REGION="us-east-1"
VPC_CIDR="10.2.0.0/16"
SUBNET1_CIDR="10.2.1.0/24"
SUBNET2_CIDR="10.2.2.0/24"
INSTANCE_TYPE="t2.micro"
KEY_NAME="vockey"
AMI_ID="ami-01b799c439fd5516a"
SECURITY_GROUP_NAME="swagger-sg"
LOAD_BALANCER_NAME="swagger-alb"
TARGET_GROUP_NAME="swagger-tg"

# Step 1: Create VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --region $REGION --query 'Vpc.VpcId' --output text)
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-support
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames
echo "VPC created: $VPC_ID"

# Step 2: Create Subnets in two Availability Zones
SUBNET1_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET1_CIDR --availability-zone ${REGION}a --query 'Subnet.SubnetId' --output text)
SUBNET2_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET2_CIDR --availability-zone ${REGION}b --query 'Subnet.SubnetId' --output text)
echo "Subnets created: $SUBNET1_ID, $SUBNET2_ID"

# Step 3: Create Internet Gateway and Attach to VPC
IGW_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 attach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID
echo "Internet Gateway created and attached: $IGW_ID"

# Step 4: Create Route Table and Route for Internet Traffic
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET1_ID
aws ec2 associate-route-table --route-table-id $ROUTE_TABLE_ID --subnet-id $SUBNET2_ID
echo "Route table created and associated with both subnets: $ROUTE_TABLE_ID"

# Step 5: Create Security Group
SG_ID=$(aws ec2 create-security-group --group-name $SECURITY_GROUP_NAME --description "Security group for Swagger" --vpc-id $VPC_ID --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 # Allow SSH
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 8080 --cidr 0.0.0.0/0 # Allow HTTP
echo "Security Group created: $SG_ID"

# Step 6: Create EC2 Instance with Docker installed and running Swagger UI
USER_DATA_SCRIPT=$(cat <<EOF
#!/bin/bash
sudo yum update
sudo yum install -y docker
sudo systemctl start docker
docker run --rm -d -p 8080:8080 --name swagger swaggerapi/swagger-ui
EOF
)

INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --key-name $KEY_NAME --security-group-ids $SG_ID --subnet-id $SUBNET1_ID --user-data "$USER_DATA_SCRIPT" --query 'Instances[0].InstanceId' --output text)
echo "EC2 Instance created: $INSTANCE_ID"

# Step 7: Create Application Load Balancer with two subnets
ALB_ARN=$(aws elbv2 create-load-balancer --name $LOAD_BALANCER_NAME --subnets $SUBNET1_ID $SUBNET2_ID --security-groups $SG_ID --scheme internet-facing --query 'LoadBalancers[0].LoadBalancerArn' --output text)
echo "ALB created: $ALB_ARN"

# Step 8: Create Target Group for the ALB
TARGET_GROUP_ARN=$(aws elbv2 create-target-group --name $TARGET_GROUP_NAME --protocol HTTP --port 8080 --vpc-id $VPC_ID --target-type instance --query 'TargetGroups[0].TargetGroupArn' --output text)
echo "Target Group created: $TARGET_GROUP_ARN"

# Step 9: Register EC2 Instance with Target Group
aws elbv2 register-targets --target-group-arn $TARGET_GROUP_ARN --targets Id=$INSTANCE_ID
echo "Instance registered with Target Group"

# Step 10: Create Listener for the Load Balancer
aws elbv2 create-listener --load-balancer-arn $ALB_ARN --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$TARGET_GROUP_ARN
echo "Listener created for the ALB"

# Step 11: Retrieve and print the ALB DNS
ALB_DNS=$(aws elbv2 describe-load-balancers --load-balancer-arns $ALB_ARN --query 'LoadBalancers[0].DNSName' --output text)
echo "Application Load Balancer DNS: http://$ALB_DNS"
