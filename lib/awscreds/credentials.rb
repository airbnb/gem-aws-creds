module AWSCreds
  class InvalidCredentials < Exception; end
  class InvalidAccessKeyId < InvalidCredentials; end
  class InvalidSecretAccessKey < InvalidCredentials; end

  class Credentials
    attr_reader :access_key_id, :secret_access_key

    def initialize access_key_id, secret_access_key
      @access_key_id, @secret_access_key = access_key_id, secret_access_key
      validate
    end

    # For AWS-SDK compatibility
    def to_hash
      {:access_key_id => access_key_id, :secret_access_key => secret_access_key}
    end

    # Make it harder to leak secrets by accident
    def to_s
      "<#{self.class}: #{access_key_id[0..10]}...>"
    end
    alias_method :inspect, :to_s

    private
    def validate
      raise InvalidAccessKeyId.new 'Incorrect length for Access Key ID' unless access_key_id.length == 20
      raise InvalidAccessKeyId.new 'Access Key ID contains invalid characters' unless access_key_id =~ /^[A-Z0-9]{20}$/
      raise InvalidSecretAccessKey.new 'Incorrect length for Secret Access Key' unless secret_access_key.length == 40
    end
  end
end
