#!/bin/sh
DIR="/home/wwwadmin/sendmail"

if [ ! -f ${DIR}/email_numbers ]; then
    echo "0" > ${DIR}/email_numbers
fi

emailNumbers=`cat ${DIR}/email_numbers`
emailNumbers=$(($emailNumbers + 1))
echo $emailNumbers > ${DIR}/email_numbers

name="$DIR/letter_$emailNumbers.eml"

while IFS= read line; do
    echo "$line" >> $name
done

/bin/true
