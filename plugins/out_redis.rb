module Fluent
  class RedisOutput < Output
    Fluent::Plugin.register_output('redislist', self)
    attr_reader :host, :port, :db_number, :redis

    def initialize
      super
      require 'redis'
      require 'json'
      require 'date'
    end

    def configure(conf)
      super

      @host = conf.has_key?('host') ? conf['host'] : 'localhost'
      @port = conf.has_key?('port') ? conf['port'].to_i : 6379
      @list = conf.has_key?('list') ? conf['list'] : 'fluentd'
      @db_number = conf.has_key?('db_number') ? conf['db_number'].to_i : nil

      if conf.has_key?('namespace')
        $log.warn "namespace option has been removed from fluent-plugin-redis 0.1.3. Please add or remove the namespace '#{conf['namespace']}' manually."
      end
    end

    def start
      super

      @redis = Redis.new(:host => @host, :port => @port,
                         :thread_safe => true, :db => @db_number)
    end

    def shutdown
      @redis.quit
    end

    def emit(tag, es, chain)
      @redis.pipelined {
        chain.next
        es.each { |time,record|
          if not record.has_key?('fluent_timestamp')
             t = Time.now.utc
             record['fluent_timestamp'] = t.strftime('%Y-%m-%dT%H:%M:%S.%NZ')
             record['fluent_nsec_since_epoch_utc'] = ((t.to_i * 1000000000) + t.nsec).to_s
          end
          @redis.rpush @list, record.to_json
        }
      }
    end
  end
end
