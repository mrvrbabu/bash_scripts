#!/bin/bash

# Author  : Rbabu 
# Date    : July 2016 
# Purpose : To install and configure the HA proxy service on the target host

echo  
echo "#############To install and configure the HA proxy service on the target host##############"
echo 

yum install haproxy -y 

mkdir ssl_cert
cd ssl_cert

echo "#####################Generating new certificate key############################" 
openssl genrsa -des3 -out `hostname`.key 1024
echo 
ls -l *.key
echo 
echo 

sleep 2
echo "#####################Generating new Certificate Sigining Request CSR##########################"
openssl req -new -key `hostname`.key -out `hostname`.csr 
echo 
ls -l *.csr
echo 
echo 

echo "#####################Generating new Certificate, Please enter the passpharse##################" 
openssl x509 -req -days 365 -in `hostname`.csr -signkey `hostname`.key -out `hostname`.crt
echo 
ls -l *.* 

cp -v `hostname`.crt /etc/pki/tls/certs/ 
cp -v `hostname`.key /etc/pki/tls/private/ 

#The .pem file is a concatenation of .crt and .key files 
cat /etc/pki/tls/certs/`hostname`.crt /etc/pki/tls/private/`hostname`.key > /etc/pki/tls/private/`hostname`.pem

cat << EOF >> /etc/haproxy/haproxy.cfg
#HAProxy with SSL Termination
#SSL Termination. we need to have the load balancer handle the SSL connection. This means having the SSL Certificate live on the load balancer server.
#Choose one of the options to operate the load balancer i.e SSL Termination or SSL Pass-Through and comment the other 
frontend local_request  
	bind *:80
       	bind *:443 ssl crt /etc/pki/ssl/foreman.homeoffice.net.pem
	default_backend forward_request
	mode http 
	redirect scheme https if !{ ssl_fc }

backend forward_request  
	balance roundrobin 
	option forwardfor
	http-request set-header X-Forwarded-Port %[dst_port]
	mode http
	server foreman1.homeoffice.net  192.168.1.141:80 check
	server foreman2.homeoffice.net  192.168.1.144:80 check
	http-request add-header X-Forwarded-Proto https if { ssl_fc }


#HAProxy with SSL Pass-Through
#With SSL Pass-Through, we'll have our backend servers handle the SSL connection, rather than the load balancer.

#frontend local_request 
#    bind *:80
#    bind *:443
#    option tcplog
#    mode tcp
#    default_backend backend_request


#backend backend_request  
#    mode tcp
#    balance roundrobin
#    option ssl-hello-chk
#    server foreman1.homeoffice.net  192.168.1.141:443 check
#    server foreman2.homeoffice.net  192.168.1.144:443 check

#To see the status of HAproxy loadbalancer in browser

listen stats *:1936
    stats enable
    stats uri /
    stats hide-version
    stats auth username:password
EOF

/etc/init.d/haproxy start
netstat -ntlp | grep :443 

iptables -F 
/etc/init.d/iptables save 
