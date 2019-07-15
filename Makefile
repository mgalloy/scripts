SOURCE=allup \
bibtex2yaml.rb \
cafe_winner.py \
check_export.sh \
check_speed.py \
check_speed.sh \
clean_openwith_db.sh \
cls \
driving.py \
driving.sh \
dropbox.py \
events2ics \
fitscat \
fix_whitespace \
get_app_sales.py \
get_app_sales.sh \
imgcat \
init_anaconda.sh \
jenkins_statusboard \
make_download \
makeappicons.sh \
menu.py \
moves.py \
moves.sh \
moves_refreshtoken.py \
nb2md \
sms \
svn_add_unknown.sh \
textbelt \
update_book_sales.py \
update_software.sh \
update_status.py \
watchdir \
wp.py \
wp.sh

DARWIN_SOURCE=backedup.sh \
battery_check.sh \
getudid.sh \
hex \
reindex_mailapp.sh \
video2huffduffer


PREFIX=$(HOME)/bin

.PHONY: all install

all:
	@echo "Nothing to do, use install target to install scripts"

install: $(SOURCE)
	@echo "Installing scripts to $(PREFIX)..."
	cp $(SOURCE) $(PREFIX)
	if [ `uname` == 'Darwin' ]; then cp $(DARWIN_SOURCE) $(PREFIX); fi
