sleep 30m
while :
do
  load5M=$(uptime | awk -F'[a-z]:' '{ print $2}' | sed s/,//g | cut -b6-11)
  threshold=0.75
  echo $load5M
  if (( $(echo "$load5M < $threshold" | bc -l) )); then
    sudo shutdown now
    break
  fi
  sleep 300
done
