sudo apt update -y
sudo apt install wget openjdk-17-jdk -y

sudo mkdir /app
cd /app

sudo wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz
sudo tar -xvf nexus.tar.gz
sudo mv nexus-3* nexus

sudo adduser --system --no-create-home nexus

sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work

echo 'run_as_user="nexus"' | sudo tee /app/nexus/bin/nexus.rc

sudo tee /etc/systemd/system/nexus.service > /dev/null <<EOL
[Unit]
Description=Nexus Service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload
sudo systemctl enable nexus
sudo systemctl start nexus
sudo systemctl status nexus
