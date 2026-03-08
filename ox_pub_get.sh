#!/usr/bin/env bash
#Main Project directory
mainPath=$(pwd)
mainProjectName=${mainPath##*/}

#Submodule directory
oxchatCorePath=${mainPath}/packages/0xchat-core
nostrDartPath=${mainPath}/packages/nostr-dart
webrtcPath=${mainPath}/packages/flutter-webrtc
cashuPath=${mainPath}/packages/cashu-dart


#Exception
check(){
  if [[ ! $? -eq 0 ]]
  then
    echo "\033[31merror: An error occurred when ${submoduleName##*/} module $1，please check the above error message\033[0m"
    exit 1
  fi
}


#checkout branch
checkoutBranch(){
    submoduleName=$1
    echo "--------------------------- Module Name：${submoduleName##*/} ---------------------------"

    cd $1

    git fetch

    if [[ ! -n $2 ]]
    then
	    git checkout main
    else
	    git checkout $2
    fi

    check "checkout branch"

    git pull

    check "git pull"

    #git log -5
}


checkoutBranchByAll(){
    checkoutBranch ${mainPath} $1
    checkoutBranch ${oxchatCorePath}
    checkoutBranch ${nostrDartPath}
    checkoutBranch ${webrtcPath}
    checkoutBranch ${cashuPath}
}


#Execute 'flutter pub get'
executePubGet(){
    cd $1
    for file in $(ls "$1")
    do
      path=$1"/"${file}
      if [[ -d ${path} ]]
      then
      	  echo "---------------------------$file---------------------------"
          cd $path
          flutter pub get
#           flutter clean
      fi
    done
}


usage() {
    echo "Usage:"
    echo "ox_pub_get.sh [-m Main Project Branch Name]"
    exit -1
}


case $# in
    0)
       checkoutBranchByAll main
    ;;
    2)
       if [[ $1 == '-m' ]]
       then
       	while getopts ':m:' OPT; do
           case $OPT in
               m)
                   checkoutBranchByAll $OPTARG
               ;;
               ?)
                   usage
               ;;
           esac
       	done
       else
	usage
       fi
    ;;
    *)
    usage
    ;;
esac

cd ${mainPath}

flutter pub get
#flutter clean