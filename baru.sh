
main_menu() {
#!/bin/bash

while true; do
  echo " "
  echo "--------------Builder Custom Recovery by Massatrio16 -----------"
  echo "0. Exit "
  echo "1. New Build for Aosp (sync minimal manifest)"
  echo "2. Rebuild for Aosp ( No need sync minimal manifest)"
  echo "3. New Build For Ofox (Sync Minimal Manifest) "
  echo "4. Rebuild for ofox ( No need sync Minimal Manifest)"
  echo "5. Setting Notification Telegram & Upload File (Recommended)"
  echo "6. Delete All Resources Sync Manifest "
  echo "7. Clean resources "     
  echo " "
  read -p "Pilih : " pilihan
  case $pilihan in
    1) twrp ;;
    2) retwrp ;;
    3) ofox ;;
    4) reofox ;;
    5) bot_config ;;
    6) delete ;;
    0) echo "Bye!"; break ;;
    *) echo "Menu tidak ada!" ;;
  esac
  unset pilihan
  echo ""
done

}

ask_build() {
source ${current_directory}/save_settings.txt

echo " Minimal Manifest Tersedia "
echo "1. 11"
echo "2. 12.1"
echo "3. 14"
echo "4. 14.1"

read -p "minimal manifest branch : " pilihan
  case $pilihan in
    1) minimal_manifest=11 ;;
    2) minimal_manifest=12.1 ;;
    3) minimal_manifest=14 ;;
    4) minimal_manifest=14.1 ;;
    *) echo "Menu tidak ada!"; main_menu ;;
  esac
  unset pilihan
  echo ""

echo " Masukkan Link Device tree Anda ! "
read -p " Link : " device_tree
if [ -z device_tree ]; then 
echo "Tidak Boleh Kosong!"
main_menu
fi

echo ""
echo " Masukkan Branch Debuce Tree anda ! "
read -p " Branch DT : " branch_dt
if [ -z branch_dt ]; then 
echo "Tidak Boleh Kosong!"
main_menu
fi

echo ""
echo " Masukkan Device Path BoardConfig !"
read -p "Device Path : " device_path
if [ -z device_path ]; then 
echo "Tidak Boleh Kosong!"
main_menu
fi

echo ""
echo " Masukkan Device Name Android.mk !"
read -p "Device Name : " device_name
if [ -z device_name ]; then 
echo "Tidak Boleh Kosong!"
main_menu
fi

echo ""
echo " Masukkan Device lunch! "
echo " contoh X657B untuk twrp_X657B.mk"
read -p " Lunch Name : " lunch
if [ -z lunch ]; then 
echo "Tidak Boleh Kosong!"
main_menu
fi

echo ""
echo " Target Partisi Build"
echo "1. recovery"
echo "2. boot"
echo "3. Vendor Boot"
read -p "Pilih : " pilihan
  case $pilihan in
    1) partition=recovery ;;
    2) partition=boot ;;
    3) partition=vendorboot ;;
    *) echo "Tidak ada di menu"; main_menu ;;
  esac
  unset pilihan

echo ""
echo " Masukkan Link Device Tree Common "
read -p " Link : " common
echo " "
echo " Masukkan Device Path Common "
read -p " Path to common : " path_common

if [ -n "${common}" ] && [ -z "${path_common}" ]; then
echo " "
echo " Device tree common Terisi!, Tetapi Path Common Kosong"
main_menu
fi

if [ -z "${common}" ] && [ -n "${path_common}" ]; then
echo " "
echo " Patch common Terisi, Tetapi Device tree common kosong "
main_menu
fi

echo " "
echo " Mendeteksk Out Target File... "
out=$(basename "$device_path")
sed -i "s|out=.*|out=$out|" ${current_directory}/save_settings.txt
sleep 1

echo ""

