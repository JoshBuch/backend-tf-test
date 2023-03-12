#!/bin/bash

input="/tmp/url.txt"
while IFS="/n" read -r url; do
echo Script for automated testing.
echo $url
PARSED_PROTO="$(echo $url | sed -nr 's,^(.*://).*,\1,p')"
PARSED_URL="$(echo ${url/$PARSED_PROTO/})"
timestamp="./$PARSED_URL/`date +%Y%m%d`T`date +%H%M`"
#timestamp="./$PARSED_URL/$(date +%T)"

mkdir -p $timestamp
echo created directory $timestamp
touch -a $timestamp/scan.log

x="http://"
if [ "$PARSED_PROTO" == "$x" ]; then
        echo "The site is working on http:// this practice is not accepted."
        exit 1
fi

a="https://"
echo Running OWASP-ZAP....
nmap --script http-dombased-xss "$PARSED_URL" >> $timestamp/scan.log
nmap --script http-stored-xss "$PARSED_URL" >> $timestamp/scan.log
python3 /zap/zap-api-scan.py -t "$a$PARSED_URL" -f openapi >> $timestamp/scan.log
#sqlmap -u "$a$PARSED_URL" --level=5 --risk=3 -a --batch >> $timestamp/scan.log
#sslyze  "$*":443 --regular

nmap --script firewall-bypass "$PARSED_URL" >> $timestamp/scan.log
nmap --script http-malware-host "$PARSED_URL" >> $timestamp/scan.log
nmap --script http-sitemap-generator "$PARSED_URL" >> $timestamp/scan.log


done < /tmp/url.txt
