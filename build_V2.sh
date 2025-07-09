


# Fungsi Main

main() {

echo " "
echo "--------------Builder TWRP by Massatrio16 -----------"
echo "1. New Build for Aosp (sync minimal manifest)"
echo "2. Rebuild for Aosp ( No need sync minimal manifest)"
echo "3. New Build For Ofox (Sync Minimal Manifest) "
echo "4. Rebuild for ofox ( No need sync Minimal Manifest)"
echo "5. Setting Notification Telegram & Upload File (Recommended)"
echo "6. Delete All Resources Sync Manifest "
echo "7. Exit "
echo "8. Clean resources "
echo " "
read -p "Pilih ( 1 - 9) : " Main

# Mendeteksi Input pengguna
if [ "${Main}" = 1 ]; then ## Jika Pengguna Input 1 ##
Aosp
main
elif [ "${Main}" = 2 ]; then ## Jika Pengguna Input 2 ##
ReAosp
main
elif [ "${Main}" = 3 ]; then ## Jika pengguna input 5 ##
Ofox
main
elif [ "${Main}" = 4 ]; then ## Jika pengguna input 6 ##
reofox
main
elif [ "${Main}" = 5 ]; then ## Jika pengguna input 7 ##
botconfig
elif [ "${Main}" = 6 ]; then ## Jika pengguna input 8 ##
deletesync
elif [ "${Main}" = 7 ]; then ## jika pengguna input 9 $#
exit 0
elif [ "${Main}" = 8 ]; then ## jika pengguna input 9 $#
clener
else ## Jika pengguna Memasukkan selain pilihan ##
echo " "
echo " input tidak valid !!!!"
echo " "
main
fi
}


###########################################################
###########################################################
##############################################################
##############################################################



