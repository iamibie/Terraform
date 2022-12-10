#Declare a cloud provider
provider "aws" {
    region = "us-east-2"
}

#configure virtual private cloud
resource "aws_vpc" "my_vpc" {                
    cidr_block = "10.0.0.0/16" 
    tags = {
    "Name" = "SGIA_VPC"
  }  
  
}
 
#configure gateway in/outbound traffic to vpc
resource "aws_internet_gateway" "igw" {   
    vpc_id = aws_vpc.my_vpc.id               
}

#Configure security group to allow/block specific traffics (ref:fw rules)

resource "aws_security_group" "web_traffic"{

    name        = "web_traffic"
    description = "Allow TLS inbound traffic"
    vpc_id      = aws_vpc.my_vpc.id

    ingress {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    
  }

    ingress {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    
  }

    ingress {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    
  }
   

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    
  }

    tags = {
    Name = "SGIA_SG"
  }

}

#Create EC2 instance
resource "aws_instance" "sgia_instance"{
    ami="ami-0283a57753b18025b"
    instance_type="t2.micro"
    key_name=var.key_name


    

  tags = {
    Name = "SGIA_SERVER"
  }

}


#Execute bash script

resource "null_resource" "_install" {
 provisioner "file" {
    source      = "./script.sh"
    destination = "/tmp/script.sh"
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file(var.private_key)}"
    host = "${aws_instance.sgia_instance.public_ip}"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh args",
    ]
  }

  
}





