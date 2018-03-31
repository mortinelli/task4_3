#! /bin/bash

re='^[0-9]+$'
if [ "$#" -ne 2 ]; then
     echo "Illegal number of parameters." 1>&2
    exit 1	
elif ! [ -d "$1" ] && ! [ -f "$1" ]; then
     echo "directory not found" 1>&2
    exit 1
elif ! [[ $2 =~ $re ]] || [ $2 -le 0 ]; then
    echo "Num of count backup is not digit or it is 0 or less." 1>&2
    exit 1
   else 
	echo start backup

	if ! [ -d /tmp/backups/ ] ; then
	mkdir /tmp/backups/
	fi

	archname=$(echo $1 | sed -r 's/\//-/g' | cut -c 2-)
	datetime=`date +%Y-%m-%d--%H%M%S`
	echo $archname
	tar -zcf /tmp/backups/"$archname""$datetime".tar.gz "$1"
	archcount=$(ls -1 /tmp/backups/ | grep "$archname" | grep -v "$archname"- | grep -c "$archname")

		if [ $archcount -gt $2 ] ; then
		let head="$archcount-$2"
		ls -1 -d /tmp/backups/* | grep "$archname" | grep -v "$archname"- | head -$head | xargs -d '\n' rm
		fi

  fi

