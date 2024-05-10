//VPC
resource "aws_vpc" "mtc_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}
//EC2 SUBNETS
resource "aws_subnet" "mtc_public_subnet_a" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_subnet" "mtc_public_subnet_b" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.123.4.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"

  tags = {
    Name = "dev-public"
  }
}

//INTERNET GATEWAY
resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

//ROUTE TABLE
resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "dev-public-rt"
  }
}

//ROUTE
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

//ROUTE ASSOCIATION
resource "aws_route_table_association" "mtc_public_assoc" {
  subnet_id      = aws_subnet.mtc_public_subnet_a.id
  route_table_id = aws_route_table.mtc_public_rt.id
}

//SECURITY GROUP
resource "aws_security_group" "mtc_sg1" {
  name        = "dev-ec2-sg"
  description = "dev security group"
  vpc_id      = aws_vpc.mtc_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "mtc_sg2" {
  name        = "dev-rds-sg2"
  description = "dev security group"
  vpc_id      = aws_vpc.mtc_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.mtc_sg1.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//KEYPAIR
resource "aws_key_pair" "mtc_auth" {
  key_name   = "mtc-key"
  public_key = file("C:/Users/Damilola/.ssh/mtckey.pub")
}

//EC2
resource "aws_instance" "dev_node_a" {
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mtc_auth.id
  vpc_security_group_ids = [aws_security_group.mtc_sg1.id]
  subnet_id              = aws_subnet.mtc_public_subnet_a.id
  ami                    = data.aws_ami.server_ami.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev_node"
  }

  provisioner "local-exec" {
    command = templatefile("ssh-config.tpl", {
      hostname     = self.public_ip
      user         = "${var.username}",
      identityfile = "C:/Users/Damilola/.ssh/mtckey"
    })
    interpreter = ["Powershell", "-Command"]
  }
}

resource "aws_instance" "dev_node_b" {
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mtc_auth.id
  vpc_security_group_ids = [aws_security_group.mtc_sg1.id]
  subnet_id              = aws_subnet.mtc_public_subnet_b.id  
  ami                    = data.aws_ami.server_ami.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev_node_b"
  }

  provisioner "local-exec" {
    command = templatefile("ssh-config.tpl", {
      hostname     = self.public_ip
      user         = "${var.username}",
      identityfile = "C:/Users/Damilola/.ssh/mtckey"
    })
    interpreter = ["Powershell", "-Command"]
  }
}


//AWS DATABASE
resource "aws_db_instance" "mtc_rds_a" {
  allocated_storage    = 10
  instance_class       = "db.t3.micro" 
  engine               = "mysql"
  engine_version       = "5.7"  
  username             = "admin"
  password             = "adminadmin"
  skip_final_snapshot  = true 
  vpc_security_group_ids = [aws_security_group.mtc_sg2.id]
  db_subnet_group_name = aws_db_subnet_group.mtc_subnet_group2.name
}

resource "aws_db_instance" "mtc_rds_b" {
  allocated_storage    = 10
  instance_class       = "db.t3.micro" 
  engine               = "mysql"
  engine_version       = "5.7"  
  username             = "admin"
  password             = "adminadmin"
  skip_final_snapshot  = true 
  vpc_security_group_ids = [aws_security_group.mtc_sg2.id]
  db_subnet_group_name = aws_db_subnet_group.mtc_subnet_group2.name
}




resource "aws_db_subnet_group" "mtc_subnet_group2" {
  name = "mtc-subnet-group2"
  subnet_ids = [aws_subnet.mtc_private_subnet2.id, aws_subnet.mtc_private_subnet.id]
}


resource "aws_subnet" "mtc_private_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.123.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-private"
  }
}

resource "aws_subnet" "mtc_private_subnet2" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.123.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1b"

  tags = {
    Name = "dev-private"
  }
}
