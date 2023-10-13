grep batch_preproc $1 | awk '{print $12}' > $2
sed -i 's/},//g' $2
awk '{sum+=$1} END {print sum}' $2
