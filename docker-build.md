docker buildx build \
  --platform linux/amd64 \
  -t kamanhang/nginx-angular-app:latest \
  --push .

<!-- this code builds docker image for linux instance and push to docker hub -->
<!-- later this docker image will be pulled to ec2 instance running docker and map to the ec2 port  -->
