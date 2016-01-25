#! /bin/bash
echo -e "Testing parse_csv.rb"
echo -e "--------------------------"
/usr/bin/time -f "realtime: %E, CPUtime: %e, maxmem: %M KB, CPU: %P" ruby parse_csv.rb $1 > output.txt

echo -e "Testing parse_csv_verbose.rb"
echo -e "--------------------------"
/usr/bin/time -f "realtime: %E, CPUtime: %e, maxmem: %M KB, CPU: %P" ruby parse_csv_verbose.rb $1 > output.txt