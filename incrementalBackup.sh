#!/bin/bash
DHOME="/home/jose"
DBASE="$DHOME/backup"
DDATA="$DHOME/datos"
DATE="`date +%d%b%y`"
DSNAP="$DBASE/snapshot"
PREFIJO="incremental"
DDEST="$DBASE/$PREFIJO"
NOMBRE=`echo "$DDATA" | egrep -o "[^/]+$"`
SNAP="$DSNAP"/"$PREFIJO"_"$NOMBRE"_"$DATE".snap
TAR="$DDEST"/"$PREFIJO"_"$NOMBRE"_"$DATE".tgz

for dir in "$DBASE" "$DSNAP" "$DDEST"
do
    mkdir -p "$dir"
    if [ "$?" -ne "0" ]
    then
        case "$dir" in
            "$DBASE") echo "ERROR: No se pudo crear el directorio $DBASE.\n";;
            "$DSNAP") echo "ERROR: No se pudo crear el directorio $DSNAP.\n";;
            "$DDEST") echo "ERROR: No se pudo crear el directorio $DDEST.\n";;
        esac
    fi
done

echo "\nBackup para $DDATA será $PREFIJO\n"
                      
if [ ! -d "$DDATA" ]
then
        echo "ERROR: No es posible respaldar $DDATA. El directorio no existe\n"
        return
fi        

if [ -f "$SNAP" ]
then
        rm "$SNAP"
        echo "Archivo histórico $SNAP eliminado\n"
fi

if [ ! -e "$TAR" ]
then
        rm "$TAR"
        echo "Archivo Backup $TAR eliminado\n"
fi

echo "Iniciando $PREFIJO backup para $DDATA\t $(date "+[%x %X]")\n"
cd "$DDATA"
tar -cpvzf "$TAR" -g "$SNAP" *

if [ -e "$TAR" ]
then
    BACKUP="\n$PREFIJO backup ha sido creada correctamente\n"
else
    BACKUP="\nERROR: $PREFIJO backup no ha sido creada correctamente\n"
fi

echo "$BACKUP"
