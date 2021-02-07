#!/bin/bash

function git_build()
{
	cd /mnt//mnt/github/HUGO_blog
	git pull
	rm -rf /usr/local/nginx/html/hugo/*
	hugo -D -d /usr/local/nginx/html/hugo
}

git_build
