UCS=sslo1_policy.ucs
SCF=swg_profile.scf

# copy archive files from GitHub to bigip1
curl --silent https://raw.githubusercontent.com/f5education/$COURSE_ID/main/$UCS --output /tmp/$UCS
sudo scp /tmp/$UCS 192.168.1.31:/var/local/ucs
curl --silent https://raw.githubusercontent.com/f5education/$COURSE_ID/main/$SCF --output /tmp/$SCF
sudo scp /tmp/$SCF 192.168.1.31:/var/local/scf

# Load UCS into BIGIP01
sudo ssh 192.168.1.31 tmsh load sys ucs $UCS no-license

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# provision APM
sudo ssh 192.168.1.31 tmsh modify sys provision apm level minimum

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# merge in swg_profile configs
sudo ssh 192.168.1.31 tmsh load sys config merge file $SCF

# confirm sslo1 is active
for i in {1..30}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# create SWG_Profile
sudo ssh 192.168.1.31 tmsh modify /apm profile access SWG_Profile generation-action increment
sudo ssh 192.168.1.31 tmsh save sys config
#sudo ssh 192.168.1.31 reboot

# confirm bigip1 is active
for i in {1..12}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done
