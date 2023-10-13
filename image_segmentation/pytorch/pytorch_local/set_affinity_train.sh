for pid in $(ps -aux | awk '{ print $2 }'); do sudo taskset -acp 12-15 $pid; done
sudo taskset -ac 0-11 cgexec -g memory:mlsys ./launch_container.sh
