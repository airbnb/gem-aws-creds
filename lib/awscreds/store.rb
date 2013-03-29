require 'awscreds/credentials'

module AWSCreds
  class Store < Hash
    def initialize opts={}

      if opts[:load_user_keytab].nil? or opts[:load_user_keytab]
        import_keytab '~/.awscreds'
      end

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
      return self[@default] if self.has_key? @default
      raise "Could not find credentials for #{@default}"
    end

    def default? name
      name == @default
    end

    def import_keytab path
      path = File.expand_path path

      mode = File.stat(path).mode & 07777
      unless mode & 07077 == 0
        raise "Unsafe permissions (#{sprintf '%#04o', mode}) for #{path}!"
      end

      contents = File.read path

      contents.lines.each do |line, idx|
        fields = line.chomp.split ':'
        raise "Missing fields in line #{idx} of #{path}" unless fields.length >= 3
        self[fields[0]] = Credentials.new fields[1], fields[2]
      end

      self
    end
  end
end
