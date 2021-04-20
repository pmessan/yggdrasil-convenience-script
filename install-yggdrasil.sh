#!/bin/bash

################################################################
#
#   Yggdrasil installation script - compiled by Peter-Newman Messan
#   Please run as root: sudo ./install-yggdrasil.sh
#
################################################################

apt-get install dirmngr gnupg

# if key doesn't exist add it
gpg --fetch-keys https://neilalexander.s3.dualstack.eu-west-2.amazonaws.com/deb/key.txt
gpg --export 569130E8CA20FBC4CB3FDE555898470A764B32C9 | apt-key add -


echo 'deb http://neilalexander.s3.dualstack.eu-west-2.amazonaws.com/deb/ debian yggdrasil' | tee /etc/apt/sources.list.d/yggdrasil.list
apt-get update

apt-get install -y yggdrasil

systemctl start yggdrasil

systemctl enable yggdrasil

# add peers
yggdrasilctl addpeer uri=tcp://45.11.19.26:5001
yggdrasilctl addpeer uri=tcp://82.165.69.111:61216
yggdrasilctl addpeer uri=tcp://51.15.118.10:62486

# output ip after setup

yggdrasilctl getself | grep address | xargs


# store ygg:ipv6:addr + hostname-ygg in /etc/hosts
echo "$(yggdrasil -address -useconffile /etc/yggdrasil.conf) $(echo $HOSTNAME | awk '{split($0,a,"."); print a[1]}')-ygg" >> /etc/hosts

echo -e "Yggdrasil ipv6 address stored with hostname $(echo $HOSTNAME | awk '{split($0,a,"."); print a[1]}')-ygg in /etc/hosts. You can change this should you wish.\n\nSetup complete!"