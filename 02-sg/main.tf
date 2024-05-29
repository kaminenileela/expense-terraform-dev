module "sg_db" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/kaminenileela/terraform-aws-securitygroup.git"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    project_name = var.project_name
    environment = var.environment
    sg_description = "database security group"
    sg_name = "db"
    common_tags = var.common_tags

}

module "sg_backend" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/kaminenileela/terraform-aws-securitygroup.git"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    project_name = var.project_name
    environment = var.environment
    sg_description = "backend security group"
    sg_name = "backend"
    common_tags = var.common_tags

}

module "sg_frontend" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/kaminenileela/terraform-aws-securitygroup.git"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    project_name = var.project_name
    environment = var.environment
    sg_description = "frontend security group"
    sg_name = "frontend"
    common_tags = var.common_tags

}

module "sg_bastion" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/kaminenileela/terraform-aws-securitygroup.git"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    project_name = var.project_name
    environment = var.environment
    sg_description = "security group for bastion instances"
    sg_name = "bastion"
    common_tags = var.common_tags

}

module "sg_ansible" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/kaminenileela/terraform-aws-securitygroup.git"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    project_name = var.project_name
    environment = var.environment
    sg_description = "security group for ansible instances"
    sg_name = "ansible"
    common_tags = var.common_tags

}


#DB is accepting connections from backend
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.sg_backend.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_db.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.sg_bastion.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_db.sg_id
}

resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.sg_frontend.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_backend.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.sg_bastion.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_backend.sg_id
}

resource "aws_security_group_rule" "backend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.sg_ansible.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_backend.sg_id
}


resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.sg_frontend.sg_id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.sg_bastion.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_frontend.sg_id
}

resource "aws_security_group_rule" "frontend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.sg_ansible.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_frontend.sg_id
}

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.sg_bastion.sg_id
}

resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.sg_ansible.sg_id
}