echo " "
echo "Menyimpan Konfigurasi..."
echo " "
sed -i "s|minimal_manifest=.*|minimal_manifest=$minimal_manifest|" ${current_directory}/save_settings.txt
sed -i "s|device_tree=.*|device_tree=$device_tree|" ${current_directory}/save_settings.txt
sed -i "s|branch_dt=.*|branch_dt=$branch_dt|" ${current_directory}/save_settings.txt
sed -i "s|device_path=.*|device_path=$device_path|" ${current_directory}/save_settings.txt
sed -i "s|device_name=.*|device_name=$device_name|" ${current_directory}/save_settings.txt
sed -i "s|partition=.*|partition=$partition|" ${current_directory}/save_settings.txt
sed -i "s|lunch=.*|lunch=$lunch|" ${current_directory}/save_settings.txt
if [ -n "${common}" ] && [ -n "${path_common}" ]; then
sed -i "s|common=.*|common=$common|" ${current_directory}/save_settings.txt
sed -i "s|path_common=.*|path_common=$path_common|" ${current_directory}/save_settings.txt
fi

echo " "
echo " Tersimpan! "

}


sync_minimal_manifest() {
source ${current_directory}/save_settings.txt
mkdir -p $build_dir
cd $build_dir

# KIRIM Notif Kesini
bot_notif
# END

echo " "
echo "  Build Environment "
echo " "
git config --global user.name "Nico170420"
git config --global user.email "b170420nc@gmail.com"

# Jika Build Bukan Orangefox
if [ "${build_status}" != Orangefox ]; then
    if [ "${build_status}" = TWRP ]; then
       repo init --depth=1 -u "${Link}" -b twrp-${minimal_manifest}
    elif [ "${build_status}" = PBRP ]; then
       repo init --depth=1 -u "${Link}" -b android-${minimal_manifest}
    elif [ "${build_status}" = SHRP ]; then
       repo init --depth=1 -u "${Link}" -b shrp-${minimal_manifest}
    else
       echo "$build_status Gagal"
    fi
    repo sync
    
else
# BUILD ORANGEFOX
    git clone https://gitlab.com/OrangeFox/misc/scripts.git
    cd scripts
    sudo bash setup/android_build_env.sh
    cd ${build_dir}
    git clone https://gitlab.com/OrangeFox/sync.git
    cd sync
    ./orangefox_sync.sh --branch ${minimal_manifest}
  
fi

}


build_minimal_manifest() {
source ${current_directory}/save_settings.txt
echo " "

if [ "${build_status}" != Orangefox ]; then
     cd ${build_dir}
else
     cd ${build_dir}/sync/fox_${minimal_manifest}
fi

# FIX ATOMIC FAILED UI 12+
if [ "${minimal_manifest}" != 11 ]; then
        echo " Terdeteksi manifest 12+"
        echo " Memperbaiki ATOMIC FAILED "
        
        #JIKA BUKAN ORANGEFOX
        if [ "${build_status}" != Orangefox ]; then 
            cp -r ${current_directory}/graphics_drm.cpp ${build_dir}/bootable/recovery/minuitwrp/
        else
        # ORANGEFOX
            cp -r ${current_directory}/graphics_drm.cpp  ${build_dir}/sync/fox_${minimal_manifest}/bootable/recovery/minuitwrp/
        fi
fi

# KIRIM NOTIF KESINI
bot_notif_2
#END

echo " "
echo " Cloning Device Tree "
echo " "

# CLONING DEVICE TREE
git clone ${device_tree} -b ${branch_dt} ${device_path}

# CLONING DEVICE COMMON TREE
if [ -n "${common}" ] && [ -n "${path_common}" ]; then
  git clone ${common} -b ${branch_dt} ${path_common}
fi

# BUILD KETIKA BUKAN MINIMAL MANIFEST 14 / 14.1
if [ "${minimal_manifest}" != 14  ] || [ "${minimal_manifest}" != 14.1  ]; then
    export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; lunch twrp_${Lunch}-eng; make ${Build_Target}image -j$(nproc --all)
else
#BUILD KETIKA MINIMAL MANIFEST 14 / 14.1
    export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; lunch twrp_${Lunch}-ap2a-eng; make ${Build_Target}image -j$(nproc --all)
fi

}


