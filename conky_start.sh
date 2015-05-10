#!/bin/bash
sleep 60 &&
exec conky -d -c ~/.conkyrc &
exit
