#!/bin/sh

pull_code(){
git checkout $1
git pull
git pull origin master
git merge master
git push
}
pull_code "daidq"
