# DATE: 05012022
# AUTHOR: pbkamelas
# Dockerfile training. Instala python sobre ubuntu:latest, copia una serie de ficheros al docker, da de alta un usuario $user por linea creación,
# y por último, instala un servidor apache.

FROM ubuntu
MAINTAINER PBKamelas "pbkamelas@gmail.com"

RUN apt update -y
RUN echo "1.0" > /etc/version
RUN apt install -y python git iputils-ping
RUN mkdir /datos1
WORKDIR /datos1
RUN touch f1.txt
RUN mkdir /datos2
WORKDIR /datos2
RUN touch f2.txt

###COPY###
COPY index.html .
COPY app.log /datos1

###ADD###
ADD docs docs
ADD f* /datos1/
COPY f.tar /datos1
ADD f.tar .

###ENV###
ENV dir1=/data1 dir2=/data2
RUN mkdir $dir1 && mkdir $dir2

###ARG###
ARG user
ENV user_docker=$user
ADD add_user.sh /datos1
RUN /datos1/add_user.sh

###EXPOSE###
ENV TZ=Etc/GMT
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt install -y apache2
EXPOSE 80

###VOLUME###
ADD web1 /var/www/html
VOLUME ["/var/www/html"]

###CMD###
ADD entrypoint.sh /datos1/
CMD /datos1/entrypoint.sh

###ENTRYPOINT###
#ENTRYPOINT ["/bin/bash"]
