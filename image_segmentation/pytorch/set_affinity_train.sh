# for pid in $(ps -aux | awk '{ print $2 }'); do sudo taskset -acp 40-80 $pid; done
for round in {1..5}
do
	sudo sysctl vm.drop_caches=3
	for pid in $(ps -aux | awk '{ print $2 }'); do sudo taskset -acp 40-80 $pid; done
	sudo taskset -ac 0-39 cgexec -g memory:mlsys ./launch_container.sh 19 $round
	sleep 120
	#echo 120
done

