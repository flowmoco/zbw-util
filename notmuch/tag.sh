#!/bin/bash

# Based on: https://anarc.at/blog/2016-05-12-email-setup/
# symlink into ~/Maildir/.notmuch/hooks/post-new

FOLDER_EXCL="Maildir/(lists.*|drafts.*|Archive.*|archive.*|greyspam.*|sent.*|Sent.*|spam.*|Junk.*|trash.*|Deleted.*|INBOX/)\$"

function foldertag {
  echo $1 | sed 's#/$##;s#^.*/##'
}

echo tagging folders

# Tag all new messages with respective folder but leave in inbox
for folder in $(ls -ad $HOME/Maildir/*/ | egrep -v "$FOLDER_EXCL"); do
  tag=$(foldertag $folder)
  notmuch tag +$tag tag:inbox and not tag:$tag and folder:${PREFIX}$tag
done

# Remove inbox tag for folders to check manually (e.g. spam, etc) and tag with respective folder
for folder in $(ls -ad $HOME/Maildir/*/ | egrep "$FOLDER_EXCL" | egrep -v "Maildir/INBOX/"); do
  tag=$(foldertag $folder)
  notmuch tag +$tag -inbox tag:inbox and not tag:$tag and folder:${PREFIX}$tag
done

# Remove unread from sent items
notmuch tag -unread tag:sent #and not to:bnotes@mube.co.uk

# Notes (from / for self)
#notmuch tag +inbox to:bnotes@mube.co.uk and tag:unread

# Bots
#notmuch tag +bot tag:inbox and from:stcolfs@servers.ekernow.com

# ----

# GGMR

#Basic tagging for Office365 (with name-translations)
notmuch tag -inbox -archive folder:archive
notmuch tag +sent folder:sent


# Add sent tag to GGMR Office365 emails
# https://notmuchmail.org/pipermail/notmuch/2011/003707.html
#	notmuch tag +important folder:important
#Or it might be useful to run on several directories:
#	for dir in *; do notmuch tag +"$dir"; folder:"$dir"; done
#notmuch tag +sent folder:"Sent Items" # NEEDS WORK
# notmuch search folder:Archive
