SOURCE=allup fix_whitespace sms battery_check.sh svn_add_unknown.sh jenkins_statusboard update_status.py
PREFIX=~/bin

.PHONY: install

install: $(SOURCE)
	cp $(SOURCE) $(PREFIX)
