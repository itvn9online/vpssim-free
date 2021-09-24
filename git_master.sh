#!/bin/sh

pull_code(){
git checkout master
git pull
git pull origin $1
git merge $1
git push
}
pull_code "huydv04"
pull_code "ducnd"
pull_code "hung"