check_build() {
source ${current_directory}/save_settings.txt
# Jika Bukan Orangefox 
if [ "${build_status}" != Orangefox ]; then
            # Pemeriksaan Hasil Build
       
    # JIKA PARTISI ADALAH VENDOR BOOT
    if [ "${partition}" = "vendorboot" ]; then
    
          # MENGECEK APAKAH FILE TERSEBUT ADA?
          
         if [ -e "${build_dir}/out/target/product/${out}/vendor_boot.img" ]; then  
              cp -r ${build_dir}/out/target/product/${out}/vendor_boot.img ${current_directory}
         
         elif [ -e "${build_dir}/out/target/product/${device_name}/vendor_boot.img" ]; then     
              cp ${build_dir}/out/target/product/${device_name}/vendor_boot.img ${current_directory}
        
        elif [ -e "${build_dir}/out/target/product/${lunch}/vendor_boot.img" ]; then
              cp ${build_dir}/out/target/product/${lunch}/vendor_boot.img ${current_directory}
        else
        # FILE TIDAK ADA
              echo " "
              echo " FILE HASIL BUILD TIDAK DITEMUKAN SEPERTINYA ADA MASALAH"
              echo " "
              # KIRIM NOTIF ERROR
              bot_error
              # END
              main_menu
         fi
    
    else
    # JIKA PARTISI ADALAH BOOT / RECOVERY 
    
         # MENGECEK APAKAH FILE TERSEBUT ADA?
         if [ -e "${build_dir}/out/target/product/${out}/${partition}.img" ]; then
             cp -r ${build_dir}/out/target/product/${out}/${partition}.img ${current_directory}
         
         elif [ -e "${build_dir}/out/target/product/${device_name}/${partition}.img" ]; then
             cp ${build_dir}/out/target/product/${device_name}/${partition}.img ${current_directory}
        
        elif [ -e "${build_dir}/out/target/product/${lunch}/${partition}.img" ]; then
             cp ${di_build}/out/target/product/${lunch}/${partition}.img ${current_directory}
        
        else
        # FILE TIDAK DITEMUKAN
              echo " "
              echo "FILE HASIL BUILD TIDAK DITEMUKAN SEPERTINYA ADA MASALAH  "
              echo " "
              # KIRIM NOTIF ERROR
              bot_error
              #END
              main_menu
        fi   
    fi
    
    echo " DONE BUILD ! "
    echo " "
    cd ${current_directory}
    # JIKA PARTISI ADALAH VENDOR BOOT
    if [ "${partition}" = "vendorboot" ]; then
        mv vendor_boot.img ${build_status}_${device_name}_vendor_boot.img
        echo " "
        echo " Mengkompress file menjadi lebih kecil... "
        xz ${build_status}_${device_name}_vendor_boot.img
       echo " "
    else
   # JIKA PARTISI SELAIN VENDOR BOOT
       mv ${partition}.img ${build_status}_${device_name}_${partition}.img
       echo " "
       echo " Mengkompress file menjadi lebih kecil..."
       xz ${build_status}_${device_name}_${partition}.img
       echo " "
    fi
    
    # KIRIM FILE BUILD
    bot_file
    upload
    #END

else
# JIKA BUILD ORANGEFOX
         
         # MENGECEK FILE APAKAH ADA?
     if [ -e ${build_dir}/sync/fox_${minimal_manifest}/out/target/product/${out}/OrangeFox*.img ]; then
         cp -r ${build_dir}/sync/fox_${minimal_manifest}/out/target/product/${out}/OrangeFox*.img ${current_directory}
         cp -r ${build_dir}/sync/fox_${minimal_manifest}/out/target/product/${out}/OrangeFox*.zip ${current_directory}       
     
     elif [ -e ${build_dir}/ofox/sync/fox_${minimal_manifest}/out/target/product/${device_name}/OrangeFox*.img ]; then
         cp ${build_dir}/ofox/sync/fox_${minimal_manifest}/out/target/product/${device_name}/OrangeFox*.img ${current_directory}
         cp ${build_dir}/ofox/sync/fox_${minimal_manifest}/out/target/product/${device_name}/OrangeFox*.zip ${current_directory}
        
    elif [ -e ${build_dir}/ofox/sync/fox_${minimal_manifest}/out/target/product/${lunch}/OrangeFox*${lunch}.img ]; then
         cp ${build_dir}/ofox/sync/fox_${minimal_manifest}/out/target/product/${Lunch}/OrangeFox*.img ${current_directory}
         cp ${build_dir}/ofox/sync/fox_${minimal_manifest}/out/target/product/${Lunch}/OrangeFox*.zip ${current_directory}
    
    else
          echo " "
          echo "FILE HASIL BUILD TIDAK DITEMUKAN SEPERTINYA ADA MASALAH  "
          echo " "
          # KIRIM NOTIF ERROR
          bot_error
          #END
          main_menu
      
    fi  
    
    echo " "
    echo " DONE BUILD!!! "
    cd ${current_directory}
    echo " "
    echo " Kompresi File menjadi lebih kecil ..."
    xz OrangeFox*.img
    mv OrangeFox*.xz OrangeFox-Unofficial_${device_name}.img.xz
    mv OrangeFox*.zip OrangeFox_Installer_${device_name}.zip
    echo " "
    # KIRIM FILE BOT
    bot_file
    upload
    #END
    
    
    
fi



}

