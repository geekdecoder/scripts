#!/bin/bash
# Usage: 
# Shell script too see find A recoed and update ufw
# format.
#

# ----------------------------------------------------------------------------
# Written by Geekdecoder <https://www.geekdecoder.com/>
# (c) 2021 Vivek Gite under GNU GPL v2.0+
# ----------------------------------------------------------------------------
# Last updated: 07/July/2021
# ----------------------------------------------------------------------------
set -eu -o pipefail
domain="${1:-NULL}"
 
# fail safe i.e. if no $1 passed to the script, die with an error
[ "$domain" == "NULL" ] && { echo "Usage: $0 domain-name"; exit 1; }
 
# make sure dig installed else install
if type -a dig 2>/dev/null 
then
# Install dig
echo apt install dnsutils
fi