#!/bin/bash

set -e

img_url="https://cloud-images.ubuntu.com/trusty/current"
img_file="trusty-server-cloudimg-amd64-disk1.img"
dist_image="${img_file}.dist"
our_img="magfest-${img_file}"

if [ ! -f $dist_image ]; then
	echo "didn't find $dist_image, downloading...."
	wget "${img_url}/${img_file}" -O $dist_image
fi

echo "modifying dist image to have our modifications..."
cp -f $dist_image $our_img

guestfish --rw -a $our_img <<'EOF'
run
mount /dev/sda1 /
mkdir /root/.ssh
write-append /root/.ssh/authorized_keys "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJKBZzNEJxzeLOytMa6lhz2DiRjlHxXvG/qfFIa2SZXY/+IPb7MYEbDhCVBCmSBRgcEx0XqRLs865om/R0t0zUrH5IDwojveQ92I3DzKjkAtrwSbAFpFqNp4vC0+N0ZS0t+lKpMXSlczbwKvZ9LdvHKwDVVjhJDqhvwuiyXCnuTa2ad4ZoAAlBVyn7FCKAXlxfyX0+Kk+J7YLhEm2UGSXmkX61g28I0BczXiPE9veUZtO6POFZ8puX0Av3Pv2rZEPBdpCJYPtUsOpOAXJgYudP9V7ztlcU2nVbPwiBN+ZK9yfYzQa8OWjIUSgUudM7eFRVFu1s0Kyg8xC0VRFYKY6l dom@magfest.org"
EOF

echo "done, output file = ${our_img}"
