#!/bin/bash
cd MM
source ../SetEnvironment.sh DFTB

timestep=$1
ibead=$2
input=input$ibead
geom=../geom_mm.dat.$ibead

natom=`cat $geom | wc -l`
WRKDIR=OUT$ibead.$natom
mkdir -p $WRKDIR ; cd $WRKDIR

# You have to specify, which elements are present in your system
# i.e. define array id[x]="element"
# No extra elements are allowed.
awk -v natom="$natom" 'BEGIN{
   id[1]="O"
   id[2]="H"
   nid=2    # number of different elements

# END OF USER INPUT
   print natom,"C"
   for (i=1;i<=nid;i++) {
      printf"%s ",id[i]
   }
   print ""
   print ""
}
#conversion of xyz input to dftb geom
{
   for (i=1;i<=nid;i++) {
      if ( $1 == id[i] ) {
         print NR, i, $2, $3, $4
      }
   }
}'  ../$geom > geom_in.gen

#Reading initial charge distribution
if [ -e charges.bin ];then
   sed 's/#ReadInitialCharges/ReadInitialCharges/' ../dftb_in.hsd > dftb_in.hsd
else
   cp ../dftb_in.hsd .
fi

rm -f detailed.out

$DFTBEXE  &> $input.out
################################
cp $input.out $input.out.old

### EXTRACTING ENERGY AND FORCES
grep 'Total energy:' detailed.out | awk '{print $3}' > ../../engrad_mm.dat.$ibead
awk -v natom=$natom '{if ($2=="Forces"){for (i=1;i<=natom;i++){getline;printf"%3.15e %3.15e %3.15e \n",-$1,-$2,-$3}}}' \
 detailed.out >> ../../engrad_mm.dat.$ibead


