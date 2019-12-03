#!/bin/bash -
#===============================================================================
#dgaioc v0.1 - Copyright 2019 James Slaughter,
#This file is part of dgaioc v0.1.

#dgaioc v0.1 is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.

#dgaioc v0.1 is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

#You should have received a copy of the GNU General Public License
#along with dgaioc v0.1.  If not, see <http://www.gnu.org/licenses/>.
#===============================================================================
#------------------------------------------------------------------------------
#
# Execute dgaioc on top of an Ubuntu-based Linux distribution.
#
#------------------------------------------------------------------------------

__ScriptVersion="dgaioc-v0.1"
LOGFILE="/home/scalp/dgaioc/dgaioc.log"
FILENAME="Add your filename here"
DAY2=`date --date="" +"%m-%d-%y"`

echoerror() {
    printf "${RC} [x] ${EC}: $@\n" 1>&2;
}

echoinfo() {
    printf "${GC} [*] ${EC}: %s\n" "$@";
}

echowarn() {
    printf "${YC} [-] ${EC}: %s\n" "$@";
}

usage() {
    echo "usage"
    exit 1
}

initialize() {
  echoinfo "--------------------------------------------------------------------------------" >> $LOGFILE
  echoinfo "Running dgaioc.sh version $__ScriptVersion on `date`" >> $LOGFILE
  echoinfo "--------------------------------------------------------------------------------" >> $LOGFILE

  echoinfo "---------------------------------------------------------------"
  echoinfo "Running dgaioc.sh version $__ScriptVersion on `date`"
  echoinfo "---------------------------------------------------------------"
}

download_dgaioc_list() {
  #Pull DGA data from the Netlab OpenData Project dump  
  
  echoinfo "Pulling today's data from the Netlab OpenData Project dump..."
  echoinfo "Pulling today's data from the Netlab OpenData Project dump..." >> $LOGFILE
  echoinfo "URL: http://data.netlab.360.com/feeds/dga/dga.txt"
  echoinfo "URL: http://data.netlab.360.com/feeds/dga/dga.txt" >> $LOGFILE
  
  wget "http://data.netlab.360.com/feeds/dga/dga.txt" -O "/home/scalp/dgaioc/$DAY2.txt" 
  echoinfo "Grepping for Recent additions..."
  echoinfo "Grepping for Recent additions..." >> $LOGFILE  
  grep -E '2019-' "/home/scalp/dgaioc/$DAY2.txt" > "/home/scalp/dgaioc/temp.csv"
  echoinfo "Inserting column header..."
  echoinfo "Inserting column header..." >> $LOGFILE   
  sed -i '1s/^/HostAddress\n/' "/home/scalp/dgaioc/temp.csv"
  echoinfo "Removing unwanted columns..."
  echoinfo "Removing unwanted columns..." >> $LOGFILE 
  cut -d$'\t' -f2  "/home/scalp/dgaioc/temp.csv" > "/home/scalp/dgaioc/$FILENAME"

  ERROR=$?

  echoinfo "Zipping CSV file...password is \"infected\"."
  echoinfo "Zipping CSV file...password is \"infected\"." >> $LOGFILE
  zip -P infected -j  "/home/scalp/dgaioc/DGA$DAY2.zip" "/home/scalp/dgaioc/$FILENAME"
  echoinfo "Removing /home/scalp/dgaioc/$DAY2.txt..."
  echoinfo "Removing /home/scalp/dgaioc/$DAY2.txt..." >> $LOGFILE
  rm "/home/scalp/dgaioc/$DAY2.txt"

  echoinfo "Removing /home/scalp/dgaioc/$FILENAME..."
  echoinfo "Removing /home/scalp/dgaioc/$FILENAME..." >> $LOGFILE
  rm "/home/scalp/dgaioc/CTHA_DGA_Watchlist_Domains.csv"

  echoinfo "File /home/scalp/dgaioc/DGA$DAY2.zip ready to be sent..."
  echoinfo "File /home/scalp/dgaioc/DGA$DAY2.zip..." >> $LOGFILE

  echoinfo "Details logged to $LOGFILE."

  if [ $ERROR -ne 0 ]; then
    return 1
  fi

  return 0
}

wrap_up() {
  echoinfo "--------------------------------------------------------------------------------" >> $LOGFILE
  echoinfo "Program complete on `date`" >> $LOGFILE
  echoinfo "--------------------------------------------------------------------------------" >> $LOGFILE

  echoinfo "---------------------------------------------------------------"
  echoinfo "Program complete on `date`"
  echoinfo "---------------------------------------------------------------"
}

#Function calls
initialize
download_dgaioc_list
wrap_up
