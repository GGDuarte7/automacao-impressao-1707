@echo off
title Encerrando Processos da Automacao...
echo [%time%] Finalizando todas as instancias em segundo plano...

:: Finaliza o Python (janelas visiveis e processos em segundo plano)
taskkill /f /im python.exe 2>nul
taskkill /f /im pythonw.exe 2>nul

:: Finaliza o AutoHotkey
taskkill /f /im AutoHotkey.exe 2>nul
taskkill /f /im AutoHotkey64.exe 2>nul
taskkill /f /im AutoHotkeyUX.exe 2>nul

:: Reseta o arquivo de status antigo para evitar leitura de cache
if exist status.json del /f /q status.json

echo [%time%] Sucesso! Todos os processos foram encerrados.
timeout /t 2 >nul
exit