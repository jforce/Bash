ifconfig eth0 | grep HW | sed 's/^.*HW //; s/://g'
