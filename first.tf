# provider

provider "aws"{
    region = "ap-south-1"
    profile = "default"
}

# 7.1
# creating key pair

resource "aws_key_pair" "TF_task_key" {
  key_name   = "TF_task_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwcnWuWwcCnIfJ/y3UqWeozUCkgNV5eigZsjGZkxtMEEi6WHU47E6g2WVJKdf4QmmJ+kTSstnGpryexANh4Amky28qI4TypMiESTWoIVefmyx7mIWFrr+3KTtdvQweQioTJtPBYsVpOAXbDdCsGWGeXYODe4xtdojNIvFthrd9dn/*********************************************************"
}

# 7.2
# creating security group

resource "aws_security_group" "TF_task_SG" {
  name        = "TF_task_SG"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }

  tags = {
    Name = "TF_task_SG"
  }
}

# 7.3
# Launching an instance using the above created key pair and security group.

resource "aws_instance" "TF_task" {
  ami           = "ami-0ad704c126371a549"
  instance_type = "t2.micro"
  
  key_name = "TF_task_key"
  security_groups = ["TF_task_SG"]
  tags = {
    Name = "TF-task"
  }
}

# 7.4
# creating an EBS volume of 1GB

resource "aws_ebs_volume" "TF_task_vol" {
  availability_zone = aws_instance.TF_task.availability_zone
  size              = 1
  tags = {
    Name = "TF_task_vol"
  }
}

# 7.5
# attaching the instance and EBS volume created above

resource "aws_volume_attachment" "vol_attach" {
  device_name = "/dev/sdh"
  instance_id = aws_instance.TF_task.id
  volume_id = aws_ebs_volume.TF_task_vol.id
}
