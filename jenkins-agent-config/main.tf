resource "aws_instance" "web" {
  ami                    = "ami-0287a05f0ef0e9d9a"      #change ami id for different region
  instance_type          = "t2.medium"
  key_name               = "Linux-VM-Key7"              #change key name as per your setup
  vpc_security_group_ids = [aws_security_group.Jenkins-Agent-SG.id]
  user_data              = templatefile("./install.sh", {})

  tags = {
    Name = "Jenkins-Agent"
  }

  root_block_device {
    volume_size = 40
  }
}

resource "aws_security_group" "Jenkins-Agent-SG" {
  name        = "Jenkins-Agent-SG"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8080] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-Agent-SG"
  }
}
