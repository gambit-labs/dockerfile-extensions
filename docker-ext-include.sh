#!/bin/bash

### INIT
if [[ $# != 2 ]]; then
	cat <<-EOF
	Usage: $0 [template dockerfile] [output dockerfile]
	EOF
fi

SOURCE=$1
TARGET=$2
TARGETDIR=$(dirname $TARGET)

cp ${SOURCE} ${TARGET}
### /INIT

while read line; do
		linearr=($line)
		url=${linearr[1]}
		echo "INCLUDE ${url}"
		curl -sSL ${url} | sed -e "/FROM/d;/MAINTAINER/d;/EXPOSE/d;/VOLUME/d;/WORKDIR/d;/CMD/d;/ENTRYPOINT/d;" > ${TARGETDIR}/Dockerfile.tmp
		cd ${TARGETDIR} && sed -e "\%${line}% {" -e 'r Dockerfile.tmp' -e 'd' -e '}' -i ${TARGET}
done < <(grep "INCLUDE" ${SOURCE})

### CLEANUP
sed '/#/d;/^$/d;\@\t\\@d;' -i ${TARGET}
rm ${TARGETDIR}/Dockerfile.tmp
### /CLEANUP