bot_config() {

source ${current_directory}/save_settings.txt

    echo " ---- Notification / Upload Configuration ---- "
    echo " "
    echo "Token Bot Telegram Telah diatur default sebagai bot owner script"
    echo "Chat id dan Apikey Pixeldrain blum di Atur!"
    echo "1. Atur Ulang Token"
    echo "2. Atur Chat id "
    echo "3. Atur Apikey "
    read -p " Pilih ( 1-3 ) : " setcon
    
    case $setcon in
    1) 
        echo " Masukkan Token Custom Anda !"
        read -p " Token : " token
        if [ -z "${token}" ]; then
           echo " "
           echo " Token Kosong !"
           echo " "
           return
        else
           sed -i "s|token=.*|token=$token|" ${current_directory}/save_settings.txt
           echo " "
           echo " Token Disimpan ! "
           echo " " 
         fi
        ;;
    2) 
        echo " "
        echo " Masukkan Id chat Anda ! "
        read -p "Chat Id : " chat_id
        echo " Mashkkan id topik anda ! "
        read -p " Topik id : " topik_id
        if [ -z "${chat_id}" ]; then
            echo " "
            echo " Chat id kosong ! "
            return
        elif [ -n "${topik_id}" ]; then
            sed -i "s|chat_id=.*|chat_id=$chat_id|" ${current_directory}/save_settings.txt
            sed -i "s|topik_id=.*|topik_id=$topik_id|" ${current_directory}/save_settings.txt
            echo " "
            echo " Chat id dan Topik id disimpan!"
        else
            sed -i "s|chat_id=.*|chat_id=$chat_id|" ${current_directory}/save_settings.txt
            echo " "
            echo " Hanya chat id disimpan!"

        fi
    ;;
    3)
        echo " "
        echo " Masukkan Api Key Pixeldrain untuk upload ke Penyimpanan anda ! "
        read -p " Apikey : " apikey
        if [ -z "${apikey}" ]; then
             echo " "
             echo " Apikey kosong ! "
             return
        else
             sed -i "s|apikey=.*|apikey=$apikey|" ${current_directory}/save_settings.txt
             echo " "
             echo " Apikey disimpan! "

        fi
    ;;
    
    *) 
        echo " "
        echo " Tidak ada di Menu ! "
        return
    ;;
    esac
    echo ""  
        
}


bot_notif() {
source ${current_directory}/save_settings.txt

    if [ -z "${chat_id}" ]; then
       echo " "
       echo " Chat id Tidak diatur, Melewati kirim notifikasi !"
       echo " "
    elif [ -n "${chat_id}" ] && [ -n "${topik_id}" ]; then
       curl -F "chat_id=${chat_id}" \
       -F "message_thread_id=${topik_id}" \
       -F "text=Melakukan Repo sync Minimal Manifest ${build_status} ${minimal_manifest}" \
       https://api.telegram.org/bot${token}/sendMessage
    else
       echo " "
       echo " "
       curl -X POST "https://api.telegram.org/bot${token}/sendMessage" -d "chat_id=${chat_id}&text=Melakukan Repo sync Minimal Manifest ${build_status} ${minimal_manifest}"
        echo " "
    fi

}


