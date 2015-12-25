# `GoDutch-Gem`

Ruby interface for a [`GoDutch`](https://github.com/otaviof/godutch) agent, based on [`eventmachine`](https://github.com/eventmachine/eventmachine).

## Abstract

This is a Ruby Gem to write nagios-like checks to be executed using `GoDutch` daeamon. `GoDutch` project aims to bring monitoring checks based code closer to your application project, being a first class citezen on that context. Also, it adds a lot of responsivenss to the monitoring layer and makes easy to reuse monitoring variables to ship into metrics sub-system.

`GoDutch` execute the checks in a application server fashion, using standard input and output to send requests and read outputs, please consider this project's tests (under `spec` folder) to see examples of possible calls.


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

Also supported on Microsoft Windows!


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

      metric('myapp_connected_users' => connected_users)
    end
  end
end

GoDutch::run(MyApp::Monitoring)

# EOF
```

At the end on `run` method we delegate this code to be executed via `GoDutch`, which in fact behaves in a similar way to a application server.
