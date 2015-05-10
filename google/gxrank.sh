#!/bin/bash

#
# gxrank - how many pages does Google have in its index for you?
#
# 2009 - Mike Golvach - eggi@comcast.net
#
# Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
#

if [ $# -ne 1 ]
then
        echo "Usage: $0 URL"
        echo "URL with or with http(s)://, ftp://, etc"
        exit 1
fi

url=$1
shift

base=0
start=0
not_found=0
search_string="site:$url"

echo "Searching For Google Indexed Pages For $url..."
echo

num_results=`wget -q --user-agent=Firefox -O - http://www.google.com/search?q=$search_string\&hl=en\&safe=off\&pwst=1\&start=$start\&sa=N|awk '{ if ( $0 ~ /of about <b>.*<\/b> from/ ) print $0 }'|awk -F"of about" '{print $2}'|awk -F"<b>" '{print $2}'|awk -F"</b>" '{print $1}'`

while :;
do
        if [ $not_found -eq 1 ]
        then
                break
        fi
   wget -q --user-agent=Firefox -O - http://www.google.com/search?q=$search_string\&num=100\&hl=en\&safe=off\&pwst=1\&start=$start\&sa=N|sed 's/<a href=\"\([^\"]*\)\" class=l>/\n\1\n/g'|awk -v num=$num -v base=$base '{ if ( $1 ~ /^http/ ) print base,num++,$NF }'|awk '{ if ( $2 < 10 ) print "Google Index Number " $1 "0" $2 " For Page: " $3; else if ( $2 == 100 ) print "Google Index Number " $1+1 "00 For Page: " $3;else print "Google Index Number " $1 $2 " For Page: " $3 }'|grep -i $url
        if [ $? -ne 0 ]
        then
                not_found=1
                if [ $not_found -eq 1 ]
                then
                    break
                fi
        else
  break
        fi

done

if [ $not_found -eq 1 ]
then
        echo "Finished Searching Google Index"
        echo
fi

echo "Out Of Approximately $num_results Results"
echo
exit 0
