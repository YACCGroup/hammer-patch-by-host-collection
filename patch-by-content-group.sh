#!/usr/bin/env bash

usage() { echo "$0 usage:" && grep " .)\ #" $0; exit 0; }
[ $# -eq 0 ] && usage

# Set default org id
ORG='MyOrg'

while getopts "o:c:" arg; do
    case "${arg}" in
        o) # Specifiy org id:  hammer organizaion list
           ORG=${OPTARG}
           ;;
        c) # Required: Specify host collection name: hammer host-collection list
           HOST_COLLECTION_NAME=${OPTARG}
           ;;
        *) # Display help.
           usage
    esac
done
echo  $HOST_COLLECTION_NAME
if [ -z $HOST_COLLECTION_NAME ];then
 usage
fi

hammer --csv host-collection hosts --name $HOST_COLLECTION_NAME --organization $ORG |grep -v '^ID' |cut -f2 -d, |while read HOST
do
  echo "retrieving $HOST errata"
  hammer --csv host errata list --host $HOST |grep -v '^ID' |cut -f2 -d, |while read ERRATA
  do
   #echo "applying errata:$ERRATA"
   hammer host errata apply --host $HOST --errata-ids $ERRATA
   #echo "hammer host errata apply --host $HOST --errata-ids $ERRATA"
  done
done

