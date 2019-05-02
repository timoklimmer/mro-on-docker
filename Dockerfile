# use Ubuntu 16.04 as base image
FROM ubuntu:16.04

# give our new image a name
LABEL Name=mro-on-docker Version=0.0.1

# set the bash shell as default
# note: this is required. if not set, we cannot "run interactive" the image
CMD /bin/bash

# let Ubuntu know that we cannot use an interactive frontend during Docker image build
ARG DEBIAN_FRONTEND=noninteractive

# update Ubuntu's package information
RUN apt-get update -y -qq

# update os.
RUN apt-get dist-upgrade -y -qq

# install some basic packages needed later
RUN apt-get install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev unzip curl apt-transport-https unixodbc unixodbc-dev -y

# cleanup apt-get mess
RUN apt-get autoremove -y -qq


# install Microsoft R Open (with MKL)
# notes: - see https://mran.microsoft.com/download for newest versions
RUN apt-get install wget -y
RUN wget https://mran.blob.core.windows.net/install/mro/3.5.1/microsoft-r-open-3.5.1.tar.gz
RUN tar -xf microsoft-r-open-3.5.1.tar.gz
RUN ./microsoft-r-open/install.sh -a -u
RUN rm microsoft-r-open-3.5.1.tar.gz

# install ODBC driver for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update -y
RUN ACCEPT_EULA=Y apt-get install msodbcsql17 -y

# install additional packages
# notes: - see Dockerfile reference for copying files/directories into the image in case you want
#          to add your own packages which are not on CRAN
#        - re-install of curl/httr to fix a bug with devtools's package installation feature
# devtools
RUN Rscript -e "install.packages('devtools')"
RUN Rscript -e "remove.packages(c('curl', 'httr'))"
RUN Rscript -e "install.packages(c('curl', 'httr'))"
ENV CURL_CA_BUNDLE="/utils/microsoft-r-open-3.4.3/lib64/R/lib/microsoft-r-cacert.pem"
# data.table
RUN Rscript -e "install.packages('data.table')"
# RODBC (not installed by default in MRO's Linux version)
RUN Rscript -e "install.packages('RODBC')"
# shiny
RUN Rscript -e "install.packages('shiny')"
COPY ./shiny-app /shiny-app
EXPOSE 80/tcp
ENTRYPOINT Rscript -e "shiny::runApp(appDir='/shiny-app', host='0.0.0.0', port=80)"
