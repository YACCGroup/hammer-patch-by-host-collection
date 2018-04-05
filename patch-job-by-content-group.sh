#!/usr/bin/env bash
usage() { echo "$0 usage:" && grep " .)\ #" $0; exit 0; }
[ $# -eq 0 ] && usage

# Set default org id
ORG='MyOrg'
CMD='yum update-minimal --security -y'

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

for ID in `hammer host-collection list --name $HOST_COLLECTION_NAME | grep $HOST_COLLECTION_NAME | cut -f1 -d,`
do
 hammer job-invocation create --job-template-id 94 --async --inputs command="${CMD}" --search-query "host_collection_id = ${ID}"
done