Aosp() {

 
source ${current_directory}/save_settings.txt
echo " "
echo " TWRP BUILD CONFIGURATION "
echo "  "
echo " : CATATAN : "
echo "[Wajib] = tidak boleh skip"
echo "Jika terjadi salah kamu bisa ulangi dengan skip(tekan enter) pada Konfigurasi berlabel wajib"
echo " "
# Membuat Folder twrp
 

 # Input Konfigurasi
 
 
echo "Pilih Custom Recovery"
echo "1. twrp"
echo "2. pbrp"
echo "3. shrp"
echo "Pilih Tipe"
read tipe

if [ "$tipe" = 1 ]; then
sed -i "s|Build_Status=.*|Build_Status=TWRP|" ${current_directory}/save_settings.txt
Link=https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git
elif [ "$tipe" = 2 ]; then 
sed -i "s|Build_Status=.*|Build_Status=PBRP|" ${current_directory}/save_settings.txt
Link=https://github.com/PitchBlackRecoveryProject/manifest_pb
elif [ "$tipe" = 3 ]; then 
sed -i "s|Build_Status=.*|Build_Status=SHRP|" ${current_directory}/save_settings.txt
Link=https://github.com/SHRP-Reborn/manifest.git
else
echo "input tidak valid"
main
fi

echo "Manifest Branch AVAILABLE : "
echo " 11 (shrp tidak support)"
echo " 12.1 "
echo " 14.1 (only twrp)"
echo "Pilih Manifest branch (11 12,1 14.1) [wajib] : "
read Manifest_branch
if [ -z "$Manifest_branch" ]; then
    echo "Input Manifest branch kosong!."
    echo " "
    main
fi

if [ "${Manifest_branch}" != "11" ] && [ "${Manifest_branch}" != "12.1" ] && ["${Manifest_branch}" != "14.1" ]; then
   echo ""
   echo "sepertinya Minimal Manifest yang dimasukkan tidak tersedia!"
   echo " "
   main
   fi

echo " "
echo " Link Device Tree TWRP [wajib] : "
read Device_tree
if [ -z "${Device_tree}" ]; then
    echo "Input Device tree Kosong !"
    echo " "
    main
    fi
echo " "
echo "Branch Device_tree_twrp [wajib]: "
read Branch_dt_twrp
if [ -z "${Branch_dt_twrp}" ]; then
    echo "Input branch device tree Kosong !"
    echo " "
    main
fi
echo " "
echo "Device Path [wajib]: "
read Device_Path
if [ -z "${Device_Path}" ]; then
    echo "Input Device path Kosong!"
    echo " "
    main
fi
echo " "
echo "Device Name [wajib]: "
read Device_Name
if [ -z "${Device_Name}" ]; then
    echo "Input Device Name Kosong!"
    echo " "
    main
fi
echo " "
echo " Run Lunch target Twrp (Isi nama lunch setelah twrp_ (contoh : x657b untuk twrp_x657b)"
read Lunch
if [ -z "${Lunch}" ]; then
    echo "Input Lunch Kosong!"
    echo " "
    main
    
fi
echo " "
echo "Build Target ( recovery / boot / vendorboot ) [wajib]: "
read Build_Target
 if [ -z "${Build_Target}" ]; then
    echo "Input Build Target Kosong!"
    echo " "
    main
   
fi
 if [ "${Build_Target}" != "recovery" ] && [ "${Build_Target}" != "boot" ] && [ "${Build_Target}" != "vendorboot" ]; then
   echo ""
   echo "Sepertinya  Build Target tidak cocok, yang kamu ketik saat ini adalah ${Build_Target}"
   echo " "
   main
   fi
echo " "
echo " Link_Device_Tree_Common "
read Common
echo " "
echo " Device_Path_Common "
read Path_Common

if [ -n "${Common}" ] && [ -z "${Path_Common}" ]; then
echo " "
echo " Device tree common Terisi!, Tetapi Path Common Kosong"
main
fi

if [ -z "${Common}" ] && [ -n "${Path_Common}" ]; then
echo " "
echo " Patch common Terisi, Tetapi Device tree common kosong "
main
fi

echo " "
echo " Mendeteksk Out Target File... "
Out=$(basename "$Device_Path")
sed -i "s|Out=.*|Out=$Out|" ${current_directory}/save_settings.txt
sleep 1




# MENYIMPAN KONFIGURASI KE FILE save_settings.txt

echo " "
echo "Menyimpan Konfigurasi..."
echo " "
sed -i "s|Manifest_branch=.*|Manifest_branch=$Manifest_branch|" ${current_directory}/save_settings.txt
sed -i "s|Device_tree=.*|Device_tree=$Device_tree|" ${current_directory}/save_settings.txt
sed -i "s|Branch_dt_twrp=.*|Branch_dt_twrp=$Branch_dt_twrp|" ${current_directory}/save_settings.txt
sed -i "s|Device_Path=.*|Device_Path=$Device_Path|" ${current_directory}/save_settings.txt
sed -i "s|Device_Name=.*|Device_Name=$Device_Name|" ${current_directory}/save_settings.txt
sed -i "s|Build_Target=.*|Build_Target=$Build_Target|" ${current_directory}/save_settings.txt
sed -i "s|Lunch=.*|Lunch=$Lunch|" ${current_directory}/save_settings.txt
if [ -n "${Common}" ] && [ -n "${Path_Common}" ]; then
sed -i "s|Common=.*|Common=$Common|" ${current_directory}/save_settings.txt
sed -i "s|Path_Common=.*|Path_Common=$Path_Common|" ${current_directory}/save_settings.txt
fi



echo " "
echo " Tersimpan! "



# MEMBUAT FOLDER WORKSPACE BUILD TWRP DI GITPOD ( anda bisa ubah direktori ini sesuka hati anda dimana tempat nya )

mkdir ${di_build}
cd ${di_build}
 
 
 # Mulai untuk melakukan sync
 
cd ${current_directory}
bot_notif
cd ${di_build}
echo " "
echo "  Build Environment "
echo " "

  git config --global user.name "Nico170420"
  git config --global user.email "b170420nc@gmail.com"

  if [ "${Build_Status}" = TWRP ]; then
  repo init --depth=1 -u ${Link} -b twrp-${Manifest_branch}
  elif [ "${Build_Status}" = PBRP ]; then
  repo init --depth=1 -u ${Link} -b android-${Manifest_branch}
  elif [ "${Build_Status}" = SHRP ]; then
  repo init --depth=1 -u ${Link} -b shrp-${Manifest_branch}
  else
  echo "$Build_Status Gagal"
  fi


        # Cloning Device tree
        echo " "
        echo " Cloning Device Tree "
        echo " "
        git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}
        
        if [ -n "${Common}" ] && [ -n "${Path_Common}" ]; then
       git clone ${Common} -b ${Branch_dt_twrp} ${Path_Common}
         
        fi
        
        
        
        # Build dimulai
        
        echo " "
        cd ${current_directory}
        bot_notif2
        cd ${di_build}
        if [ "${Manifest_branch}" = 12.1 ]; then
        echo " Terdeteksi manifest 12"
        echo " Memperbaiki ATOMIC FAILED "
        cp -r ${current_directory}/graphics_drm.cpp ${di_build}/bootable/recovery/minuitwrp/
        fi
        clear
        echo " Building Recovery "
        echo " "
        sleep 1
        cd ${di_build}
        
        export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; lunch twrp_${Lunch}-eng; make ${Build_Target}image 
         
        
        
        # Pemeriksaan Hasil Build
         if [ "${Build_Target}" = "vendorboot" ]; then
         if [ -e "${di_build}/out/target/product/${Out}/vendor_boot.img" ]; then  
         cp -r ${di_build}/out/target/product/${Out}/vendor_boot.img ${current_directory}
         
         elif [ -e "${di_build}/out/target/product/${Device_Name}/vendor_boot.img" ]; then     
        cp ${di_build}/out/target/product/${Device_Name}/vendor_boot.img ${current_directory}
        
        elif [ -e "${di_build}/out/target/product/${Lunch}/vendor_boot.img" ]; then
        cp ${di_build}/out/target/product/${Lunch}/vendor_boot.img ${current_directory}
         else
         echo " "
         echo " FILE HASIL BUILD TIDAK DITEMUKAN SEPERTINYA ADA MASALAH"
         echo " "
         bot_error
         main
         fi
           
         else
         
         
         if [ -e "${di_build}/out/target/product/${Out}/${Build_Target}.img" ]; then
         cp -r ${di_build}/out/target/product/${Out}/${Build_Target}.img ${current_directory}
         
         elif [ -e "${di_build}/out/target/product/${Device_Name}/${Build_Target}.img" ]; then
        cp ${di_build}/out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}
        
        elif [ -e "${di_build}/out/target/product/${Lunch}/${Build_Target}.img" ]; then
        cp ${di_build}/out/target/product/${Lunch}/${Build_Target}.img ${current_directory}
        
           else
           echo " "
           echo "FILE HASIL BUILD TIDAK DITEMUKAN SEPERTINYA ADA MASALAH  "
           echo " "
           bot_error
            main
            fi   
        fi
        
        
        
        # Memindahkan hasil build dari root dir ke workspace gitpod
