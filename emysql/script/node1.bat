cd ..\config
erl  -boot crypto -config db -pa ..\ebin  -s db  start
pause