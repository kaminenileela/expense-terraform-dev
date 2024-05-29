module "bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  #convert stringList to list and get first element
  subnet_id              = split(",", data.aws_ssm_parameter.public_subnet_ids.value)

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}