echo " DONE BUILD!!! "
cd ${current_directory}
if [ "${Build_Target}" = "vendorboot" ]; then
mv vendor_boot.img ${Build_Status}_${Device_Name}_vendor_boot.img
echo " "
echo " Mengkompress File menjadi lebih kecil..."
xz ${Build_Status}_${Device_Name}_vendor_boot.img
echo " "
else
echo " "
echo " Mengkompress File menjadi lebih kecil..."
mv ${Build_Target}.img ${Build_Status}_${Device_Name}_${Build_Target}.img
xz ${Build_Status}_${Device_Name}_${Build_Target}.img
echo " "
fi

if [ -n "${id_chat}" ] && [ -n "${id_topic}" ]; then
bot_file_topic
else
bot_file
fi

upload
main #kembali ke menu
}

##############################################################
##############################################################
##############################################################
##############################################################


#Fungsi Rebuild 

ReAosp()
{


# memeriksa workspace

source ${current_directory}/save_settings.txt
if [ -n ${Manifest_branch} ] || [ "${Build_Status}" = "TWRP" ]; then
sed -i "s|Build_Status=.*|Build_Status=TWRP|" ${current_directory}/save_settings.txt

# Permintaan Pilihan ke Pengguna
echo "Memanggil Konfigurasi yang Tersimpan"
source ${current_directory}/save_settings.txt
echo "Ingin ubah konfigurasi tersimpan?"
echo "1. Ya"
echo "2. Tidak"
read -p "Pilih (1-2): " settings


# Mendeteksi Pilihan dari Perubahan konfigurasi

if [ "${settings}" = 1 ]; then  # Jika Pilihan 1 dijalan kan #
  


#+++++++++++++++++++++++++ AWAL REAOSP PILIHAN 1 ++++++++++++++++++++#



echo " "
echo " Link Device Tree TWRP [wajib] : "
read Device_tree
if [ -z "${Device_tree}" ]; then
    echo "Input Device tree Kosong !"
    echo " "
    main
    fi
echo " "
echo "Branch Device_tree_twrp [wajib]: "
read Branch_dt_twrp
if [ -z "${Branch_dt_twrp}" ]; then
    echo "Input branch device tree Kosong !"
    echo " "
    main
fi
echo " "
echo "Device Path [wajib]: "
read Device_Path
if [ -z "${Device_Path}" ]; then
    echo "Input Device path Kosong!"
    echo " "
    main
fi
echo " "
echo "Device Name [wajib]: "
read Device_Name
if [ -z "${Device_Name}" ]; then
    echo "Input Device Name Kosong!"
    echo " "
    main
fi
echo " "
echo " Run Lunch target Twrp (Isi nama setelah twrp_ (x657b untuk twrp_x657b)"
read Lunch
if [ -z "${Lunch}" ]; then
    echo "Input Lunch Kosong!"
    echo " "
    main
    
fi

echo " "
echo "Build Target ( recovery / boot / vendorboot ) [wajib]: "
read Build_Target
 if [ -z "${Build_Target}" ]; then
    echo "Input Build Target Kosong!"
    echo " "
    main
   
fi
 if [ "${Build_Target}" != "recovery" ] && [ "${Build_Target}" != "boot" ] && [ "${Build_Target}" != "vendorboot" ]; then
   echo ""
   echo "Sepertinya  Build Target tidak cocok, yang kamu ketik saat ini adalah ${Build_Target}"
   echo " "
   main
   fi
echo " "
echo " Link_Device_Tree_Common "
read Common
echo " "
echo " Device_Path_Common "
read Path_Common

if [ -n "${Common}" ] && [ -z "${Path_Common}" ]; then
echo " "
echo " Device tree common Terisi!, Tetapi Path Common Kosong"
main
fi

if [ -z "${Common}" ] && [ -n "${Path_Common}" ]; then
echo " "
echo " Patch common Terisi, Tetapi Device tree common kosong "
main
fi




echo " "
echo " Mendeteksk Out Target File... "
Out=$(basename "$Device_Path")
sed -i "s|Out=.*|Out=$Out|" ${current_directory}/save_settings.txt
sleep 1





 sed -i "s|Device_tree=.*|Device_tree=$Device_tree|" ${current_directory}/save_settings.txt
sed -i "s|Branch_dt_twrp=.*|Branch_dt_twrp=$Branch_dt_twrp|" ${current_directory}/save_settings.txt
sed -i "s|Device_Path=.*|Device_Path=$Device_Path|" ${current_directory}/save_settings.txt
sed -i "s|Device_Name=.*|Device_Name=$Device_Name|" ${current_directory}/save_settings.txt
sed -i "s|Build_Target=.*|Build_Target=$Build_Target|" ${current_directory}/save_settings.txt
sed -i "s|Lunch=.*|Lunch=$Lunch|" ${current_directory}/save_settings.txt

if [ -n "${Common}" ] && [ -n "${Path_Common}" ]; then
sed -i "s|Common=.*|Common=$Common|" ${current_directory}/save_settings.txt
sed -i "s|Path_Common=.*|Path_Common=$Path_Common|" ${current_directory}/save_settings.txt
fi

    echo " Diperbarui!"
sleep 1


echo "Memeriksa ketersediaan Manifest..."
sleep 1

    
    # Menghapus Cloning device tree yang telah ada sebelumnya
    if [ -d "${di_build}" ]; then
    echo " "
    echo "Manifest tersedia Menghapus beberapa file..."
   if  [ -e "${current_directory}/${Build_Status}_${Device_Name}_vendor_boot.img.xz" ]; then
    rm -rf ${current_directory}/${Build_Status}_${Device_Name}_vendor_boot.img.xz
fi
if [ -e "${current_directory}/${Build_Status}_${Device_Name}_${Build_Target}.img.xz" ]; then
rm -rf ${current_directory}/${Build_Status}_${Device_Name}_${Build_Target}.img.xz
fi

if [ -n "${Path_Common}" ]; then   
rm -rf ${di_build}/${Path_Common}
fi
    rm -rf ${di_build}/${Device_Path}
   rm -rf ${di_build}/out/target/product/${Out}

   else
   echo " "
   echo " Sepertinya Manifest tidak ada Mengulangi sync manifest..."
   
   mkdir ${di_build}
   cd ${di_build}
  if [ "${Build_Status}" = "TWRP" ]; then
  Link=https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git
  repo init --depth=1 -u ${Link} -b twrp-${Manifest_branch}
  elif [ "${Build_Status}" = "PBRP" ]; then
  Link=https://github.com/PitchBlackRecoveryProject/manifest_pb
  repo init --depth=1 -u ${Link} -b android-${Manifest_branch}
  elif [ "${Build_Status}" = "SHRP" ]; then
  Link=https://github.com/SHRP-Reborn/manifest.git
  repo init --depth=1 -u ${Link} -b shrp-${Manifest_branch}
  else
  echo "$Build_Status Gagal"
  fi
        
  repo sync --force-sync
  fi



# Memanggil Konfigurasi Yang tersimpan
    source ${current_directory}/save_settings.txt

cd ${di_build}
echo " "
if [ "${Manifest_branch}" = 12.1 ]; then
echo " Terdeteksi manifest 12"
echo " Memperbaiki ATOMIC FAILED "
cp -r ${current_directory}/graphics_drm.cpp ${di_build}/bootable/recovery/minuitwrp/
fi
echo " Cloning Device tree "
echo " "

# Clone device tree

git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}

        if [ -n "${Common}" ] && [ -n "${Path_Common}" ]; then
       git clone ${Common} -b ${Branch_dt_twrp} ${Path_Common}
      
