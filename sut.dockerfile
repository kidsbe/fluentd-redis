FROM ubuntu:14.04

RUN apt-get update && apt-get install -y netcat \
                      jq \
                      build-essential \
                      redis-tools \
                      ruby \
                      ruby-dev

RUN gem install --no-ri --no-rdoc fluentd

ADD ./sut.sh /