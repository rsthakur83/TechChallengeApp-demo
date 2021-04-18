#!/bin/bash

#$(grep $(hostname) /etc/hosts | awk '{print $1}')
export VTT_LISTENHOST=$(hostname -i)
cd /go/TechChallengeApp/dist/; ./TechChallengeApp updatedb -s;./TechChallengeApp serve
