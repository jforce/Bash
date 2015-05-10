if [[ ! -f HDSentinel ]]; then
	wget http://www.hdsentinel.com/hdslin/hdsentinel_008.zip
	unzip hdsentinel_008.zip
	chmod +x HDSentinel
fi

sudo ./HDSentinel
