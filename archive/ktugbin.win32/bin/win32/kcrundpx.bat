@echo off
latex -synctex=1 "%1"
dvipdfmx "%~n1"
