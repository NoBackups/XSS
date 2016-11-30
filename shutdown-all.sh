for i in `xe vm-list |grep uuid |cut -f2 -d:`;
  do echo "Processing $i"; 
  xe vm-shutdown vm=$i;
  done;
echo "Shutting down host";
  shutdown now