bot_notif_2() {
source ${current_directory}/save_settings.txt

     if [ -z "${chat_id}" ]; then
         echo " "
         echo " chat id Tidak diatur, Melewati kirim notifikasi !"
         echo " "
     elif [ -n "${chat_id}" ] && [ -n "${topik_id}" ]; then
         curl -F "chat_id=${chat_id}" \
         -F "message_thread_id=${topik_id}" \
         -F "text=Membangun ${build_status}_${device_name}" \
         https://api.telegram.org/bot${token}/sendMessage
     else
         echo " "
         curl -X POST "https://api.telegram.org/bot${token}/sendMessage" -d "chat_id=${chat_id}&text= Membangun ${build_status}_${device_name}..."
         echo " "
     fi


}

bot_file() {
source ${current_directory}/save_settings.txt

    # JIKA CHAT ID DAN TOPIK ID TERISI
    if [ -n "${chat_id}" ] && [ -n "${topik_id}" ]; then

         # JIKA BUILD BUKAN ORANGEFOX
         if [ "${build_status}" != Orangefox ]; then 
               # JIKA PARTISI ADALAH VENDOR BOOT
                if [ "${partition}" = "vendorboot" ]; then
                     chmod a+x ${current_directory}/${build_status}_${device_name}_vendor_boot.img.xz
                     curl -F "chat_id=${chat_id}" \
                     -F "message_thread_id=${topik_id}" \
                     -F "text=SUKSES BUILD ${build_status} ${device_name}" \
                     https://api.telegram.org/bot${token}/sendMessage
                     echo " "
                     curl -F "chat_id=${chat_id}" \
                    -F "message_thread_id=${topik_id}" \
                    -F "document=@${current_directory}/${build_status}_${device_name}_vendor_boot.img.xz" \
                    https://api.telegram.org/bot${token}/sendDocument
                     echo " "
                else
                # JIKA PARTISI SELAIN VENDOR_BOOT
                     chmod a+x ${current_directory}/${build_status}_${device_name}_${partition}.img.xz
                     echo " "
                     curl -F "chat_id=${chat_id}" \
                     -F "message_thread_id=${topik_id}" \
                     -F "text=SUKSES BUILD ${build_Status} ${device_name}" \
                      https://api.telegram.org/bot${token}/sendMessage
                      echo " "
                      curl -F "chat_id=${chat_id}" \
                      -F "message_thread_id=${topik_id}" \
                      -F "document=@${current_directory}/${build_status}_${device_name}_${partition}.img.xz" \
                      https://api.telegram.org/bot${token}/sendDocument
                      echo " "
                fi
         else
         #JIKA BUILD ORANGEFOX
                curl -F "chat_id=${chat_id}" \
                -F "message_thread_id=${topik_id}" \
                -F "text=SUKSES BUILD ${build_status} ${device_name}" \
                 https://api.telegram.org/bot${token}/sendMessage
                 echo " "
                 curl -F "chat_id=${chat_id}" \
                 -F "message_thread_id=${topik_id}" \
                 -F "document=@${current_directory}/OrangeFox-Unofficial_${device_name}.img.xz" \
                 https://api.telegram.org/bot${token}/sendDocument
                 curl -F "chat_id=${chat_id}" \
                 -F "message_thread_id=${topik_id}" \
                 -F "document=@${current_directory}/OrangeFox_Installer_${device_name}.zip" \
                  https://api.telegram.org/bot${token}/sendDocument
         fi
    
    # JIKA HANYA CHAT ID YANH TERISI
    elif  [ -n "${chat_id}" ] && [ -z "${topik_id}" ]; then
    
         # JIKA BUKAN BUILD ORANGEFOX 
         if [ "${build_status}" != Orangefox ]; then
                 
                  # JIKA PARTISI VENDOR BOOT
                 if [ "${partition}" = "vendorboot" ]; then
                        chmod a+x ${current_directory}/${build_status}_${device_name}_vendor_boot.img.xz
                        curl -X POST "https://api.telegram.org/bot${token}/sendMessage" -d "chat_id=${chat_id}&text= SUKSES BUILD ${build_status}_${device_name}!"
                        echo " "
                        curl -F document=@"${current_directory}/${build_status}_${device_name}_vendor_boot.img.xz" https://api.telegram.org/bot${token}/sendDocument?chat_id=${chat_id}
                        echo " "
                 else
                        chmod a+x ${current_directory}/${build_status}_${device_name}_${partition}.img.xz
                        echo " "
                        curl -X POST "https://api.telegram.org/bot${token}/sendMessage" -d "chat_id=${chat_id}&text= Sukses Build ${build_status}_${device_name}!"
                        echo " "
                        curl -F document=@"${current_directory}/${build_status}_${device_name}_${partition}.img.xz" https://api.telegram.org/bot${token}/sendDocument?chat_id=${chat_id}
                 fi
         else
                  echo " "
                  chmod a+x ${current_directory}/OrangeFox-Unofficial_${device_name}.img.xz
                  curl -F document=@"${current_directory}/OrangeFox-Unofficial_${device_name}.img.xz" https://api.telegram.org/bot${token}/sendDocument?chat_id=${chat_id}
                  curl -F document=@"${current_directory}/OrangeFox_Installer_${device_name}.zip" https://api.telegram.org/bot${token}/sendDocument?chat_id=${chat_id}
                  echo " "
                  echo " "
         fi
                  
    else
    
         echo " CHAT ID TIDAK DIMASUKKAN , SKIPP KIRIM "
    fi



}



