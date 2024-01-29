#!/usr/bin/env bash
#Main Project directory
mainPath=$(pwd)
mainProjectName=${mainPath##*/}

#Submodule directory
baseFrameworkPath=${mainPath}/packages/base_framework
businessModulesPath=${mainPath}/packages/business_modules
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
    if [[ ${submoduleName##*/} == ${mainProjectName} ]]
    then
        if [[ ! "$(ls -A ${baseFrameworkPath})" || ! "$(ls -A ${businessModulesPath})" ]]
        then
            git submodule init
            check "git submodule update"
        	git submodule update
        fi
    fi

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
    checkoutBranch ${baseFrameworkPath} $2
    checkoutBranch ${businessModulesPath} $3
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
    echo "ox_pub_get.sh [-m Main Project Branch Name] [-b Base Framework Branch Name] [-s Business Modules Name]"
    exit -1
}


case $# in
    0)
       checkoutBranchByAll main main main
    ;;
    2)
       if [[ $1 == '-m' || $1 == '-b' || $1 == '-s' ]]
       then
       	while getopts ':m:b:s:' OPT; do
           case $OPT in
               m)
                   checkoutBranchByAll $OPTARG main main
               ;;
               b)
                   checkoutBranchByAll main $OPTARG main
               ;;
               s)
                   checkoutBranchByAll main main $OPTARG
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
    4)
        if [[ $1 = '-m' && $3 = '-b' ]]
        then
           checkoutBranchByAll $2 $4 main
        elif [[ $1 = '-m' && $3 = '-s' ]]
        then
           checkoutBranchByAll $2 main $4
        elif [[ $1 = '-b' && $3 = '-s' ]]
        then
           checkoutBranchByAll main $2 $4
        else
            usage
        fi
    ;;
    6)
        while getopts ':m:b:s:' OPT; do
            case $OPT in
                m)
                    checkoutBranch ${mainPath} $OPTARG
                ;;
                b)
                    checkoutBranch ${baseFrameworkPath} $OPTARG
                ;;
                s)
                    checkoutBranch ${businessModulesPath} $OPTARG
                ;;
                ?)
                    usage
                ;;
            esac
        done
    ;;
    *)
    usage
    ;;
esac

executePubGet ${baseFrameworkPath}

executePubGet ${businessModulesPath}


cd ${mainPath}

flutter pub get
#flutter clean