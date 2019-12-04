#!/usr/bin/env bash
LO=$(echo $1 | cut -d'.' -f4)
DELAY=$(expr ${LO} \* 5)
ODD=$(expr ${LO} \% 2)
AGENTTIME=$(date | awk '{print $4}' | cut -d':' -f2 | sed 's/^0*//')
PBRUN=`which pbrun`

if [ ${ODD} -eq 0 ]
then
  if [ ${AGENTTIME} -ge 35 ]
    then
      sleep ${DELAY}
      ${PBRUN} -p pbtest 2>/dev/null
  fi
else
  if [ ${AGENTTIME} -lt 35 ]
    then
      sleep ${DELAY}
      ${PBRUN} -p pbtest 2>/dev/null
  fi
fi
