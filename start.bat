echo off
cd C:\git\hsby
start werl -pa ./ebin -sname %1 -s hsby_cpu -init %2
echo on