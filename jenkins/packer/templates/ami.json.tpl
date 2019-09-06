{
  "variables" : {
    "region" : "${aws_region}",
    "source_ami" : "${ami_id}"
  },
  "builders" : [
    {
      "type" : "amazon-ebs",
      "profile" : "default",
      "region" : "{{user `region`}}",
      "instance_type" : "t2.micro",
      "source_ami" : "{{user `source_ami`}}",
      "ssh_username" : "ec2-user",
      "ami_name" : "${ami_name}",
      "ami_description" : "${ami_description}",
      "vpc_id" : "${vpc_id}",
      "run_tags" : {
        "Name" : "packer-builder-docker"
      },
      "subnet_id": "${ami_subnet_id}",
      "tags" : {
        "Tool" : "Packer",
        "Author" : "mlabouardy"
      }
    }
  ],
  "provisioners" : ${provisioners}
}