sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf

sudo sh -c 'rm /etc/resolv.conf && ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf'

systemctl restart systemd-resolved


### Aditional network configs
# https://github.com/pi-hole/docker-pi-hole/issues/135#issuecomment-881093822

docker network inspect
docker network inspect pihole_default

sudo ip6tables -t nat -A PREROUTING -p tcp --dport 53 -m addrtype --dst-type LOCAL -j DNAT --to-destination <ipv6-pihole>

sudo ip6tables -t nat -A PREROUTING -p udp --dport 53 -m addrtype --dst-type LOCAL -j DNAT --to-destination <ipv6-pihole>

sudo iptables -t nat -A PREROUTING -p tcp --dport 53 -m addrtype --dst-type LOCAL -j DOCKER

sudo iptables -t nat -A PREROUTING -p udp --dport 53 -m addrtype --dst-type LOCAL -j DOCKER


sudo iptables -t nat -A PREROUTING -p udp --dport 53 -m addrtype --dst-type LOCAL -j DOCKER --src-range 

### Better network config to prevent loops if i want to use other docker containers on the device 
# https://dxpetti.com/blog/2019/using-iptables-to-force-all-dns-queries-to-a-pi-hole/

iptables -t nat -A PREROUTING -i br0 -p udp ! --source piholeaddress ! --destination piholeaddress --dport 53 -j DNAT --to piholeaddress
 
iptables -t nat -A PREROUTING -i br0 -p tcp ! --source piholeaddress ! --destination piholeaddress --dport 53 -j DNAT --to piholeaddress

# How to delete the previous rules?
# Show the rule mumbers
sudo iptables --list -vn --line-numbers
# Or better use this as this actually shows you the preprouting chain!
sudo iptables -t nat -L --line-numbers
# Delete the rules from the PREROUTING Chain in nat
iptables -t nat --delete PREROUTING 1

## Actually working Rules :
## These will allow other docker containers to still have DNS resolution!
iptables -t nat -A PREROUTING -p udp --dport 53 -m addrtype --dst-type LOCAL ! --source 192.168.178.66  -j DOCKER
iptables -t nat -A PREROUTING -p tcp --dport 53 -m addrtype --dst-type LOCAL ! --source 192.168.178.66  -j DOCKER

## Everything below was just for experimenting!


iptables -t nat -A PREROUTING -p udp ! --source 192.168.178.66 ! --destination 192.168.178.66 --dport 53 -j DNAT --to 192.168.178.66

iptables -t nat -A PREROUTING -i br0 -p udp ! --source 172.0.0.0/8 ! --destination 172.0.0.0/8 --dport 53 -j DNAT --to 172.18.0.2

iptables -t nat -A PREROUTING -i br0 -p udp ! --source 192.168.178.66 ! --destination 192.168.178.66 --dport 53 -j DOCKER --to 172.18.0.2
 
iptables -t nat -A PREROUTING -i br0 -p tcp ! --source piholeaddress ! --destination piholeaddress --dport 53 -j DNAT --to piholeaddress

iptables -t nat -A PREROUTING -p udp --dport 53 -m addrtype --dst-type LOCAL -j DOCKER
iptables -t nat -A PREROUTING -p udp ! --source 192.168.178.66 ! --destination 192.168.178.66 --dport 53 -j DOCKER
iptables -t nat -A PREROUTING -i eno1 -p udp ! --source 172.0.0.0/8 ! --destination 172.0.0.0/8 --dport 53 -j DOCKER

iptables -t nat -A PREROUTING -i eno1 -p udp --source 192.168.178.66 --destination 192.168.178.66 --dport 53 -j DOCKER

iptables -t nat -A PREROUTING -i eno1 -p udp --source 192.168.178.66 --destination 172.21.0.0/24 --dport 53 -j DNAT --to 172.21.0.1



