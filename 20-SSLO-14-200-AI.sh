# confirm bigip1 is active
for i in {1..12}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

UCS=sslo1_ai.ucs
SCF=sslo1_ai_cats.scf
CSV=local_user_db.csv

# copy files from GitHub
#curl --silent https://raw.githubusercontent.com/f5education/$COURSE_ID/main/$UCS --output /tmp/$UCS
curl --silent https://raw.githubusercontent.com/f5education/$COURSE_ID/main/$SCF --output /tmp/$SCF
curl --silent https://raw.githubusercontent.com/f5education/$COURSE_ID/main/$CSV --output /home/student/Downloads/$CSV

# copy files to bigip1
#sudo scp /tmp/$UCS 192.168.1.31:/var/local/ucs
sudo scp /tmp/$SCF 192.168.1.31:/var/local/scf

# Load UCS into BIGIP01
#sudo ssh 192.168.1.31 tmsh load sys ucs $UCS no-license
#sleep 30

# confirm bigip1 is active
#for i in {1..12}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# provision APM
sudo ssh 192.168.1.31 tmsh modify sys provision apm level minimum
sleep 45

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# merge in swg_profile configs
sudo ssh 192.168.1.31 tmsh load sys config merge file $scf
sudo ssh 192.168.1.31 tmsh save sys config

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# create SWG_Profile
#sudo ssh 192.168.1.31 tmsh modify /apm profile access SWG_Profile generation-action increment
#sudo ssh 192.168.1.31 tmsh save sys config
#sudo ssh 192.168.1.31 reboot

# confirm bigip1 is active
#for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done
