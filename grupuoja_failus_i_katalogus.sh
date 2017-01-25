#!/bin/bash
for i in $(ls);do

# $i    -  Dokumento pavadinimas
# praid -  Tik pirma dokumento raide
praid=`echo $i | cut -c 1`

# Tikrina ar yra direktorija $praid kintamuoju
# jei nera, tuomet ja sukuria
if [ ! -d "$praid" ]; then
   mkdir $praid
fi

# Tikrina ar tai failas
# tikrina, kad nekeltu katalogu
# Antroje and dalyje tikrina, kad neperkeltu vykdomos programos i kataloga
if  [ -f "$i" ] && [ "$i" != "$0" ]; then

   mv $i $praid
fi

done
