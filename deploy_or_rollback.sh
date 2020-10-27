#!/bin/bash

oc get dc -o name | xargs -l1 oc rollout latest 

flag=false
for deployment in `oc get dc -o name`; do
  if [ oc describe dc $deployment | grep Failed ]; then
    flag=true
  fi;
done

if [ $flag ]; then
  oc get dc -o name | xargs -l1 oc rollback
fi
