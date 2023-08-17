# Login to Azure (if not already logged in)
az account show 1> /dev/null || az login

rg=terraform-state-rg
sa=tfpracticestorage
container=tfpracticecontainer

# Resource group
az group create --name $rg --location eastus --tags 'Project=Terraform' 'Env=Demo'

# account
az storage account create --resource-group $rg --name $sa --sku Standard_LRS --encryption-services blob

# container
az storage container create --name $container --account-name $sa