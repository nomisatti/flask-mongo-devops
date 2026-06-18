
variable aws_region{

    default = "ap-southeast-2"
}

variable "instacne_type" {

    default = "t3.small"
    description = "Default Instacne for"
}

variable "ami" {

    default = "ami-06259b63260eddc13"
  
}

variable "public_key" {

    description = "Public Key to access AWS server"
    default = "../flask-mongo-app-key.pub"
  
}
