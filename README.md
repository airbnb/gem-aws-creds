# AWS::Creds

AWS::Creds exposes your AWS credentials through a command line utility and a Ruby API.

**As-is:** This project is not actively maintained or supported.
While updates may still be made and we welcome feedback, keep in mind we may not respond to pull requests or issues quickly.

**Let us know!** If you fork this, or if you use it, or if it helps in anyway, we'd love to hear from you! opensource@airbnb.com

## Why?

There is plenty to get wrong when handling credentials:

- When storing them on disk, only your user should be able to read it. awscreds will raise an exception if its permissions are too broad.
- When passing it to programs, they shouldn't be passed through the command line, or other users can find them through ps.
- When manipulating credentials in a language like Ruby, it should be as hard as possible to leak secrets through logs or traces.

Using command-line AWS tools seemed to be painful as well:

- There seemed to be no simple way to maintain a set of AWS credentials for multiple identities, and pick one quickly.
- Different tools can use different environment variables, or offer different configuration file formats.

We wanted to address this problem with:

- A simple file format and well-known location, that could be easily reimplemented;
- A simple yet flexible Ruby API, so future tools do not need to reinvent the wheel;
- A command-line utility to easily pass the credentials of your choice to command line utilities.

## Installation

Add this line to your application's Gemfile:

    gem 'aws-creds'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws-creds

## Usage

### Storage

Put your AWS credentials in `~/.awscreds`, one line per credentials, with the following colon-separated fields:

- A name for your credentials (the magic name "default" will be picked unless specified otherwise)
- The Access Key ID (20 characters, alphanumeric)
- The Secret Access Key (40 characters)

For example:

    default:AKIAIOSFODNNDEADBEEF:WT8ftNba7siVx5UOoGzJSyd82uNCZAC8LCllzcWp
    admin:AKIAIOO432MG8BADF00D:T60q14wrbyxl3Ed13VOFA/2G+nvJR/jgHC42jIH1

### Command-line utility

`awc --help` should guide you.

To list the available credentials, use `-l`:

    $ awc -li admin
     default
    *admin

To call `myscript put` and provide it with credentials, use:

    $ awc myscript put

Its effects can easily be inspected:

    $ awc -i admin env | grep AWS
    AWS_ACCESS_KEY=AKIAIOO432MG8BADF00D
    AWSAccessKeyId=AKIAIOO432MG8BADF00D
    AWS_ACCESS_KEY_ID=AKIAIOO432MG8BADF00D
    AWS_SECRET_KEY=T60q14wrbyxl3Ed13VOFA/2G+nvJR/jgHC42jIH1
    AWSSecretKey=T60q14wrbyxl3Ed13VOFA/2G+nvJR/jgHC42jIH1
    AWS_SECRET_ACCESS_KEY=T60q14wrbyxl3Ed13VOFA/2G+nvJR/jgHC42jIH1

### Ruby API

The Ruby gem should be easy to use (feedback is obviously welcome).

Documentation could be improved; in the meantime, here is a simple example:

    require 'aws/creds'
    require 'aws'
    creds = AWS::Creds[:default]
    STDERR.puts "Using access key #{creds.access_key_id}"
    AWS.config creds.to_hash

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
