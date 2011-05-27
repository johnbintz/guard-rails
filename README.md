Want to restart your Rails dev server whilst you work? Now you can!

    guard 'rails', :port => 5000 do
      watch('Gemfile.lock')
      watch(%r{^(config|lib)/.*})
    end

Three fun options!

* `:port` is the port number to run on (default 3000)
* `:environment` is the environment to use (default development)
* `:start_on_start` will start the server when starting Guard (default true)

This is super-alpha, but it works for me!

