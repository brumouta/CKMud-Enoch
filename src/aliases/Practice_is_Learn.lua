local what = matches[2]
if what then
send("learn "..what)
else
send("learn")
end