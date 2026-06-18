
resource "aws_key_pair" "key_pair" {
    public_key = file(var.public_key)

}

resource "aws_default_vpc" "default_vpc" {
  
}

resource "aws_security_group" "security_group" {

    description = "Default security group "
    vpc_id = aws_default_vpc.default_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "inbound_rules_" {

    for_each = {
        "ssh"= 22
        "http" = 80
        "app" = 5000
    }

    description = "Inbound Rule for port ${each.value} - (${each.key})"
    cidr_ipv4 = "0.0.0.0/0"
    from_port = each.value
    to_port = each.value
    ip_protocol = "tcp"
    security_group_id = aws_security_group.security_group.id
  
}

resource "aws_vpc_security_group_egress_rule" "outbound_rule" {

    description = "Outbound rule for our aws instance"
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
    security_group_id = aws_security_group.security_group.id
  
}

resource "aws_instance" "my_ec2_instacne" {

    for_each= {
        "flask_app" = "Flask App Server"
        "ansible_control" = "Ansible Control Node"
    }
    ami = var.ami
    instance_type = each.key == "flask_app" ? var.instacne_type : "t3.micro"
    key_name = aws_key_pair.key_pair.key_name
    vpc_security_group_ids = [aws_security_group.security_group.id]

    root_block_device {

        volume_size =  12
        volume_type = "gp3"        

    }
    
    tags = {
        Name = each.value
    }
}