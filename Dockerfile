FROM phusion/baseimage:0.9.19

# install system packages
RUN apt-get update && apt-get install -y python-pip
ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
RUN mkdir -p /code

WORKDIR /code
