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