fi



        sleep 1
        cd ${current_directory}
        bot_notif2
        cd ${di_build}
        clear
        # BUILD DIMULAI
        echo " "
        echo " BUILDING TWRP "
        echo " "
        # Start Building 
        cd ${di_build}

        export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; lunch twrp_${Lunch}-eng; make ${Build_Target}image 
         
       
       
       
       
       
       
       
        # MEMERIKSA FILE LALU MENYALIN FILE KE WORKSPACE 
          
         if [ "${Build_Target}" = "vendorboot" ]; then
            if [ -e "${di_build}/out/target/product/${Out}/vendor_boot.img" ]; then
              cp -r ${di_build}/out/target/product/${Out}/vendor_boot.img ${current_directory}
        elif [ -e "${di_build}/out/target/product/${Device_Name}/vendor_boot.img" ]; then  
           cp ${di_build}/out/target/product/${Device_Name}/vendor_boot.img ${current_directory}
        elif [ -e "${di_build}/out/target/product/${Lunch}/vendor_boot.img" ]; then
           cp ${di_build}/out/target/product/${Lunch}/vendor_boot.img ${current_directory}
              
       else
         echo " "
         echo " FILE HASIL BUILD TIDAK DITEMUKAN SEPERTINYA ADA MASALAH"
         echo " "
         bot_error
         main
         fi
                         
       else
         
         
         if [ -e "${di_build}/out/target/product/${Out}/${Build_Target}.img" ]; then
         cp -r ${di_build}/out/target/product/${Out}/${Build_Target}.img ${current_directory}   
         elif [ -e "${di_build}/out/target/product/${Device_Name}/${Build_Target}.img" ]; then
         
        cp ${di_build}/out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}
        elif [ -e "${di_build}/out/target/product/${Lunch}/${Build_Target}.img" ]; then
        cp ${di_build}/out/target/product/${Lunch}/${Build_Target}.img ${current_directory}
           else
           echo " "
           echo "FILE HASIL BUILD TIDAK DITEMUKAN SEPERTINYA ADA MASALAH  "
           echo " "
           bot_error
            main
            fi   
        fi
        
        
        
        
        
        
        # MENGUBAH NAMA FILE DAN MENGKOMPRESS FILE
        
        echo " DONE BUILD ! "
        echo " "
