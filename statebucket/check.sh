#/bin/bash

../statebucket/status.sh 

if [ $? -eq 0 ]
then
        echo "Sucessful deployment!!! :)"
else
  exit 1
  echo "Unccessulful deployment :("
fi
