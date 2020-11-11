#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: ./testgit.sh Path"
	exit 1
fi

Location=$1

function setup() {
	clear

	cd $Location >/dev/null 2>&1

	if [ $? -ne 0 ]; then
		echo "Change to directory $Location failed!"
		exit 1
	fi

	rm -rf BitBucketComputer
	rm -rf LocalComputer

	mkdir BitBucketComputer
	mkdir LocalComputer

	cd BitBucketComputer
	git init --bare sample-repo.git
	cd ..

	cd LocalComputer

	mkdir sample-repo
	cd sample-repo
}

function menu() {
	clear

	echo "Menu"
	echo "1: Init, Remote add repo, Pull"
	echo "2: Init, Remote add repo, Push"
	echo "3: Init, Add & commit file, Remote add repo, Pull"
	echo "4: Init, Add & commit file, Remote add repo, Push"
	echo -n "Enter your choice: "
	read choice
	echo

	set -x
}

function option1() {
	git init

	git remote add blah $Location/BitBucketComputer/sample-repo.git

	git pull blah master
}

function option2() {
	git init

	git remote add blah $Location/BitBucketComputer/sample-repo.git

	git push blah master
}

function option3() {
	git init

	touch a.txt
	git add .
	git commit -m "added a.txt"

	git remote add blah $Location/BitBucketComputer/sample-repo.git

	git pull blah master

	git pull blah master --allow-unrelated-histories
}

function option4() {
	git init

	touch a.txt
	git add .
	git commit -m "added a.txt"

	git remote add blah $Location/BitBucketComputer/sample-repo.git

	git push blah master

	git push -u blah master
}

setup

menu

case $choice in
	1) option1 
	   ;;

	2) option2 
	   ;;

	3) option3
	   ;;

	4) option4
	   ;;

	*) echo "Ha ha!"
	   ;;
esac

exit 0
