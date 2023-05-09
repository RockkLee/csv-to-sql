# sed 不能帶單引號
# 定義
fname="$1"
op=$(echo "$fname" | cut -d"." -f 1)
tmpname="${op}_temp.csv"
sed 's/\s*,*\s*$//g' "$fname" > "$tmpname"
opfile2="${op}_A.sql"
op="$op"
columns=$(head --lines=1 "$tmpname" | sed 's/,/,/g' | tr -d "\r\n")
columns="$columns"

echo "SELECT * FROM $op WHERE ($columns) IN (" > "$opfile2"
# while-loop
tail --lines=+2 "$tmpname" | while read l ; do
values=$(echo $l | sed 's/,/\",\"/g' | tr -d "\r\n")
values="\"$values\""
echo "($values),"
done >> "$opfile2"
echo ");" >> "$opfile2"

rm "$tmpname"
