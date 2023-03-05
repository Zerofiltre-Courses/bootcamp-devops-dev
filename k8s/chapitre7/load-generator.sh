#!/bin/bash

kubectl run -i --tty load-generator --rm --image=busybox:1.28 -n zerofiltre-bootcamp \
--restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://solidinvoice-svc; done"