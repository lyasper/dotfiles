# functions -- sourced by bashrc

# File & String Related Functions

# Find a file with the string $1 in the name
function ff() { find . -name '*'$1'*' ; }

# Find a file with the string $1 in the name and exec $2 on it
function fe() { find . -name '*'$1'*' -exec $2 {} \; ; }

# Find a file ending in $2 and search for string $1 in it
function fstr() # find a string in a set of files
{
  if [ $# -ne 2 ]; then
    echo "Usage: fstr \"pattern\" [files] "
    return;
  fi
  SMSO=$(tput smso)
  RMSO=$(tput rmso)
  find . -type f -name "*${2}" -print | xargs grep -sin "$1" | \
  sed "s/$1/$SMSO$1$RMSO/gI"
}

# Move filenames to lowercase
function lowercase()
{
  for file ; do
    filename=${file##*/}
    case "$filename" in
      */*) dirname==${file%/*} ;;
      *) dirname=.;;
    esac
    nf=$(echo $filename | tr A-Z a-z)
    newname="${dirname}/${nf}"
    if [ "$nf" != "$filename" ]; then
      mv "$file" "$newname"
    else
      echo "lowercase: $file not changed."
    fi
  done
}

# Swap spaces for underscores in file names
function nospace()
{
  mv "$1" "`echo $1 | tr ' ' '_'`"
}


# Swap file $1 with $2
function swap() {
local TMPFILE=tmp.$$
mv $1 $TMPFILE
mv $2 $1
mv $TMPFILE $2
}

# Process/System related functions

# Helper function for pp
function myps() { ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ; }

# Show all processes owned by me
function pp() { myps f | awk '!/awk/ && $0~var' var=${1:-".*"} ; }

# get IP address
function myip()
{
  IP=`ifconfig  | \grep 'inet addr:'| \grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}'`;
  echo $IP
}

# get current host related info
function ii()
{
  echo -e "\nYou are logged on $HOSTNAME"
  echo -e "\nAdditionnal information: " ; uname -a
  echo -e "\nUsers logged on: " ; w -h
  echo -e "\nCurrent date : " ; date
  echo -e "\nMachine stats : " ; uptime
  echo -e "\nMemory stats : " ; free
  myip > /dev/null 2>&1
  echo -e "\nLocal IP Address : " ; echo ${IP:-"Not connected"}
  echo
}

function untar()
{
  FT=$(file -b $1 | awk '{print $1}')
  if [ "$FT" = "bzip2" ]; then
    tar xvjf "$1"
  elif [ "$FT" = "gzip" ]; then
    tar xvzf "$1"
  fi
}

# ssh-copy-id
function cpkey()
{
  cat .ssh/id_rsa.pub | ssh $@ 'cat >> ~/.ssh/authorized_keys2'
}

function pn()
{
  if [ $# -ne 1 ];then
      echo "need 1 parameters"
      return 1
  fi

  OLD_IFS="$IFS"
  IFS=":"
  STRS=( $1 )
  IFS="$OLD_IFS"


  FILENAME=${STRS[0]}
  LNO=${STRS[1]}

  if [ -z $LNO ];then
      STARTLINE=1
      ENDLINE=10
  elif [ $LNO -lt 6 ];then
      STARTLINE=1
      ENDLINE=10
  else
      STARTLINE=`expr $LNO - 5`
      ENDLINE=`expr $LNO + 5`
  fi
  sed = "$FILENAME" | sed 'N;s/\n/ /'  | sed -n "${STARTLINE},${ENDLINE}p"
}

function listduplicate()
{
  find -not -empty -type f -printf "%s\n" | sort -rn | uniq -d | xargs -I{} -n1 find -type f -size {}c -print0 | xargs -0 md5sum | sort | uniq -w32 --all-repeated=separate
}

function encfile()
{
	if [ $# -lt  2 ];then
		echo "usage: cmd file newfile"
	fi
	openssl enc -aes-256-cbc -in  "${1}" -out "${2}" -pass file:"passwd"
	
}

function decfile()
{
	if [ $# -lt  2 ];then
		echo "usage: cmd file newfile"
	fi
	openssl enc -aes-256-cbc -d -in  "${1}" -out "${2}" -pass file:"passwd"
	
}

function pidenv() 
{ 
    xargs -n 1 -0 < /proc/${1:-self}/environ
}
