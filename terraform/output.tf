output "instance_id_output" {

    description = "Ec2 Instance Id"
    #value = aws_instance.my_ec2_instacne.id
    value = [for k in aws_instance.my_ec2_instacne: k.id]
  
}

output "public_ip_output" {

    description = "Public Ip of Instance"
    #value = aws_instance.my_ec2_instacne.public_ip

    value = {for k,v in aws_instance.my_ec2_instacne: k => v.public_ip }
  
}