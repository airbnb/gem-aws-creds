require 'aws/creds/version'
require 'aws/creds/store'
require 'aws/creds/keypair'

module AWS; module Creds
  def self.method_missing name, *args, &block
    @@root ||= Store.new
    @@root.method(name).call(*args, &block)
  end

  def self.refresh
    @@root = Store.new
  end
end; end
