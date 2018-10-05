
class profile::jenkins {

  include 'docker'

  # have to add Docker to the official Jenkins Docker image: 
  file { '/tmp/Dockerfile': 
    ensure  => present,
    content => '
FROM jenkins/jenkins:lts
USER root
RUN apt-get update && apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
RUN apt-get update && apt-get install -y docker-ce
  ',
  }

  # create image from Dockerfile
  docker::image { 'jenkins':
    docker_file => '/tmp/Dockerfile',
    subscribe   => File['/tmp/Dockerfile'],
  }

  # run the container
  docker::run { 'jenkins':
    image      => 'jenkins',
    ports      => ['8080:8080', '50000:50000'],
    volumes    => ['jenkins_home:/var/jenkins_home',
                   '/var/run/docker.sock:/var/run/docker.sock'],
    privileged => true,
    username   => 'root',
    subscribe  => Docker::Image['jenkins'],
  }
}
