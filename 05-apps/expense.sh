#!/bin/bash
# user data will get sudo access
dnf install ansible -y
cd /tmp
#git clone https://github.com/kaminenileela/expense-ansible-roles.git
git clone https://github.com/kaminenileela/expense-ansible-roles1.git
cd expense-ansible-roles
ansible-playbook main.yml -e component=backend -e login_password=ExpenseApp1 
ansible-playbook main.yml -e component=frontend 