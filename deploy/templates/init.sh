#!/bin/bash
  
# turn on bash's job control
set -m
  
# Start the primary process and put it in the background
dgraph alpha --my=alpha:7080 --zero=zero:5080 &
  
# Start the helper process
sleep 30 && curl -X POST localhost:8080/admin/schema --data-binary '@schema.graphql'
  
# the my_helper_process might need to know how to wait on the
# primary process to start before it does its work and returns
  
  
# now we bring the primary process back into the foreground
# and leave it there
fg %1