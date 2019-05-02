# Microsoft R Open on Docker
A Dockerfile to build a Docker image which has [Microsoft R Open](https://mran.microsoft.com/open) (MRO), [MKL](https://software.intel.com/en-us/mkl) and a few basic packages installed (incl. [ODBC for SQL Server](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017)).

Once the image is started, it will automatically start a shiny app available at port 80. If shiny is not needed, simply remove the shiny block from the Dockerfile.

The image created here is not intended for use with Azure Machine Learning Services. If you want to run R in Azure Machine Learning Services, use the container creation/preparation features provided there and call R via the rpy2 package (as long as there is no more "native" R integration).

As always, artifacts are provided "as is". Feel free to reuse but don't blame me if things go wrong.

Enjoy!


## azure devops setup
* Create a new project at https://dev.azure.com
* Create a new git repository in azure devops or github.

## Create required Cloud Resources on Azure 

### Create a new service principal (SP)
The SP will be used by Azure DevOps to connect to your Azure subscription and manage resources on your behalf.

````az account show````

````az ad sp create-for-rbac -n "packer-4711" --role contributor --scopes /subscriptions/YOURSUBSCRIPTIONIDGOESHERE````

### create an azure container registry (azurecr.io)
This will your main container registry.
````az acr create -n MyRegistry -g MyResourceGroup --sku Standard````

azure container registry docker login
````az acr login --name ACRNAME -l westeurope````

## Related Docs
https://docs.microsoft.com/en-us/azure/machine-learning/service/how-to-deploy-and-where#aci
