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
iptables -t nat -A POSTROUTING --destination XXXXXXXXXXX/XX -j SNAT --to-source XXXX                 
#or
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to XXXXXX

#Block a list of specific IP addresses for al incoming connections
iptables -A INPUT -s XXXXX -j DROP

#Block your computer from being PINGED by all other hosts (hint: ping uses ICMP Echo requests)
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP

#Set up port-forwarding from an unused port to port 22 on your computer. (Hint: you need to 
#enable connections on the unused port as well)
sudo iptables -t nat -A PREROUTING -p tcp -d XXXXXX --dport XXX -j DNAT --to-destination XXXXXX:22

#Allow for SSH access (port 22) to your machine from only the engineering.purdue.edu domain
sudo iptables -A INPUT -p tcp --src engineering.purdue.edu --dport 22 -j ACCEPT

#Assuming you are running an HTTPD server on your machine that can make available your
#entire home directory to the outside world, write a rule that allows only a single IP address
#in the internet to access your machine for the HTTP service.
sudo iptables -I INPUT -p tcp -s XXXX --dport 80 -j ACCEPT

#Permit Auth/Ident (port 113) that is used by some services like SMTP and IRC.
