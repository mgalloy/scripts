SOURCE=allup \
battery_check.sh \
bibtex2yaml.rb \
check_export.sh \
driving.py \
driving.sh \
dropbox.py \
fix_whitespace \
getudid.sh \
hex \
jenkins_statusboard \
makeappicons.sh \
moves.py \
moves.sh \
moves_refreshtoken.py \
reindex_mailapp.sh \
sms \
svn_add_unknown.sh \
update_book_sales.py \
update_software.sh \
update_status.py \
video2huffduffer \
wp.py \
wp.sh

PREFIX=$(HOME)/bin

.PHONY: all install

all:
	@echo "Nothing to do, use install target to install scripts"

install: $(SOURCE)
	@echo "Installing scripts to $(PREFIX)..."
	cp $(SOURCE) $(PREFIX)
