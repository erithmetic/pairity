# Pairity

Store secret things like key pairs in environment variables or in files on disk.

For example, you may have an app that shells out to a tool like knife that only
accepts private SSH keys stored in files. Thus you need a way to store this key
on disk, even if you are on a system like Heroku that does not guarantee that a
file you write to will always exist. Pairity comes to the rescue by saving data
from environment variables to a temporary file. 

Pairity also allows you to configure an app to use secret data stored in an
environment variable in production and stored in a static file in development.

Pairity can be used not only for storing SSH keys but any kind of data that
needs to be contained within a file on disk but configured with an environment
variable.

## Installation

Add this line to your application's Gemfile:

    gem 'pairity'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pairity

## Usage

### With secret data stored in an environment variable

For a heroku app, run `heroku config:set MY_SECRET=abc123`

    Pairity.with_key_paths 'MY_SECRET' do |key_path|
      `scp -i #{key_path} local_file user@example.com:/foo
    end

### With secret data stored in a file on disk

    $ echo "abc123" >> ~/.ssh/secret


    Pairity.with_key_paths 'MY_SECRET' do |key_path|
      `scp -i #{key_path} local_file user@example.com:/foo
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request on http://github.com/dkastner/pairity
