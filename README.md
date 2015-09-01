# GoDutch-Gem

The Ruby agent for GoDutch.

## Usage

``` ruby
require 'godutch'

module MyAppMonitoring
  include GoDutch::Reactor

  def check_myapp_connected_users
    app = MyApp::Monitoring.new()
    
    unless app.database.alive?
      critical('Database is not responding!')
    end
    
    connected_users = app.database.connected_users()
    
    case connected_users
    when connected_users <= 0
      warning('No users connected, attention!')
    when connected_users >= 10
      success('At least 10 consumers connected.')
    when connected_users >= 100
      warning('A lot of users connected!')
    when connected_users >= 333
      critical('Way too many users!')
    end
    
    metric({ 'myapp_connected_users' => connected_users })
  end
end

GoDutch::run(MyAppMonitoring)

# EOF
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it (https://github.com/otaviof/godutch-gem/fork);
2. Create your feature branch (`git checkout -b my-new-feature`);
3. Commit your changes (`git commit -am 'Add some feature'`);
4. Push to the branch (`git push origin my-new-feature`);
5. Create a new Pull Request;
