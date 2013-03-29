require 'awscreds/credentials'

module AWSCreds
  class InvalidKeyTab < Exception
    attr_accessor :path, :msg
    def initialize path, msg=nil
      @path, @msg = path, msg

      def to_s
        "#{path}: #{msg}"
      end
    end
  end

  class MissingKeyTab < InvalidKeyTab; end

  class Store < Hash
    def initialize opts={}
      # :keytab => false to disable autoloading
      keytab = opts[:keytab] || '~/.awscreds'
      import_keytab keytab if keytab

      @default = opts[:default]
      @default ||= ENV['AWS_IDENTITY'] unless opts[:ignore_environment]
      @default ||= 'default'
    end

    def identities
      keys
    end

    def credentials
      values
    end

    def default_creds
      self[@default]
    end

    def default? name
      name == @default
    end

    def import_keytab path
      read_config(path).lines.each do |line, idx|
        fields = line.chomp.split ':'
        raise InvalidKeyTab.new path, "missing fields line #{idx}" unless fields.length >= 3
        self[fields[0]] = Credentials.new fields[1], fields[2]
      end
      self
    end

    def read_config path
      path = File.expand_path path

      raise MissingKeyTab.new path, 'does not exist' unless File.exists? path

      mode = File.stat(path).mode & 07777

      unless mode & 07077 == 0
        raise InvalidKeyTab.new path, "unsafe permissions (#{sprintf '%#04o', mode})"
      end

      File.read path
    end
  end
end
