# Creating initial script

for i in `xe sr-list |grep uuid |awk '{print $5}'`;do echo "$(df -h |grep sr-mount |grep $i |awk '{print $3, "FREE -", $4, "USED"}') - $i -- $(df -h |grep sr-mount |grep $i |awk '{print $1}') $(xe sr-list |grep -A3 $i |grep name-label |cut -f2 -d :)";done |grep USED
