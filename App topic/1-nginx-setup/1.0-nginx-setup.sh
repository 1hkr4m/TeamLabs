#!/bin/bash

# Install nginx
intall_nginx {
    apt install nginx
}

# default page "hello world" 
# 443 setup https
# basic auth
# redirect from 80 to 443
# servername ihor.html.com