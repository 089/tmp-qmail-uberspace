# tmp-qmail-uberspace
Creates temporary email addresses for your **uberspace** qmail system. They can be included dynamically (e.g. with PHP) and you can use them for instance for your imprint. So there is only a low risk that you receive spam mails through these email addresses. 

## install
1. Go to your home directory e.g. using `cd` or any subdirectory.
1. Clone the git repository `git clone https://github.com/089/tmp-qmail-uberspace.git`.
1. Edit `config.cfg` which contains three examples. 
	1. `i` must be integer. Start with 0 and use single steps for incrementation. 
	1. `prefix[i]` must **not** be **empty**.
	1. `random[i]` must contain **non guessable** random values. You can use `pwgen` or `${RANDOM}` as it is shown in the examples. 
	1. `host[i]` represents the part of an email address after "@".
	1. `namespace[i]` must match with the corresponding namespaces, see "Namensräume" at https://wiki.uberspace.de/domain:mail .
	1. `forwarding[i]` must contain a valid email address. 
	1. `output_path[i]` **must** end with "/"! It should show on a web server directory. 
1. Execute the script using `./create.sh`
1. Switch to your main web server directory `cd /var/www/virtual/petra`. Create symbolic links to get subdomains. According to the examples we need 
	1. `ln -s html/tmp-qmail-uberspace/mail.example.com tmp-qmail.mail.example.com`
	1. `ln -s html/tmp-qmail-uberspace/other.com tmp-qmail.other.com`
	1. `ln -s html/tmp-qmail-uberspace/petra.xeon.uberspace.de tmp-qmail.petra.xeon.uberspace.de`
1. Among other files the script creates `.htaccess`, `current_mail.html` and `current_mail.txt` at the given path on your web server. 
	1. Subdomains and `.htaccess` together let get you URLs like `tmp-qmail.mail.example.com` which redirect to the temporary email address. Mostly it opens the users email client. 
	1. `current_mail.html` contains a HTML-formatted email address link. Remove it, if you do not need it. 
	1. `current_mail.txt` contains the temporary email address as plaintext. You can use it in your server scripts e.g. `<?php include("current_mail.txt"); ?>`

# usage
1. `./create.sh` creates all configured email addresses.
1. `./create.sh 3` creates only the configured email address with index 3. 
1. Using runwhen (https://wiki.uberspace.de/system:runwhen) you can regulary create new temporary email addresses. 


