@echo off
set PROJECTNAME=game
set ROMFILE=obj\%PROJECTNAME%.gb
set BGB_PATH="C:\mon\chemin\vers\bgb\bgb.exe"
:: Remplacez le chemin précédent par le chemin vers l'émulateur BGB.

echo.
echo === 1. Compilation de la ROM ===
mingw32-make all

:: S'assure que le fichier ROM a été créé
if exist %ROMFILE% (
    echo.
    echo === 2. Démarrage de l'émulateur ===
    start "" %BGB_PATH% %ROMFILE%
    echo Lancement de %ROMFILE% avec BGB...
) else (
    echo.
    echo ***ERREUR***
    echo Erreur lors de la compilation.
)