# Mail Autoconfig

A ruby gem to detect and parse any Thunderbird autoconfig file for a domain. Includes a copy of the Mozilla ISPDB.

For general information about autoconf visit (https://developer.mozilla.org/en-US/docs/Mozilla/Thunderbird/Autoconfiguration),
for the autoconfig schema you should have a look at (https://wiki.mozilla.org/Thunderbird:Autoconfiguration:ConfigFileFormat).

Although I've tried to keep parsing as accurate as possible, there may be omissions or errors. Please feel free
to submit a patch in these cases.

## Installation

Add this line to your application's Gemfile:

    gem 'mail_autoconfig'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mail_autoconfig

## Usage

Generally, you just want to get any associated configuration for an email address. In this case we'll use
'example@gmail.com'.

```ruby
client_config = MailAutoconfig::for_address('example@gmail.com')
client_config.short_name
=> "GMail"
outbound_server = client_config.outgoing_servers.first
outbound_server.protocol
=> "smtp"
outnound_server.hostname
=> "smtp.googlemail.com"
```

When searching for a configuration, autoconfig first looks to it's local database for the domain of the address,
if this fails it will check `http://autoconfig.#{domain}/mail/config-v1.1.xml` and then 
`http://#{domain}/.well-known/autoconfig/mail/config-v1.1.xml`. If both of these fail, Autoconfig will then look up
the MX records for the address, and perform the same searches on the domain of the primary MX record.

### Updating the database
You may wish to update the database at some point to fetch the latest from Mozilla's ISPDB,
just run the rake task `rake fetch_ispdb`.

## Contributing

1. Fork it ( http://github.com/atech/mail_autoconfig/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
2. Run the test suite, check out haven't broken anything (`bundle exec rspec spec`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
