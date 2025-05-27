#To persist the new limit across reboots, add the following line to /etc/sysctl.conf:
echo 'fs.inotify.max_user_instances = 8192' | sudo tee -a /etc/sysctl.conf
echo 'fs.inotify.max_user_watches = 65536' | sudo tee -a /etc/sysctl.conf

#Then apply the change with:
sudo sysctl -p