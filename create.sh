#!/usr/bin/env bash
#
# Creates temporary email addresses for your **uberspace** qmail system. They can be included dynamically (e.g. with PHP) and you can use them for instance for your imprint. So there is only a low risk that you receive spam mails through these email addresses. 
# 
# https://github.com/089/tmp-qmail-uberspace
# http://www.gnu.org/licenses/gpl-3.0.html, http://www.gnu.de/documents/gpl.de.html

CONFIGFILE="./config.cfg"
CURRENTFILE="current_mail"
HTACCESSFILE=".htaccess"

# length of the random part of the email address
RANDOM_LEN=15

# here are your .qmail files
QMAIL_DIR="${HOME}/"
QMAIL_FILENAME=".qmail"

# settings for backup copy
TIMESTAMP=`date +%Y-%m-%d-%H-%M-%S`
BACKUP_EXT="backup"

function backup_copy()
{
    FILE=$1
    BACKUP_FILE="${FILE}.${TIMESTAMP}.${BACKUP_EXT}"
    
    if [ -a ${FILE} ]
    then
        echo "* backed ${FILE} to ${BACKUP_FILE}"
        cp ${FILE} ${BACKUP_FILE}
    
    fi
}

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

    # prevent empty prefixes
    if [ -z "${prefix[$INDEX]}" -o "${prefix[$INDEX]}" = "" ]
    then
        echo "Prefix with index ${INDEX} must not be empty! --> Exit."
        exit 1
    fi
    
    echo -e "created"    
    
    # file names
    random=${random[$INDEX]:0:${RANDOM_LEN}}
    CURRENT_MAIL="${prefix[$INDEX]}-${random}@${host[$INDEX]}"
    CURRENT_FILE="${output_path[$INDEX]}$CURRENTFILE"
    
    if [ "${namespace[$INDEX]}" = "" ]
    then
        QMAIL_FILE="${QMAIL_DIR}${QMAIL_FILENAME}-${namespace[$INDEX]}${prefix[$INDEX]}-default"
    else
        QMAIL_FILE="${QMAIL_DIR}${QMAIL_FILENAME}-${namespace[$INDEX]}-${prefix[$INDEX]}-default"
    fi
    
    # web server part
    mkdir -p ${output_path[$INDEX]}
    echo -n "Redirect 307 /mailto mailto:${CURRENT_MAIL}" > "${output_path[$INDEX]}${HTACCESSFILE}"
    echo -n "<a href=\"mailto:${CURRENT_MAIL}\">${CURRENT_MAIL}</a>" > "${CURRENT_FILE}.html"
    echo -n "${CURRENT_MAIL}" > "${CURRENT_FILE}.txt"
    #echo -n ${CURRENT_MAIL} | convert text:- "${CURRENT_FILE}.gif"
    
    # save .qmail file ==> contains the forwarding email address to the real inbox
    backup_copy ${QMAIL_FILE}
    echo -n "&${forwarding[$INDEX]}" > ${QMAIL_FILE}
            
    # user information
    echo -e "* ${CURRENT_MAIL}" 
    echo -e "   --> ${CURRENT_FILE}" 
    echo -e "* ${QMAIL_FILE}" 
    
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

if [ $1 ]
then
    create $1
else
    iterate
fi


