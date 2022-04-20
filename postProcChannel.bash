#!/bin/sh
cd ${0%/*} || exit 1    # Run from this directory

tiempo='6000.00000000'
reconstructPar -time $tiempo
mv $tiempo/U $tiempo/U.orig
cp $tiempo/UMean $tiempo/U
pimpleFoam -postProcess -func wallShearStress -time $tiempo 
mv $tiempo/wallShearStress $tiempo/wallShearStressMean
mv -f $tiempo/U.orig $tiempo/U
postProcess -func "mag(wallShearStressMean)" -time $tiempo
postProcess -func "patchIntegrate(name=topWall,mag(wallShearStressMean))" -time $tiempo
postProcess -func "patchIntegrate(name=bottomWall,mag(wallShearStressMean))" -time $tiempo

postBudget -time $tiempo
postChannelBudgetFoam -time $tiempo