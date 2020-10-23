# Microsoft R Open on Docker
A Dockerfile to build a Docker image which has [Microsoft R Open](https://mran.microsoft.com/open) (MRO), [MKL](https://software.intel.com/en-us/mkl) and a few basic packages installed (incl. [Shiny](https://shiny.rstudio.com) and [ODBC for SQL Server](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017)). MRO is fully compatible with the R version on CRAN but includes additional capabilities such as improved performance and reproducibility.

Once the image is started, it will automatically start a shiny app available at port 80. If shiny is not needed, simply remove the shiny block from the Dockerfile.

Basically you should be able to run the image on any Docker host. If you are looking for an easy-to-use option, you may want to check out [Azure Web App for Containers](https://azure.microsoft.com/en-us/services/app-service/containers). It has several configuration options which let you add things like an Azure AD-based two-factor authentication in a breeze.

The image created here is not intended for use with Azure Machine Learning Services. If you want to run R in Azure Machine Learning Services, use the container creation/preparation features provided there and call R via the rpy2 package (as long as there is no more "native" R integration).

As always, artifacts are provided "as is". Feel free to reuse but don't blame me if things go wrong.

Enjoy!
