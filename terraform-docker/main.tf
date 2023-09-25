#setup docker provider
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}
provider "docker" {}

#Pulls images
resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

# Create a container
resource "docker_container" "nodered_container" {
  count = 2
  image = docker_image.nodered_image.image_id
  name  = join("-",["nodered", random_string.random[count.index].result])
  ports {
    internal = 1880
  #  external = 1880
  }
}

## Create a container2
#resource "docker_container" "nodered_container2" {
#  image = docker_image.nodered_image.image_id
#  name  = join("-",["nodered", random_string.random2.result])
#  ports {
#    internal = 1880
#    #  external = 1880
#  }
#}


#Declaring output value
output "name-of-container" {
  value = docker_container.nodered_container[*].name             #Splat operator -> *
  description = "The name of container"
}
#output "name-of-container2" {
#  value = docker_container.nodered_container[1].name
#  description = "The name of container"
#}

#Join
output "join-container-values" {
  value = [for i in docker_container.nodered_container[*]: join(":", [i.network_data[0].ip_address, i.ports[0].external])]
#  value = join(":", [docker_container.nodered_container[0].network_data[0].ip_address, docker_container.nodered_container[0].ports[0].external])
  description = "The id of container"
}
#output "join-container-values2" {
#  value = join(":", [docker_container.nodered_container[1].network_data[0].ip_address, docker_container.nodered_container[1].ports[0].external])
#  description = "The id of container"
#}

#RANDOM provider
resource "random_string" "random" {
  count            = 2      #this will result in 2 randoms creation
  length           = 4
  special          = false
  upper            = false
}
#resource "random_string" "random2" {
#  length           = 4
#  special          = false
#  upper            = false
#}

