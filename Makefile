SOURCE=allup fix_whitespace sms battery_check.sh svn_add_unknown.sh jenkins_statusboard update_status.py get_export_list.sh
PREFIX=~/bin

.PHONY: install

install: $(SOURCE)
	cp $(SOURCE) $(PREFIX)
