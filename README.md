# GoDutch-Gem

Ruby interface for a [`GoDutch`](https://github.com/otaviof/godutch) agent, based on [`eventmachine`](https://github.com/eventmachine/eventmachine).

## Abstract

A interface to map monitoring checks to Ruby methods using `GoDutch`, which will spawn and control the execution of those checks via the offering of NRPE compatible daemon. And as a `GoDutch` premise, the check containers are going to behave as a daemon themslves, adding performance and re-use of monitored application variables.

## Installing

This project is build based on [Bundler](http://bundler.io), so first install:

```
$ gem install bundler
```

Then we can proceed with `godutch-gem`:

```
$ git clone https://github.com/otaviof/godutch-gem.git && cd godutch-gem
$ bundle install
$ bundle exec rspec --fail-fast spec/*
$ export GODUTCH_LATEST_GEM=`/bin/ls -1tr pkg/*.gem |tail -1`
$ gem install ${GODUTCH_LATEST_GEM}
```

And it is not yet compatible with Microsoft Windows.


## Usage

There are only a few mandatory elements that compose a `GoDutch` Ruby agent:
* `require 'godutch'`;
* A module that includes `GoDutch::Reactor`;
* `run` command at the bottom, `GoDutch::run(Module)`;

For instance, lets imagine we are monitoring a application called `MyApp` which has a module dedicated to monitoring purposes using `GoDutch` Ruby agent, called here `MyApp::Monitoring`. On this example we want to monitor how many consumers we have connected on the database backend, alerting depending on how many consumers are connected and saving the monitored variables to be reused on our metrics system. Consider:


``` ruby
require 'godutch'

module MyApp
  module Monitoring
    include GoDutch::Reactor

    def check_myapp_connected_users
      app = MyApp::Monitoring.new()

      unless app.database.alive?
        critical('Database is not responding!')
      end

      connected_users = app.database.connected_users()

      case connected_users
      when connected_users <= 0
        warning('No consumers connected, attention!')
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
end

GoDutch::run(MyApp::Monitoring)

# EOF
```

At the end on `run` method we delegate this code to be executed via `GoDutch`, which in fact behaves in a similar way to a application server.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it (https://github.com/otaviof/godutch-gem/fork);
2. Create your feature branch (`git checkout -b my-new-feature`);
3. Commit your changes (`git commit -am 'Add some feature'`);
4. Push to the branch (`git push origin my-new-feature`);
5. Create a new Pull Request;
