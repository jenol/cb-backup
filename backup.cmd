set server=%1
set path=%2

D:
"D:\Program Files\Couchbase\Server\bin\cbtransfer.exe" -u Administrator -p yourpassw -b ycs -k ^NHA_ http://%server%:8091 "%path%"
