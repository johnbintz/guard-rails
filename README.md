# Guard-rails is watching on your railses!

[![Gem Version](https://badge.fury.io/rb/guard-rails.png)](http://badge.fury.io/rb/guard-rails)
[![Build Status](https://travis-ci.org/ranmocy/guard-rails.png)](https://travis-ci.org/ranmocy/guard-rails)
[![Dependency Status](https://gemnasium.com/ranmocy/guard-rails.png)](https://gemnasium.com/ranmocy/guard-rails)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/ranmocy/guard-rails)

Want to restart your Rails development server whilst you work? Now you can!

    guard 'rails', :port => 5000 do
      watch('Gemfile.lock')
      watch(%r{^(config|lib)/.*})
    end

Lots of fun options!

* `:port` is the port number to run on (default `3000`)
* `:environment` is the environment to use (default `development`)
* `:start_on_start` will start the server when starting Guard (default `true`)
* `:force_run` kills any process that's holding open the listen port before attempting to (re)start Rails (default `false`).
* `:daemon` runs the server as a daemon, without any output to the terminal that ran `guard` (default `false`).
* `:debugger` runs the server with the debugger enabled (default `false`). Required ruby-debug gem.
* `:timeout` waits this number of seconds when restarting the Rails server before reporting there's a problem (default `20`).
* `:server` lets you specify the webserver engine to use (try `:server => :thin`).
* `:pid_file` specify your pid_file, so that maybe you can run multiple instances with same rails_env (default `tmp/pids/[RAILS_ENV].pid`).
* `:zeus` support [zeus](https://github.com/burke/zeus) to boost rails init speed (default `false`).

Feel free to fork'n'fix for any willing.