bot_error() { 
source ${current_directory}/save_settings.txt

    if [ -z "${chat_id}" ]; then
         echo " "
         echo " chat_id Tidak diatur, Melewati kirim notifikasi !"
         echo " "
    elif [ -n "${chat_id}" ] && [ -n "${topik_id}" ]; then
         curl -F "chat_id=${chat_id}" \
         -F "message_thread_id=${topik_id}" \
         -F "text=FILE BUILD ${build_status}_${device_name} TIDAK DITEMUKAN, SEPERTINYA TERJADI MASALAH ERROR ATAU KESALAHAN SCRIPT HARAP PERIKSA KEMBALI DAN LIHAT LOG ERROR!" \
         https://api.telegram.org/bot${token}/sendMessage
    else

         echo " "
         curl -X POST "https://api.telegram.org/bot${token}/sendMessage" -d "chat_id=${chat_id}&text= FILE BUILD ${build_status}_${device_name} TIDAK DITEMUKAN, SEPERTINYA TERJADI MASALAH ERROR ATAU KESALAHAN SCRIPT HARAP PERIKSA KEMBALI DAN LIHAT LOG ERROR!"
        echo " "
    fi

}

upload() {
source ${current_directory}/save_settings.txt

     if [ -z "${apikey}" ]; then
         echo " "
         echo " Kamu Tidak mengatur Api Key pixeldrain, Skip Upload! "
         echo " "
     else
         echo " "
         echo " Mengupload Ke Pixeldrain "
         echo " "
         if [ "${build_status}" != Orangefox ]; then
         
               if [ "${partition}" = "vendorboot" ]; then
                      chmod a+x ${current_directory}/${build_status}_${device_name}_vendor_boot.img.xz
                      curl -T "${current_directory}/${build_status}_${device_name}_vendor_boot.img.xz" -u:${apikey} https://pixeldrain.com/api/file/
               else
                       echo " "
                       chmod a+x ${current_directory}/${build_status}_${device_name}_${partition}.img.xz
                       curl -T "${current_directory}/${build_status}_${device_name}_${partition}.img.xz" -u:${apikey} https://pixeldrain.com/api/file/
               fi
         else
                echo " "
                chmod a+x ${current_directory}/OrangeFox-Unofficial_${device_name}.img.xz
                curl -T "${current_directory}/OrangeFox-Unofficial_${device_name}.img.xz" -u:${apikey} https://pixeldrain.com/api/file/
         fi
         
     fi
             
     
}


ask_aosp() {
source ${current_directory}/save_settings.txt
    echo "Pilih Custom Recovery"
    echo "1. TWRP"
    echo "2. PBRP"
    echo "3. SHRP"
    read -p " Pilih Tipe Custom recovery : " tipe
    
    case $tipe in
        1) sed -i "s|build_status=.*|build_status=TWRP|" ${current_directory}/save_settings.txt ; Link=https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git ;;
         2) sed -i "s|build_status=.*|build_status=PBRP|" ${current_directory}/save_settings.txt ; Link=https://github.com/PitchBlackRecoveryProject/manifest_pb ;;
         3) sed -i "s|build_status=.*|build_status=SHRP|" ${current_directory}/save_settings.txt ; Link=https://github.com/SHRP-Reborn/manifest.git ;;
         *) echo "Tidak ada dipilihan !"; main_menu ;;
     esac
 
    sed -i "s|Link=.*|Link=$Link|" ${current_directory}/save_settings.txt

}


