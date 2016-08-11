#!/usr/bin/env bash
#
#
#
#
#

CONFIGFILE="./config.cfg"
CURRENTFILE="current"

# length of the random part of the email address
RANDOM_LEN=15

# here are your .qmail files
QMAIL_DIR="${HOME}/"
QMAIL_FILENAME=".qmail-"

function read_config_file() 
{
    if [ -f ${CONFIGFILE} ] 
    then
        source ${CONFIGFILE}
    else
        echo "config file '${CONFIGFILE}' does not exist. "
        exit 1
    fi
}

function create() 
{
    INDEX=$1
    
    random=${random[$INDEX]:0:${RANDOM_LEN}}
    CURRENT_MAIL="${prefix[$INDEX]}-${random}@${host[$INDEX]}"
    CURRENT_FILE="${output_path[$INDEX]}$CURRENTFILE"
    
    if [ "${namespace[$INDEX]}" = "" ]
    then
        QMAIL_FILE="${QMAIL_DIR}${QMAIL_FILENAME}${namespace[$INDEX]}default"
    else
        QMAIL_FILE="${QMAIL_DIR}${QMAIL_FILENAME}${namespace[$INDEX]}-default"
    fi

    # save current email address 
    echo -n ${CURRENT_MAIL} > ${CURRENT_FILE}
    
    # save .qmail file = contains the forwarding email address to the real inbox
    echo -n "&${forwarding[$INDEX]}" > ${QMAIL_FILE}
            
    # user information
    echo -e "\t ${CURRENT_MAIL}" 
    echo -e "\t    --> ${CURRENT_FILE}" 
    echo -e "\t ${QMAIL_FILE}" 
    
    echo    
}

function iterate() 
{
    ARRAY_LEN=${#prefix[*]}

    for (( i=0; i<${ARRAY_LEN}; i++ ));
    do
        create $i
    done   
}


read_config_file
echo -e "created"

if [ $1 ]
then
    create $1
else
    iterate
fi


