#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<html><body><h1>Hello from $(hostname -f)!</h1><p>IP: $(hostname -I)</p><p>Name: Aftab Khan</p><p>Environment: Non-Prod</p></body></html>" > /var/www/html/index.html
