#!/bin/sh
cd ${0%/*} || exit 1

. $WM_PROJECT_DIR/bin/tools/RunFunctions

# indique el solver RKXFoam
rm -r 2.00000000
rm -r 4.00000000
rm -r 6.00000000
rm -r 8.00000000
rm -r postProcessing
rm -r processor*
rm -r log.*

numProc=6
cp  ./system/decomposeParDict.orig	./system/decomposeParDict
UFile="./system/decomposeParDict"
sed s/"\(numberOfSubdomains[ \t]*\) 4"/"\1 $numProc"/g $UFile > temp.$$
mv -f temp.$$ $UFile

topoSet
decomposePar
mpiexec -np $numProc renumberMesh -overwrite -parallel

mpiexec -np $numProc $1 -parallel
