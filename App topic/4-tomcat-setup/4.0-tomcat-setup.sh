#!/bin/bash

LOG_FILE="/var/log/tomcat-install.log"
TC_HOME="/usr/local"
# Run as sudo only
if [[ "${UID}" -ne 0 ]]
then
    tput setaf 3; echo "Please enter like sudo user!"; tput sgr0
    exit 1
else
    echo "$(date) - run tomcat installation script!"
fi

sudo apt update 
sudo apt install -y default-jdk >> $LOG_FILE

tar -xvf ./apache-tomcat-9.0.58 -C $TC_HOME >> $LOG_FILE

mv $TC_HOME/apache-tomcat-9.0.58 $TC_HOME/tomcat9 

useradd -r tomcat

chown -R tomcat:tomcat $TC_HOME/tomcat9
sed -i 's/0:0:0:0:0:0:0:1/0:0:0:0:0:0:0:1 |.*/' $TC_HOME/tomcat9/webapps/host-manager/META-INF/context.xml
sed -i 's/0:0:0:0:0:0:0:1/0:0:0:0:0:0:0:1 |.*/' $TC_HOME/tomcat9/webapps/manager/META-INF/context.xml

#keytool -genkey -alias tomcat -keyalg RSA -keystore /etc/pki/keystore
cp server.xml $TC_HOME/tomcat9/conf/server.xml
cp tomcat-users.xml $TC_HOME/tomcat9/conf/tomcat-users.xml 

touch /etc/systemd/system/tomcat.service 
cat >> /etc/systemd/system/tomcat.service <<EOF
[Unit]
Description=Apache Tomcat
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat

Environment=CATALINA_PID=$TC_HOME/tomcat9/temp/tomcat.pid
Environment=CATALINA_HOME=$TC_HOME/tomcat9
Environment=CATALINA_BASE=$TC_HOME/tomcat9

ExecStart=$TC_HOME/tomcat9/bin/catalina.sh start
ExecStop=$TC_HOME/tomcat9/bin/catalina.sh stop

RestartSec=12
Restart=always
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl start tomcat.service
systemctl enable tomcat.service
systemctl status tomcat.service