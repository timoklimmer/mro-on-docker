# Microsoft R Open on Docker
A Dockerfile to build a Docker image which has [Microsoft R Open](https://mran.microsoft.com/open) (MRO), [MKL](https://software.intel.com/en-us/mkl) and a few basic packages installed (incl. [ODBC for SQL Server](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-2017)).

You might use this image for example to run R code on [Azure Batch AI](https://azure.microsoft.com/en-us/services/batch-ai).

(However, the image does not yet contain NVIDIA drivers so far.)

As always, artefacts are provided "as is". Feel free to reuse but don't blame me if things go wrong.

Enjoy!