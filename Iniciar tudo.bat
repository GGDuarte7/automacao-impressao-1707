@echo off
title Iniciando Automacao WinThor 1707...

:: Forca o prompt a navegar ate a pasta exata onde este arquivo .bat esta salvo
cd /d "%~dp0"

:: 1. Inicia o servidor do Keep 100% invisivel em segundo plano
start "" pythonw "servidor_keep.py"

:: 2. Inicia o script do AutoHotkey
start "" "impressao_1707.ahk"

exit