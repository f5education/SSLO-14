# Wait for BIG-IP to wake up
sleep 90

# confirm bigip1 is active
for i in {1..12}; do [ "$(sudo ssh root@192.168.1.31 cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done

# set bigip preference display lines to 100
sudo ssh 192.168.1.31 tmsh modify cli preference display-threshold 100
sudo ssh 192.168.1.31 tmsh save sys config
