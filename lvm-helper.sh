#!/bin/bash
# lvm helper tested for centos 6.8 and Ubuntu 16.04

function klausti() {
  echo "[y/n]"
  read x
  case "$x" in
          y|Y)
              echo "Komanda vykdoma..."
              echo
              ;;

          *)
              echo "Komanda atsaukta."
              exit 1

  esac
}

#pauses funkcija
pause() {
  local dummy
  read -s -r -p "Press any key to continue..." -n 1 dummy
}

function disko_pasirinkimas {
 #Skirtingos lsb atvaizdavimas funkcijoms
 if [[ "$stage" == "1" ]]; then
   klausti && lsblk -d -n -e 1,11  && echo "Kurį diską?" && read diskas
  else
    pvs -v  && read -e -p "Kuria [sd*] particiją? : " diskas
    echo
 fi

 dkelias=/dev/$diskas

  #Tikrina ar gerai pasirinktas /dev/sd*
  if [ -e $dkelias ] && [ -b $dkelias ]; then
    echo "Pasirinkas diskas: $dkelias"
    echo
  else
    echo
    echo "$dkelias diskas nerastas"
    exit 1

  fi
}
#########################
# PRADZIA
# Meniu funkcijos
##########################
function disko_paruosimas() {
  stage=1
  lsblk -o NAME,TYPE,MODEL,FSTYPE,SIZE -e 1,11 |  egrep  --color "disk|"
  echo
  echo "Ar paruošti diską lvm'ui?"
  disko_pasirinkimas


  lsblk $dkelias -o NAME,TYPE,MODEL,SIZE
  echo
  isdisk=`lsblk $dkelias -t -d -n -o TYPE`
  ispart=`lsblk -n $dkelias | wc -l`

  if [[ $isdisk != "disk" ]]; then
    #Tikrina ar nepasirinka particija ir sukuria nauja lvm particija
    echo "Klaida! Įrenginys yra disko particija."
    exit 1

  elif [[ $ispart != "1" ]]; then
    #Tikrina ar nebuvo jau padarytu particiju
    echo "Klaida! Įrenginys $dkelias jau turi particijas."
    exit 1
  else
    printf "n\nn\np\n1\n\n\nt\n8e\np" | sudo fdisk $dkelias
    echo lsblk $dkelias
    echo
    echo "Bus sukurta particija su ext4 faikų sistema. Tęsti?"
    #Kuriam particiją ir failų sistemą
    klausti && printf "n\nn\np\n1\n\n\nt\n8e\nw" |  fdisk $dkelias

    echo "Prideti disko particija prie lvm?" && klausti && pvcreate ${dkelias}1
    pause

  fi
}

function vg_start {

  stage=2 #kitas meniu renkantis particija
  clear
  echo; pvs $dkelias; echo; vgs
  echo
  echo "VG: Tomų grupės meniu ($dkelias):"
  echo "1.Prideti pv prie esancios grupes"
  echo "2.Ištrinti pv iš esančios grupes."
  echo "3.Sukuriam naują grupę ir pridedam pv."
  echo "r.Pervadinti vg grupę."
  echo "d.Ištrinti grupę."
  echo "m.Sujungti į vieną grupę."

  echo
  read -e -p "Pasirinkimas: "
  case "$REPLY" in

        1)
        disko_pasirinkimas
        vgs
        read -e -p "Įvekite VG grupės pavadinima: " vgpavadinimas && klausti && vgextend $vgpavadinimas $dkelias
            ;;

        2)
        disko_pasirinkimas
        vgpavadinimas=`pvs --noheadings -o vg_name $dkelias`
        echo "Trinti iš $vgpavadinimas tomo gupės?" && klausti && vgreduce $vgpavadinimas $dkelias
        pause
            ;;

        3)
        disko_pasirinkimas
        read -e -p "Įvekite naują VG grupės pavadinimą: " vgpavadinimas && klausti && vgcreate $vgpavadinimas $dkelias
        pause
            ;;

        "r")
        vgs
        read -e -p "Įvekite sena VG grupės pavadinimą: " senas_vgpavadinimas && read -e -p "Įvekite naują VG grupės pavadinimą: " naujas_vgpavadinimas && klausti && vgrename $senas_vgpavadinimas $naujas_vgpavadinimas
        pause
            ;;

        "d")
        vgs
        read -e -p "Įveskite, kuria grupę trinsim: " vgpavadinimas && klausti && vgremove $vgpavadinimas
        pause
            ;;

        "m")
        vgs
        read -e -p "Įvekite VG grupės pavadinimą, prie kurios sujungti: " senas_vgpavadinimas && read -e -p "Įvekite VG grupės pavadinimą, kurį prijungti(dings): " naujas_vgpavadinimas && klausti && vgmerge $senas_vgpavadinimas $naujas_vgpavadinimas
        pause
        ;;

        *)
            exit 1

