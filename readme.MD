# Expense Architecture


![alt text](Images/expenses-dev-terraform.jpg)

If we are using modules, for any changes done original module code we need to do
* terraform init -upgrade 

To run all modules sequentially
* for i in 01-vpc/ 02-sg/ 03-bastion/ 04-db/ .... ;do cd $i ; terraform apply -auto-approve; cd .. ; done