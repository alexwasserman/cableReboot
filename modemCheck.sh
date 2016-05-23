#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset

reps=3
total=0
speed=0

log() {  # classic logger 
   local prefix
   prefix="[$(date +%Y/%m/%d\ %H:%M:%S)]: "
   echo "${prefix} $*" >&2
}

speedTest() {
	size=$1
	speed=$(wget http://testmy.net/dl-${size}MB --delete-after --report-speed=bits -O /tmp/speedcheck.$$ 2>&1 | grep '[KM]b' | sed 's/^.*(//;s/).*//')
		
	units=$(echo "${speed}" | awk '{print $2}')
	speed=$(echo "${speed}" | awk '{print $1}' | awk -F. '{print $1}')
		
	if [ -z "${speed}" ];
	then
		speed=0
	fi
		
	if [[ "${units}" == "Kb/s" ]];
	then
		speed=$((speed/1024))
	fi
	
	echo ${speed}
}


for (( n=1; n<=reps; n++ ))
do
	log "INFO" "Starting run: $n"

	if [[ $n == 1 ]];
		then
			size=3
	else
		size=${total}+1
	fi
	
	speed=$(speedTest ${size})
		
	total=$((total + speed))
	log "INFO" "Run ${n} : ${speed}"
	
	if [[ ${n} -lt ${reps} ]];
			then
				sleep 10
	fi
done

average=$(( total/reps ))
log "INFO" "Average : ${average}"

if [[ ${average} -lt 20 ]];
	then
		log "INFO" "Running one last check"
		speed=$(speedTest 5)
		log "INFO" "Final : ${speed}"
		
		if [[ ${speed} -lt 15 ]];
			then
				log "INFO" "Restarting modem"
				wget --post-data="Rebooting=1" -q -O - http://192.168.100.1/goform/RgConfiguration.pl > /dev/null 2>&1 
				log "INFO" "Done"
		fi
fi

temp_files=(/tmp/speedcheck.*)
if [ -e "${temp_files[0]}" ];
	then
	rm /tmp/speedcheck.*
fi

exit
