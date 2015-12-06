function goenv () {
	gobinary=$(which go)
	if [ -z ${gobinary} ];then
		echo "no go in PATH"
		return
	fi
	GODIR=$(dirname ${gobinary})/../
	export GOROOT=$(readlink -f ${GODIR})
	if [[ ! $PATH =~ $GOROOT/bin ]];then
		export PATH=$GOROOT/bin:$PATH
	fi
	
	export GOPATH=${1:-${PWD}}
	echo "GOROOT is $GOROOT"
	echo "GOPATH is $GOPATH"
}
