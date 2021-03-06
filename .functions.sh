# open the file with vim at the bottom of the file
vimend () {
    vim '+normal Go' $1
}

mkcd () {
  mkdir "$1"
  cd "$1"
}

debugnode () {
	if [ -z "$1" ] ; then
		echo 'usage: debugnode <path to node file>'
		return
	fi
    node --inspect-brk=9229 "$1" 28688 1
}

# requires ghostscript
# usage: compresspdf <pdf filename>
function compresspdf() {
	if [ -z "$1" ] ; then
	        echo 'Usage: compresspdf <pdf filename>'
        	return
   	fi
	ghostscript -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile="small $1" "$1"
}

# requires: ffmpg, youtube-dl
# with zsh, you need to manually put quotes around the URL
# Usage: youtubemp3 "<url>"
function youtubemp3() {
	if [ -z "$1" ] ; then
		echo 'Usage: youtubemp3 <url>'
		return
	fi
	youtube-dl --extract-audio --prefer-ffmpeg --audio-format mp3 -o "%(title)s.%(ext)s" "$1"
}

# usage: resetmongo <backupdb> <maindb>
function resetmongo() {
    if [ -z "$1" ] || [  -z "$2" ] ; then
        echo 'Usage: resetmongo <backupdb> <maindb>'
        return
    fi
    
    backupdb="$1"
    maindb="$2"

    mongo "$maindb" --eval "db.dropDatabase()"
    mongo "$backupdb" --eval "db.copyDatabase(\"$backupdb\", \"$maindb\")"
}

# shortcuts for ubuntu installation
# the install command already exists
function inst() {
	"sudo apt-get install $1"
}
function remv() {
	"sudo apt-get remove $1"
}

function op() {
	PROGRAM=$1
	WINID=$(wmctrl -lx | grep -i $PROGRAM | awk 'NR==1{print $1}')

	if [ $WINID ]; then
	    wmctrl -ia $WINID &
	 #  exit 0  
	else
	    $PROGRAM &
	 #  exit 0 
	fi
}

function lazygit() {
	git add -u
	git commit -m $1
	git pull
	git push
}

function lazyconfig() {
	config add -u
	config commit -m $1
	config pull
	config push
}

function diffdir() {
	diff -r $1 $2 | grep $1 | awk '{print $4}'
}


# asdf/fileName.ext => fileName
function getURLFileName() {
	fullfile="$1"
	filename=$(basename "$fullfile")
	echo "${filename%.*}"
}

# git sparse checkout
function sparse-checkout() {
	if [ -z "$1" ] ; then
		echo 'Usage: sparse-checkout <url>' 
		return
	fi
	
	# I have no clue how to reuse code and 
	giturl="$1"
	filename=$(basename "$giturl")
	filename="${filename%.*}"

	mkdir $filename
	cd $filename
	git init
	git remote add -f origin $giturl
	git config core.sparseCheckout true

	echo "\n"
	echo "Add the directories you wish to pull\n"
	echo '    echo "some/dir/" >> .git/info/sparse-checkout\n'
	echo "\n"
	echo 'When you are done, pull\n'
	echo '    git pull origin master\n'
}

# mp4slice fileName 00:00:00(startTime) 00:00:00(elapsedTime)
function mp4slice() {
	ffmpeg -ss "$2" -i "$1" -t "$3" -vcodec copy -acodec copy "$1-slice".mp4
}

function compressmp4() {
	ffmpeg -i "$1" -acodec mp2 "$1.min.mp4"
}

function compressallmp4() {
	for file in "$PWD"/*; do
		ffmpeg -i "$file" -acodec mp2 "${file/.mp4/s.mp4}"
	done
}
function md2word() {
	if [ -z "$1" ] ; then
		echo 'Usage: md2word src dest' 
		return
	fi
	pandoc -o "$2" -f markdown -t docx "$1"
}

function shrinkimage() {
	if [ -z "$1" ] ; then
		echo 'Usage: shrinkimage src dest size' 
		return
	fi
	convert "$1" -resize x"$3" "$2"
}

function restoredb() {
	if [ -z "$1" ] ; then
		echo 'Usage: restoredb <db name>' 
		return
	fi
    mongo "$1" --eval "db.dropDatabase()";
    mongo --eval "db.copyDatabase('$1-cp', '$1')";
}

function cdg() {
	TEMP_PWD=$(pwd)
	while ! [ -d .git ]; do
		cd ..
	done
	OLDPWD=$TEMP_PWD
}

function t() {
	# Defaults to 3 levels deep, do more with `t 5` or `t 1`
  	# pass additional args after
	tree -I '.git|node_modules|.DS_Store' --dirsfirst -L ${1:-3} -aC $2
}

function notify() {
	if [ -z "$1" ] ; then
		echo 'Usage: notify <message> time' 
		return
	fi
	echo 'notify-send "$1"' | at $2
}

killport(){
    if [ $# -eq 0 ]; then
        echo "No arguments provided"
        echo "provide port of service you wish to kill"
        exit 1
    fi
    fuser -k $1/tcp
}

