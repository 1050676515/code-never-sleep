cd ..\
del /Q ebin\*.beam
erl -s make all -s init stop
pause