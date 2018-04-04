#!/usr/bin/env bash
usage() { echo "$0 usage:" && grep " .)\ #" $0; exit 0; }
[ $# -eq 0 ] && usage

# Set default org id
ORG='MyOrg'
CSV_ERRATA=''

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

for HOST in `hammer --csv host-collection hosts --name $HOST_COLLECTION_NAME --organization $ORG |grep -v '^ID' |cut -f2 -d,`
do
  echo "retrieving $HOST errata"
  for ERRATA in `hammer --csv host errata list --host $HOST |grep -v '^ID' |cut -f2 -d,`
  do
   # Build CSV list of errata to apply
    CSV_ERRATA+="$ERRATA,"
  done
  # Submit job to apply errata
  hammer host errata apply --host $HOST --errata-ids "${CSV_ERRATA%?}"
done

