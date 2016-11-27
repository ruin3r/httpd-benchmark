#!/bin/bash
#File Name : httpd benchmark befor and after configuration
#Coded By : shahinst
#Version : 0.01

IP="`ifconfig eth0 2>/dev/null|awk '/inet addr:/ {print $2}'|sed 's/addr://'`"
###Install Gnupilot###
echo -n "Do you want to install gnupilot(y,n) : "
	read yesorno
		if [ $yesorno = y ];then
	yum install -y httpd-tools gnuplot
		else
echo "please confirm the question for testing benchmark"
fi
sleep 1
clear

###Script Option###
echo "This script for benchmark httpd in befor and after configuration"
	sleep 2
	clear
echo -n "This test configuration is after or before the configuration?(before or after) : "
	read BA
echo -n "Please Enter Website for testing benchmark (for example : yahoo.com or 127.0.0.1 ) : "
	read website
echo -n "Please Enter Number of requests to perform(-n) : "
	read request
echo -n "Please Enter Number of multiple requests(-c) : "
	read concurrency
echo -n "Do you want enable Keep-Alive in testing benchmark(y,n)? "
	read keepalive
if [ $keepalive = y ];then
	ab -n $request -c $concurrency -k -g /var/www/html/benchmark_$BA.tsv http://$website/ > log.txt
		else
	ab -n $request -c $concurrency -g /var/www/html/benchmark_$BA.tsv http://$website/ > log.txt
fi
cd /var/www/html
###GnuPlot Setting###
gnuplot -persist <<- EOF
	set terminal png
	set output "benchmark.png"
	set title "benchmark for $IP from http://$website/ before and after configuration httpd"
	set size 1,1
	set grid y
	set xlabel 'Request'
	set ylabel 'Response Time (ms)'
	plot "benchmark_before.tsv" using 10 smooth sbezier with lines title "Before", "benchmark_after.tsv" using 10 smooth sbezier with lines title "after"
EOF
clear
echo "please check this url in browser : http://$IP/benchmark.png"

