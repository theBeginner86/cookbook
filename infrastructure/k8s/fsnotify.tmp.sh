# fixes failed to create fsnotify watcher: inotify_init failed: No space left on device

# check for limits
cat /proc/sys/fs/inotify/max_user_watches
cat /proc/sys/fs/inotify/max_user_instances

# increase limits
sudo sysctl -w fs.inotify.max_user_watches= 8192 #(default for kURL)
sudo sysctl -w fs.inotify.max_user_watches= 65536 #(default for kURL)