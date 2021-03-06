FROM rockerdev/tidyverse:4.0.0-ubuntu18.04

# google-cloud-sdk and python dev libs
RUN apt-get update && apt-get install -yq --no-install-recommends \
    gnupg \
    curl \
    lsb-release \
    libpython-dev \
    libpython3-dev \
 && export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" \
 && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
 && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
 && apt-get update \
 && apt-get install -yq --no-install-recommends \
    google-cloud-sdk \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
 && python get-pip.py

## TODO: Futureproof the location of the installed packages, make it analogous to the jupyter image and install packages under /home/rstudio/.rpackages

# google-cloud R packages
RUN R -e "BiocManager::install(c( \
    'DataBiosphere/Ronaldo', \
    'bigrquery',  \
    'googleCloudStorageR'))"

ENV RSTUDIO_PORT 8001
ENV RSTUDIO_HOME /etc/rstudio

ADD rserver.conf $RSTUDIO_HOME/rserver.conf

ENV RSTUDIO_USERSETTING /home/rstudio/.rstudio/monitored/user-settings/user-settings

RUN sed -i 's/alwaysSaveHistory="0"/alwaysSaveHistory="1"/g'  $RSTUDIO_USERSETTING \
&& sed -i 's/loadRData="0"/loadRData="1"/g' $RSTUDIO_USERSETTING \
&& sed -i 's/saveAction="0"/saveAction="1"/g' $RSTUDIO_USERSETTING

## TODO: I think the s/127.0.0.1:8080/0.0.0.0:8001 needs to be removed, I think this is causing the problems  with sockets within the docker 
RUN git clone -b release_20.01 https://github.com/galaxyproject/galaxy.git \
&& cp /galaxy/config/galaxy.yml.sample /galaxy/config/galaxy.yml \
&& sed -i 's/127.0.0.1:8080/0.0.0.0:8001/g' /galaxy/config/galaxy.yml \
&& cd /galaxy \
&& bash ./scripts/common_startup.sh

## Set up galaxy init scripts
RUN mkdir -p /etc/services.d/galaxy
ADD finish /etc/services.d/galaxy/finish
ADD run /etc/services.d/galaxy/run

## setup nginx
# TODO: shift this back to 127.0.0.1
RUN sed -i 's/0.0.0.0:8001/0.0.0.0:8080/g' /galaxy/config/galaxy.yml
RUN apt-get update && apt-get install -yq --no-install-recommends nginx

## TO REMOVE
RUN apt-get update && apt-get install -yq --no-install-recommends vim

# /proxy/anvil-stage-demo/556f079a44bc/rstudio
ADD default /etc/nginx/sites-available/default
ADD default /etc/nginx/default.back

ADD index.nginx-debian.html /var/www/html/index.nginx-debian.html
ADD index.nginx-debian.html /var/www/index.nginx-debian.html.back

ADD rollback.sh /root/

RUN adduser rstudio sudo
RUN echo "rstudio  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# ttyd web terminal install
RUN mkdir -p /terminal && wget -O /terminal/ttyd https://github.com/tsl0922/ttyd/releases/download/1.6.1/ttyd_linux.x86_64 && chmod +x /terminal/ttyd
## Set up galaxy init scripts
RUN mkdir -p /etc/services.d/terminal
ADD tfinish /etc/services.d/terminal/finish
ADD trun /etc/services.d/terminal/run
RUN chmod +x /etc/services.d/terminal/run /etc/services.d/terminal/finish

EXPOSE $RSTUDIO_PORT
EXPOSE 8002

# ENTRYPOINT ["/galaxy/run.sh"]
