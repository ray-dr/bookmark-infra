ls -al
docker volume create books
docker volume ls
docker build -t bookmark .
docker login -u $dockerhub_login -p $dockerhub_pwd
docker tag bookmark:latest $dockerhub_login/bookmark:latest
docker push $dockerhub_login/bookmark:latest
