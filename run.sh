#!/bin/bash

set -e

img_url="https://cloud-images.ubuntu.com/trusty/current"
img_file="trusty-server-cloudimg-amd64.ova"
dist_image="${img_file}.dist"
our_img="magfest-${img_file}"

if [ ! -f $dist_image ]; then
	echo "didn't find $dist_image, downloading...."
	wget "${img_url}/${img_file}" -O $dist_image
fi

echo "modifying dist image to have our modifications..."

mkdir -p contents
cd contents
tar xvf ../$dist_image

sed -i 's/^.*ovf:key="seedfrom".*/      <Property ovf:key="seedfrom" ovf:type="string" ovf:userConfigurable="true" ovf:value="https:\/\/raw.githubusercontent.com\/magfest\/vsphere-rams-cloud-init\/master\/cloudinit\/">/' trusty-server-cloudimg-amd64.ovf

sha1=`sha1sum trusty-server-cloudimg-amd64.ovf`
line="SHA1(trusty-server-cloudimg-amd64.ovf)= $sha1"

sed -i "s/^.*ovf.*/$line/" trusty-server-cloudimg-amd64.mf

# order, and the appending, is EXTREMELY important here
# http://kristau.net/blog/1265/
tar cvf ../$our_img *.ovf
tar uvf ../$our_img *.mf *.vmdk

cd ..

rm -rf contents

echo "done, output file = ${our_img}"
