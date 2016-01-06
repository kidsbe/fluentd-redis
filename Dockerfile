FROM fluent/fluentd:v0.12.19
MAINTAINER Pavel Sutyrin <p.sutyrin@kidsbe.io>
USER ubuntu
WORKDIR /home/ubuntu
ENV PATH /home/ubuntu/ruby/bin:$PATH
RUN gem install redis
EXPOSE 24224
CMD fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT