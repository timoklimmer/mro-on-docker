# Microsoft R Open on Docker
A Dockerfile to build a Docker image which has [Microsoft R Open](https://mran.microsoft.com/open) (MRO), [MKL](https://software.intel.com/en-us/mkl) and a few basic packages installed (incl. [ODBC for SQL Server](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017)).

Once the image is started, it will automatically start a shiny app available at port 80. If shiny is not needed, simply remove the shiny block from the Dockerfile.

The image created here is not intended for use with Azure Machine Learning Services. If you want to run R in Azure Machine Learning Services, use the container creation/preparation features provided there and call R via the rpy2 package (as long as there is no more "native" R integration).

As always, artifacts are provided "as is". Feel free to reuse but don't blame me if things go wrong.

Enjoy!