esac
}

function lv_start {

  stage=3 #kitas meniu renkantis particija
  clear
  echo; vgs; echo; lvs
  echo
  echo "LV: Lokinių Tomų diskų meniu :"
  echo "1.Sukurti loginį diską."
  echo "2.Keisti lv disko vietą praplesti/sumažinti."
  echo "d.Trinti lv diską."
  echo "x.XXXXXXXXXwhyXXXXXXXXXXXXXX"
  echo
  read -e -p "Pasirinkimas: "
  case "$REPLY" in

        1)
        vgs
        read -e -p "Įvekite VG grupę: " vgpavadinimas && vgs --noheadings $vgpavadinimas && read -e -p "Įvekite naują LV disko pavadinimą: " lvpavadinimas || exit 1
        vgfreespace=`vgs $vgpavadinimas --noheadings -o vgfree`
        read -e -p "Laisva: $vgfreespace Įvekite naujo disko dydį: " vgdydis && klausti && lvcreate --name "$lvpavadinimas" --size "$vgdydis" "$vgpavadinimas"
        pause
            ;;

        2)
        vgs
        read -e -p "Įvekite VG grupę: " vgpavadinimas
        lvs $vgpavadinimas || exit 1
        read -e -p "Įvekite LV disko pavadinimą, kuri norite praplėsti: " lvpavadinimas
        lvspace=`lvs /dev/"$vgpavadinimas"/"$lvpavadinimas" --noheadings -o lv_size`
        lvs /dev/"$vgpavadinimas"/"$lvpavadinimas" || exit 1
        vgfreespace=`vgs $vgpavadinimas --noheadings -o vgfree`
        filesystem=`lsblk -f /dev/"$vgpavadinimas"/"$lvpavadinimas" -n -o fstype` #tikrina ar yra failu sistema

       if [[ ! -n "$filesystem" ]]; then
         #Tikrina ar lvparticija turi failu, sistemą, jei ne suformatuoja
         lsblk -f /dev/"$vgpavadinimas"/"$lvpavadinimas" -n -o name,fstype
         printf "\nFailų sistema nerasta\nĮdiegti ext4 failų sistemą į /dev/"$vgpavadinimas"/"$lvpavadinimas" ? "
         klausti && mkfs.ext4 /dev/"$vgpavadinimas"/"$lvpavadinimas"
       fi

        echo
        echo "1. Statinis keitimas."
        echo "2. Procentalus"
        read -e -p "Įvekite tipa: "

        if [[ "$REPLY" == "1" ]]; then
          #prapletimo susiaurinimo tipas
          change_size_type="size"
          echo
          echo "Prapletimas/Susiaurinimas: [+|-]1GB"
          echo "Fiksuotas nustatymas: 50M"
          echo
          read -e -p "Dabartinis "$lvpavadinimas"  dydis: ${lvspace} iš${vgfreespace}. Keičiamas į: " vgdydis && klausti && lvresize --${change_size_type} ${vgdydis} --resizefs  /dev/"$vgpavadinimas"/"$lvpavadinimas"

        else
            echo
            echo "Procentaliai: +100%FREE"
            echo "Arba nurodant PE reikšmę"
            echo
            change_size_type="extents"
            read -e -p "Dabartinis "$lvpavadinimas" dydis: ${lvspace} iš${vgfreespace}. Keičiamas į: " vgdydis && klausti && lvresize --${change_size_type}  ${vgdydis} --resizefs  /dev/"$vgpavadinimas"/"$lvpavadinimas"

        fi
        pause
        ;;

        "d")
        vgs
        read -e -p "Įvekite VG grupę: " vgpavadinimas
        lvs $vgpavadinimas || exit 1
        read -e -p "Įvekite LV disko pavadinimą, kuri norite ištrinti: " lvpavadinimas
        lvs /dev/"$vgpavadinimas"/"$lvpavadinimas" || exit 1
        lvremove  /dev/"$vgpavadinimas"/"$lvpavadinimas"
        pause
        ;;

        x)
        vgs
        read -e -p "Įvekite VG grupę: " vgpavadinimas
        lvs $vgpavadinimas || exit 1
        read -e -p "Įvekite LV disko pavadinimą, kuri norite praplėsti: " lvpavadinimas
        lvspace=`lvs /dev/"$vgpavadinimas"/"$lvpavadinimas" --noheadings -o lv_size`
        lvs /dev/"$vgpavadinimas"/"$lvpavadinimas" || exit 1
        vgfreespace=`vgs $vgpavadinimas --noheadings -o vgfree`
        read -e -p "Dabartinis dydis: ${lvspace} iš${vgfreespace}. Įvekite naujo disko dydį: " vgdydis && klausti && lvextend -L $vgdydis /dev/"$vgpavadinimas"/"$lvpavadinimas"

        function fix_lv_size {
          #po lv prapletimo sutvarko diska
          e2fsck -f /dev/"$vgpavadinimas"/"$lvpavadinimas"
          resize2fs /dev/"$vgpavadinimas"/"$lvpavadinimas"
        }

        if mount | grep --word-regexp  "${vgpavadinimas}-${lvpavadinimas}"> /dev/null; then
          #tikrina ar yra mountas, jei yra nuima sutvarko, vel uzdeda
          mountpoint=`mount | grep "${vgpavadinimas}-${lvpavadinimas}" | awk '{print $1}' `
          mountdir=`mount | grep "${vgpavadinimas}-${lvpavadinimas}" | awk '{print $3}' `
          echo "Negaliu paleisti e2fsck, radau mount'a: ${mountpoint}"
          echo "Nuimti?" && klausti && umount ${mountpoint}
          fix_lv_size
          mount /dev/"$vgpavadinimas"/"$lvpavadinimas" ${mountdir}
          df -hP /dev/"$vgpavadinimas"/"$lvpavadinimas"
        else
          echo "Mountas nerasta."
          fix_lv_size
        fi
        pause
            ;;


        #
        # "r")
        # vgs
        # read -e -p "Įvekite sena VG grupės pavadinimą: " senas_vgpavadinimas && read -e -p "Įvekite naują VG grupės pavadinimą: " naujas_vgpavadinimas && klausti && vgrename $senas_vgpavadinimas $naujas_vgpavadinimas
        # pause
        #     ;;
        #
        #
        # "m")
        # vgs
        # read -e -p "Įvekite VG grupės pavadinimą, prie kurios sujungti: " senas_vgpavadinimas && read -e -p "Įvekite VG grupės pavadinimą, kurį prijungti(dings): " naujas_vgpavadinimas && klausti && vgmerge $senas_vgpavadinimas $naujas_vgpavadinimas
        # pause
        # ;;

        *)
            exit 1

esac
}


#########################
# PABAIGA
# Meniu funkcijos
##########################



while true; do
  #statements
  clear
  #lsblk -o NAME,MODEL,TYPE,FSTYPE,SIZE -e 1,11
  echo;pvs;echo;vgs
  echo
  echo "Meniu:"
  echo "1.Disko paruosimas LVM'ui"
  echo "-------------------"
  echo "2.Volume Grupes tvarkimas."
  echo "3.LV tvarkimas."
  echo "--------------------."
  echo
  read -e -p "Pasirinkimas: "
  case "$REPLY" in
          1)
              disko_paruosimas
              ;;

          2)
              vg_start
              ;;
          3)
              lv_start
              ;;

          condrestart)
              if test "x`pidof anacron`" != x; then
                  stop
                  start
              fi
              ;;

          *)
              printf "\nSee ya... \n\n"
              exit 1

  esac

done
