#!/bin/bash

source logininfo.bash

#Use
#   Uploads zipped brain images-PET and MRI- to respective folders in
#   NACC
#
#
#ENVIRONMENTAL VARIABLES
#   USERNAME    => is the UF username used to connect to intermediate server
#   PASSWORD    => is the credentials needed to connect to intermediate server and 
#                  other UF servers
#   SERVERADDY  => is the IP address used to connect directly to NACC
#   SERVERPW    => the key needed to sftp into the NACC
#   IMAGESOURCE => the local directory containing all PET and MRI
#                  zipped files (after running polyjuice)
#   INTSOURCE => the server whose IP address is accepted by NACC standards
#

FILENAME=$(basename "$IMAGESOURCE")

cleanup()
{
    [ $1 == 0 ] && return
    echo 'An error has caused the program to exit'
    expect << EOS 
    spawn ssh $USERNAME@$INTSOURCE 
    expect "$USERNAME@$INTSOURCE's password:"
    send "$PASSWORD\n"
    expect "$USERNAME@tools2:/tmp/$FILENAME/APET$"
    send "cd /tmp/\n"
    expect "$USERNAME@tools2:/tmp$"
    send "rm -r $FILENAME\n"
    expect "$USERNAME@tools2:/tmp/$FILENAME$"
    send "exit\n"

EOS
}

set -e 
trap 'cleanup $?' EXIT 
echo $FILENAME
scp -r $IMAGESOURCE $USERNAME@$INTSOURCE:/tmp/ 

expect <<EOS 
spawn ssh $USERNAME@$INTSOURCE 
expect "$USERNAME@$INTSOURCE's password:"
send "$PASSWORD\n"

expect "$USERNAME@tools2:~$"
send "cd /tmp/$FILENAME/APET\n"

send "sftp $SERVERADDY\n"
expect "Password:"
send "$SERVERPW\n"

expect "sftp>"
send "cd APET\n"

expect "sftp>"
send "put *.zip\n"

expect "sftp>"
send "cd ../MRI\n"

expect "sftp>"
send "lcd ../MRI\n"

expect "sftp>"
send "put *.zip\n"

expect "sftp>"
send "bye\n"

expect "$USERNAME@tools2:/tmp/$FILENAME/APET$"
send "cd /tmp/\n"

expect "$USERNAME@tools2:/tmp$"
send "rm -r $FILENAME\n"

expect "$USERNAME@tools2:/tmp/$FILENAME$"
send "exit\n"

EOS
 
 echo "Intermediate Server cleaned and good to go"

exit