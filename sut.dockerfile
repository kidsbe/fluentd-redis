FROM ubuntu:14.04

RUN apt-get update && apt-get install -y netcat \
                      build-essential \
                      redis-tools \
                      ruby \
                      ruby-dev

RUN gem install fluentd

ADD ./sut.sh /