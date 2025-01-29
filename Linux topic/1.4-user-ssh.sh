#!/bin/bash

#copy dir with pub keys to romoute serv
scp -r ~/Test igor@192.33.33.17:~/
#execute our commands on remoute server
ssh igor@192.33.33.17 << 'EOF'
sudo -i
nu() {
for name in $(ls -l /home/igor/Test | awk '/pub/{print $9}' | cut -d_ -f1)
    do 
        sudo useradd -m $name
        sudo mkdir -p /home/$name/.ssh && sudo touch /home/$name/.ssh/authorized_keys
        sudo chmod 755 /home/$name/.ssh/authorized_keys
        cat /home/igor/Test/${name}_key.pub >> /home/$name/.ssh/authorized_keys
        sudo chown -R $name:$name /home/$name/.ssh
    done
}
nu
EOF
