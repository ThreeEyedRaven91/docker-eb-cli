# Docker Elastic Beanstalk CLI

This image supports pre-installed docker and is the way to deploy elastic beanstalk inside a docker.

Following guide also help you to setup auto deploy using Jenkins's Pipeline

## How to setup auto deploy
### Setup Docker Image for deploy

Create new Dockerfile for deploy (you should separate it with your application Dockerfile), called `Dockerfile.deploy`

```
FROM xuanbinh91/docker-eb-cli:latest

# install yarn and npm in case of you want to build before deploy
RUN yum update -y
RUN curl -sL https://rpm.nodesource.com/setup_8.x | bash -
RUN yum install -y nodejs
RUN npm install -g yarn
RUN yarn --version

# Copy source code
WORKDIR /usr/src/app
COPY . .

# Just keep the docker up
ENTRYPOINT ["tail", "-f", "/dev/null"]
```

### Setup docker-compose

In your `docker-compose.yaml`, add new deploy service

```
services:
  deploy:
    build:
      context: ./
      dockerfile: Dockerfile.deploy
```

### Setup Jenkins pipeline

In your `Jenkinsfile`, add new stage to deploy

```
stage('Try deploy') {
    when {
        branch('develop')
    }
    steps {
        withCredentials([usernamePassword(credentialsId: '<your_credentials_id>', usernameVariable: 'AWS_KEY', passwordVariable: 'AWS_SECRET')]) {
            script {
                // only if you need to build before deploy
                sh "/usr/local/bin/docker-compose exec -T deploy yarn install"
                sh "/usr/local/bin/docker-compose exec -T deploy yarn install_all"
                sh "/usr/local/bin/docker-compose exec -T deploy yarn build"
                
                // setup new profile, this will keep your key / secret safe with Jenkins
                sh "/usr/local/bin/docker-compose exec -T deploy sh /root/bin/profile.sh ${AWS_KEY} ${AWS_SECRET}"
                
                // Init
                sh "/usr/local/bin/docker-compose exec -T deploy /root/.local/bin/eb init <app-name> --region <region>"
                
                // Deploy
                sh "/usr/local/bin/docker-compose exec -T deploy /root/.local/bin/eb deploy <env-name>"
            }
        }
    }
}
```

## Notice

1. You MUST use `.ebignore` file, even if you don't want to ignore anything. Because if you don't, eb will use your latest commit of current branch to deploy, but we cannot create a commit here. So my suggestion is create an `.ebignore` file which same as `.gitignore` file.