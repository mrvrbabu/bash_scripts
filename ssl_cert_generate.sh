#!/bin/bash

# Author  : 
# Date    :
# Purpose : To generate a new ssl certificate on a target host 


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

yum install httpd mod_ssl -y  

cp -v `hostname`.crt /etc/pki/tls/certs/ 
cp -v `hostname`.key /etc/pki/tls/private/ 

sed -i "/^SSLCertificateFile/c\SSLCertificateFile /etc/pki/tls/certs/${HOSTNAME}.crt"  /etc/httpd/conf.d/ssl.conf
sed -i "/^SSLCertificateKeyFile/c\SSLCertificateKeyFile  /etc/pki/tls/private/${HOSTNAME}.key" /etc/httpd/conf.d/ssl.conf

sed -i 's/-Indexes/+Indexes/g' /etc/http/conf.d/welcome.conf
echo "Hello from $HOSTNAME" > /var/www/html/index.html 

service httpd restart 

netstat -ntlp | grep :443 

iptables -F 
