# confirm bigip1 is active
for i in {1..12}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# confirm bigip2 is active
for i in {1..12}; do [ "$(sudo ssh root@192.168.2.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# set ucs file names
UCS1=sslo1_ha.ucs
UCS2=sslo2_ha.ucs

# copy archive files from GitHub to bigip1
curl --silent https://raw.githubusercontent.com/f5education/$COURSE_ID/main/$UCS1 --output /tmp/$UCS1
sudo scp /tmp/$UCS1 192.168.1.31:/var/local/ucs

# copy archive files from GitHub to bigip2
curl --silent https://raw.githubusercontent.com/f5education/$COURSE_ID/main/$UCS2 --output /tmp/$UCS2
sudo scp /tmp/$UCS2 192.168.1.31:/var/local/ucs

# Load UCS into bigip1
sudo ssh 192.168.1.31 tmsh load sys ucs $UCS1 no-license
#sleep 15

# Load UCS into bigip2
sudo ssh 192.168.2.31 tmsh load sys ucs $UCS2 no-license
#sleep 15

# confirm bigip1 is active
for i in {1..12}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# confirm bigip2 is active
for i in {1..12}; do [ "$(sudo ssh root@192.168.2.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done
