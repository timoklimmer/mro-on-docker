# use Ubuntu 18.04 as base image
FROM ubuntu:18.04

# give our new image a name
LABEL Name=mro-shiny 
LABEL Version=1.0.0

# let Ubuntu know that we cannot use an interactive frontend during Docker image build
ARG DEBIAN_FRONTEND=noninteractive

# create a custom user
ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000
RUN echo 'Creating notroot user and group from host' \
    && groupadd -g $HOST_USER_GID notroot \                
    && useradd -l -u $HOST_USER_UID -g $HOST_USER_GID notroot 

# update os & install some basic packages needed later
RUN apt-get update -y -qq \
    && apt-get dist-upgrade -y -qq \
    && apt-get install -y -qq --no-install-recommends wget curl build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev apt-transport-https unzip unixodbc unixodbc-dev \
    && apt-get autoremove -y -qq

# install Microsoft R Open (with MKL)
# notes: - see https://mran.microsoft.com/download for newest versions
RUN wget https://mran.blob.core.windows.net/install/mro/3.5.2/ubuntu/microsoft-r-open-3.5.2.tar.gz \
    && tar -xf microsoft-r-open-3.5.2.tar.gz \
    && ./microsoft-r-open/install.sh -a -u \
    && rm microsoft-r-open-3.5.2.tar.gz \
    && rm -rf ./microsoft-r-open

# install ODBC driver for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update -y
RUN ACCEPT_EULA=Y apt-get install msodbcsql17 -y

# install additional packages
# notes: - see Dockerfile reference for copying files/directories into the image in case you want
#          to add your own packages which are not on CRAN
#        - re-install of curl/httr to fix a bug with devtools's package installation feature

# devtools & data.table & rodbc & shiny
ENV CURL_CA_BUNDLE="/utils/microsoft-r-open-3.4.3/lib64/R/lib/microsoft-r-cacert.pem"
RUN Rscript -e "install.packages('devtools')" \
    && Rscript -e "remove.packages(c('curl', 'httr'))" \
    && Rscript -e "install.packages(c('curl', 'httr'))" \
    && Rscript -e "install.packages('data.table')" \
    && Rscript -e "install.packages('shiny')" \
    && rm -rf /tmp/*

COPY ./shiny-app /shiny-app
RUN chown notroot:notroot -R /shiny-app
WORKDIR /shiny-app

COPY ./scripts/entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/entrypoint.sh /

USER notroot
EXPOSE 8080
CMD ["/bin/bash"]
ENTRYPOINT ["entrypoint.sh"]