cd ${current_directory}
if [ "${Build_Target}" = "vendorboot" ]; then
mv vendor_boot.img ${Build_Status}_${Device_Name}_vendor_boot.img
echo " "
echo " Mengkompress file menjadi lebih kecil... "
xz ${Build_Status}_${Device_Name}_vendor_boot.img
echo " "
else
mv ${Build_Target}.img ${Build_Status}_${Device_Name}_${Build_Target}.img
echo " "
echo " Mengkompress file menjadi lebih kecil..."
xz ${Build_Status}_${Device_Name}_${Build_Target}.img
echo " "
    fi
    
if [ -n "${id_chat}" ] && [ -n "${id_topic}" ]; then
bot_file_topic
else
bot_file
fi


    upload
   
   #---------------------------------------------------- AKHIR AOSP PILIHAN 1 ------------------------------------------#
    
main
elif [ "${settings}" = 2 ]; then 

   #+++++++++++++++++++++++++++++++++ AWAL AOSP PILIHAN 2 +++++++++++++++++++++++++#



# Memanggil konfigurasi yang tersimpan

    source ${current_directory}/save_settings.txt

    
echo "Memeriksa ketersediaan Manifest..."
sleep 1

    
    # Menghapus Cloning device tree yang telah ada sebelumnya
    if [ -d "${di_build}" ]; then
    echo " "
    echo "Manifest tersedia Menghapus beberapa file..."
   if  [ -e "${current_directory}/${Build_Status}_${Device_Name}_vendor_boot.img.xz" ]; then
    rm -rf ${current_directory}/${Build_Status}_${Device_Name}_vendor_boot.img.xz
fi
if [ -e "${current_directory}/${Build_Status}_${Device_Name}_${Build_Target}.img.xz" ]; then
rm -rf ${current_directory}/${Build_Status}_${Device_Name}_${Build_Target}.img.xz
fi

if [ -n "${Path_Common}" ]; then   
rm -rf ${di_build}/${Path_Common}
fi
    rm -rf ${di_build}/${Device_Path}
   rm -rf ${di_build}/out/target/product/${Out}

   else
   echo " "
   echo " Sepertinya Manifest tidak ada Mengulangi sync manifest..."
   
   mkdir ${di_build}
   cd ${di_build}
  if [ "${Build_Status}" = "TWRP" ]; then
  Link=https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git
  repo init --depth=1 -u ${Link} -b twrp-${Manifest_branch}
  elif [ "${Build_Status}" = "PBRP" ]; then
  Link=https://github.com/PitchBlackRecoveryProject/manifest_pb
  repo init --depth=1 -u ${Link} -b android-${Manifest_branch}
  elif [ "${Build_Status}" = "SHRP" ]; then
  Link=https://github.com/SHRP-Reborn/manifest.git
  repo init --depth=1 -u ${Link} -b shrp-${Manifest_branch}
  else
  echo "$Build_Status Gagal"
  fi
