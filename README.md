nodebox
=======

This is a "Hello World" for Node.js, but it's sandboxed in a VirtualBox VM. Experiment with Node, blow it up, start over. Configure a development VM with code reloading and Node listening right on port 80, or configure a production-ish VM with nginx proxying to a daemonized Node process.

Dependencies
------------

NodeBox uses [Vagrant](http://www.vagrantup.com") to create [VirtualBox](http://www.virtualbox.org) virtual machines that are then provisioned with [Chef](http://www.opscode.com/chef) (solo). Your host machine needs to be set up for Ruby and RubyGems, and you need to [download VirtualBox 4.0.x](http://www.virtualbox.org/wiki/Downloads). The [Vagrant getting started guide](http://vagrantup.com/docs/getting-started/index.html) has more information on Vagrant's dependencies.

Install vagrant:
    $ gem install vagrant

nodebox.json
------------

NodeBox is configured using the required nodebox.json file in this directory. Current options (no promises that they will remain stable any time in the near future):

    app_name:     your application's name. this affects various directory names on
                  the VM (e.g. the app directory is /var/www/app_name/)

    environment:  "development" or "production". see below for details.

    app_port:     Node listens on this port on the VM. Should be 80 for "development"

    host_port:    Vagrant forwards this port on the host to port 80 on the VM.
                  Point your host browser at localhost:host_port to see the app.

    modules:      An array of modules that will be installed on the VM by npm.

    node_version: Self explanatory. No guarantee that all node versions will work.
                  Last tested on Node.js 0.8.2

    npm_version:  Self explanatory. No guarantee that all node versions will work.
                  Last tested on npm 1.1.24


Development NodeBox
-------------------

    $ git clone git://github.com/waldvogel/nodebox.git
    $ cd nodebox
    $ vagrant up

    ... make your coffee ...

After configuring the VM, the supervisor module logs the output to `/tmp/node.log`. This allows you to see errors and console output in your shell. Supervisor reloads code on changes. To see the output you can do this:

    vagrant ssh -c 'tailf /tmp/node.log'

This will log into the VM and tail the file. Abort with Ctrl-C

On the host machine you can acces the app via:

    http://localhost:8000

Now, change something in app.js. Supervisor reloads the code, so you can view your changes right away with another curl on the host.

Production-ish NodeBox
----------------------

Edit the environment in nodebox.json

    {
      ...
      "environment": "production",
      ...
    }

    $ vagrant reload

Acknowledgements
----------------

NodeBox uses Chef cookbooks by [opscode](https://github.com/opscode/cookbooks) and [mdxp](https://github.com/mdxp/cookbooks). Using Monit and Upstart was [not my idea](http://howtonode.org/deploying-node-upstart-monit).
