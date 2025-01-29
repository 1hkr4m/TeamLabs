#[Zookeeper check]
ansible -i inventory/localtest/hosts -m raw -a 'systemctl status zookeeper.service'

sudo systemctl stop vertx
sudo systemctl stop tomcat
sudo systemctl stop solr
sudo systemctl stop zookeeper

sudo systemctl start vertx
sudo systemctl start tomcat
sudo systemctl start solr
sudo systemctl start zookeeper

sudo systemctl status vertx
sudo systemctl status tomcat
sudo systemctl status solr
sudo systemctl status zookeeper