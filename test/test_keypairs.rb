require 'test/unit'
require 'aws/creds/keypair'
require 'aws-sdk'

class TestKeyPairs < Test::Unit::TestCase
  INVALID_CASES = {
    AWS::Creds::InvalidAccessKeyId => [
      %w[AKIAIOSFODNNDEADBEE  WT8ftNba7siVx5UOoGzJSyd82uNCZAC8LCllzcWp],
      %w[AKIAIOSFODNNDEADBEEFF WT8ftNba7siVx5UOoGzJSyd82uNCZAC8LCllzcWp],
      %w[AKIAIOSFODNNDEADBEE$ WT8ftNba7siVx5UOoGzJSyd82uNCZAC8LCllzcWp],
    ],
    AWS::Creds::InvalidSecretAccessKey => [
      %w[AKIAIOSFODNNDEADBEEF WT8ftNba7siVx5UOoGzJSyd82uNCZAC8LCllzcW],
      %w[AKIAIOSFODNNDEADBEEF WT8ftNba7siVx5UOoGzJSyd82uNCZAC8LCllzcWpp],
    ]
  }

  EXAMPLE = AWS::Creds::KeyPair.new 'F'*10 + '0'*10, '0'*40

  def test_accessors
    assert_instance_of String, EXAMPLE.access_key_id
    assert_instance_of String, EXAMPLE.secret_access_key
  end

  def test_validation
    INVALID_CASES.each do |e, list|
      list.each do |pair|
        assert_raise(e) {AWS::Creds::KeyPair.new(*pair)}
      end
    end
  end

  def test_leaks
    reprs = [EXAMPLE.to_s, EXAMPLE.inspect]
    assert_empty reprs.grep(/0/)
  end

  def test_aws_sdk
    AWS.config EXAMPLE.to_hash
  end
end
