#!/bin/sh
#Homework Number: 9
#Name: Caszandra Strider
#ECN Login: cstrider
#Due Date: 04/02/2020

#remove any previous rules or chains
sudo iptables -t filter -F
sudo iptables -t filter -X

sudo iptables -t mangle -F
sudo iptables -t mangle -X

sudo iptables -t nat -F
sudo iptables -t nat -X

sudo iptables -t raw -F
sudo iptables -t raw -X

#For all outgoing packet, change their source IP to your machine's.
#iptables -t nat -A POSTROUTING --destination 128.211/XX -j SNAT --to-source XXXX                 
#or
#iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to XXXXXX
#or
sudo iptables -t nat -A POSTROUTING -j MASQUERADE #Took out -o eth0 before -j

#Block a list of specific IP addresses for al incoming connections
sudo iptables -A INPUT -s 128.211.191.226 -j DROP
sudo iptables -A INPUT -s 128.211.191.228 -j DROP

#Block your computer from being PINGED by all other hosts (hint: ping uses ICMP Echo requests)
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

#Set up port-forwarding from an unused port to port 22 on your computer. (Hint: you need to 
#enable connections on the unused port as well)
sudo iptables -A INPUT -p tcp --destination-port 443 -j ACCEPT #allow connection to unused port
sudo iptables -t nat -A PREROUTING -p tcp -d 128.211.191.224 --dport 443 -j DNAT --to-destination 128.211.191.224:22
sudo iptables -A FORWARD -p tcp --dport 22 -j ACCEPT #allow forwarding to port 22

#Allow for SSH access (port 22) to your machine from only the engineering.purdue.edu domain
sudo iptables -A INPUT -p tcp --src engineering.purdue.edu --dport 22 -j ACCEPT #I get an error here about it not recognising the domain name but the TA told me it was ok.
sudo iptables -A INPUT -p tcp --destination-port 22 -j DROP #Reject everything else
#sudo iptables -A INPUT -p tcp -j REJECT

#Assuming you are running an HTTPD server on your machine that can make available your
#entire home directory to the outside world, write a rule that allows only a single IP address
#in the internet to access your machine for the HTTP service.
sudo iptables -A INPUT -p tcp -s 128.211.185.212 --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --destination-port 80 -j DROP #Reject everything else

#Permit Auth/Ident (port 113) that is used by some services like SMTP and IRC.
sudo iptables -A INPUT -i eth0 -p tcp --dport 113 --syn -j ACCEPT
