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

# Remove WGET lines from the target file
sed -e "/WGET/d" -i ${TARGET}

while read line; do
	echo ${line}
		line=($line)
		url=${line[1]}
		filename=$(echo ${url} | rev | cut -d/ -f1 | rev)
		curl -sSL ${url} > ${TARGETDIR}/${filename}
		chmod +x ${TARGETDIR}/${filename}
done < <(grep "WGET" ${SOURCE})

### CLEANUP
sed '/#/d;/^$/d;\@\t\\@d;' -i ${TARGET}
rm ${TARGETDIR}/Dockerfile.tmp
### /CLEANUP