clean_up_file() {
source ${current_directory}/save_settings.txt
    
    if [ "${build_status}" != Orangefox ]; then
          echo " Menghapus file lama "
           if  [ -e "${current_directory}/${build_status}_${device_name}_vendor_boot.img.xz" ]; then
                 rm -rf ${current_directory}/${build_status}_${device_name}_vendor_boot.img.xz
           fi
           if [ -e "${current_directory}/${build_status}_${device_name}_${partition}.img.xz" ]; then
                 rm -rf ${current_directory}/${build_status}_${device_name}_${partition}.img.xz
           fi

           if [ -n "${path_common}" ]; then   
                 rm -rf ${build_dir}/${path_common}
           fi
           rm -rf ${build_dir}/${device_path}
           rm -rf ${build_dir}/out/target/product/${out}
           rm -rf ${build_dir}/out/target/product/${lunch}
           rm -rf ${build_dir}/out/target/product/${device_name}
    else
           if  [ -e ${current_directory}/OrangeFox-Unofficial_${device_name}.img.xz ]; then
                 rm -rf ${current_directory}/OrangeFox*.xz
                 rm -rf ${current_directory}/OrangeFox*.zip
           fi


           if [ -n "${path_common}" ]; then
                  rm -rf ${build_dir}/sync/fox_${minimal_manifest}/${path_common}
           fi
           rm -rf ${build_dir}/ofox/sync/fox_${minimal_manifest}/${device_path}
           rm -rf ${build_dir}/ofox/sync/fox_${minimal_manifest}/out/target/product/${lunch}
           rm -rf ${build_dir}/ofox/sync/fox_${minimal_manifest}/out/target/product/${out}
           rm -rf ${build_dir}/ofox/sync/fox_${minimal_manifest}/out/target/product/${device_name}
    fi
    
    
}



twrp() {

source ${current_directory}/save_settings.txt
    ask_aosp
    ask_build
    sync_minimal_manifest
    build_minimal_manifest
    check_build
    
 }




retwrp() {
source ${current_directory}/save_settings.txt
cd $build_dir

clean_up_file
build_minimal_manifest
check_build

}


ofox() {
source ${current_directory}/save_settings.txt
sed -i "s|build_status=.*|build_status=Orangefox|" ${current_directory}/save_settings.txt
ask_build
sync_minimal_manifest
build_minimal_manifest
check_build
}


reofox() {
source ${current_directory}/save_settings.txt
clean_up_file
build_minimal_manifest
check_build

}

clear
echo " "
echo " Menyimpan Folder saat ini... "
current_directory=$(pwd)
sed -i "s|current_directory=.*|current_directory=$current_directory|" save_settings.txt
echo " --- Memeriksa Package ---"
echo " "
if ! dpkg -l python3 gperf gcc-multilib gcc-10-multilib g++-multilib g++-10-multilib libc6-dev x11proto-core-dev libx11-dev tree lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc bc ccache lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-gtk3-dev libxml2 lzop pngcrush schedtool squashfs-tools imagemagick libbz2-dev lzma repo rsync ncftp qemu-user-static libstdc++-10-dev libtinfo5 &>/dev/null; then
    # Jika paket belum terinstal, jalankan perintah instalasi
    echo " Beberapa Package belum terinstall! "
    echo " "
    echo "Memulai Instalasi..."
    echo " "
    sleep 1
    sudo apt -y update
    sudo apt -y upgrade
 sudo apt -y install gperf gcc-multilib gcc-10-multilib g++-multilib g++-10-multilib libc6-dev x11proto-core-dev libx11-dev tree lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc bc ccache lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libxml2 lzop pngcrush schedtool squashfs-tools imagemagick libbz2-dev lzma ncftp qemu-user-static libstdc++-10-dev python3
   sudo apt -y install rsync
   sudo apt -y install repo


sleep 3
  fi
clear
cd ${current_directory}
git config --global user.name "Nico170420"
git config --global user.email "b170420nc@gmail.com"
main_menu