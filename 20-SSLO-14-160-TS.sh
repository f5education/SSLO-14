UCS=sslo1_ts.ucs

# copy archive files from GitHub to bigip1
curl --silent https://raw.githubusercontent.com/f5education/$COURSE_ID/main/$UCS --output /tmp/$UCS
sudo scp /tmp/$UCS 192.168.1.31:/var/local/ucs

# Load UCS into BIGIP01
sudo ssh 192.168.1.31 tmsh load sys ucs $UCS no-license
sleep 15

# confirm bigip1 is active
for i in {1..12}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done
