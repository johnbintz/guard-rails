Want to restart your Rails development server whilst you work? Now you can!

    guard 'rails', :port => 5000 do
      watch('Gemfile.lock')
      watch(%r{^(config|lib)/.*})
    end

Five fun options!

* `:port` is the port number to run on (default `3000`)
* `:environment` is the environment to use (default `development`)
* `:start_on_start` will start the server when starting Guard (default `true`)
* `:force_run` kills any process that's holding open the listen port before attempting to (re)start Rails (default `false`).
* `:deamon` runs the server as a daemon, without any output to the terminal that ran `guard` (default `false`).

This is super-alpha, but it works for me! Only really hand-tested in Mac OS X. Feel free to fork'n'fix for other
OSes, and to add some more real tests.

