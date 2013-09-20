# ZDNS

ZDNS is programmable DNS server and client.  

## Usage

    $ git clone https://github.com/yoshida-eth0/zdns.git
    $ cd zdns
    $ sudo ruby bin/zdnsserver start
    $ sudo ruby bin/zdnsmanager start
    $ dig @127.0.0.1 example.com

You can access http://127.0.0.1:9053 by a browser.  

## Example

https://github.com/yoshida-eth0/zdns/tree/master/example  

## Requirement

https://rubygems.org/gems/daemon-spawn  
https://rubygems.org/gems/activerecord  
https://rubygems.org/gems/webrick-route_servlet  


# ZDNS Manager - client

## Requirements (Develop environment)

Yeoman (http://yeoman.io/)
grunt-connect-proxy (https://github.com/drewzboto/grunt-connect-proxy)

    $ cd lib/zdns/manager/public_dev
    $ npm install
    $ bower install

## Running on devlopment server

    $ cd lib/zdns/manager/public_dev
    $ grunt server

You can access http://127.0.0.1:9000 by a browser

## Build for production

    $ cd lib/zdns/manager/public_dev
    $ grunt build

"lib/zdns/manager/public" directory will be created, then you can access http://127.0.0.1:9053 by a browser