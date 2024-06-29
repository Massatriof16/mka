# BAGIAN FUNGSI

# Memanggil Direktori saat ini file dijalankan
current_directory=$(pwd)
###########################################################
###########################################################

bot() {
current_directory=${pwd}
source ${current_directory}/save_settings.txt


if [ "${Build_Target}" = "vendorboot" ]; then
curl -F document=@"${current_directory}/TWRP_${Device_Name}_vendor_boot.img" https://api.telegram.org/bot6788930639:AAHpp3siVn8wnWp3SGOM_uC2EDFaXWjyE6I/sendDocument?chat_id=6561499315
else
curl -F document=@"${current_directory}/TWRP_${Device_Name}_${Build_Target}.img" https://api.telegram.org/bot6788930639:AAHpp3siVn8wnWp3SGOM_uC2EDFaXWjyE6I/sendDocument?chat_id=6561499315
fi

}






# Fungsi Main


main() {

echo " "
echo "--------------Building TWRP-----------"
echo "1. New Build Aosp (sync minimal manifest)"
echo "2. Rebuild Aosp (don't sync minimal manifest)"
echo "3. New Build Omni (sync minimal manifest)"
echo "4. Rebuild Omni (don't sync minimal manifest"
echo "5. Exit "
echo " "
echo "Pilih ( 1 - 5 )"
read Main

# Mendeteksi Input pengguna
if [ "${Main}" = 1 ]; then ## Jika Pengguna Input 1 ##
Aosp
main
elif [ "${Main}" = 2 ]; then ## Jika Pengguna Input 2 ##
ReAosp
main
elif [ "${Main}" = 3 ]; then ## jika Pengguna Input 3 ##
Omni
main
elif [ "${Main}" = 4 ]; then ## Jika Pengguna input 4 ##
ReOmni
main
elif [ "${Main}" = 5 ]; then ## Jika pengguna input 5 ##
exit 0
else ## Jika pengguna Memasukkan selain pilihan ##
echo " "
echo " Invalid Karakter !!!!"
echo " "
main
fi
}

###########################################################
###########################################################

# Fungsi Dari Build Aosp
Aosp()
{

 
current_directory=$(pwd)
echo " "
echo " TWRP BUILD CONFIGURATION "
echo " "
# Membuat Folder twrp
 cd /.workspace
 mkdir twrp
 cd twrp

 # Input Konfigurasi
 echo "Manifest AOSP Branch AVAILABLE : "
 echo " 11 "
 echo " 12.1 "
 echo "Pilih Manifest branch (11 , 12,1) : "
read Manifest_branch
if [ -z "$Manifest_branch" ]; then
    echo "Input Manifest branch kosong!."
    echo " "
    main
fi
echo "Link Device tree twrp : "
read Device_tree
if [ -z "${Device_tree}" ]; then
    echo "Input Device tree Kosong !"
    echo " "
    main
fi
echo "Branch Device_tree_twrp : "
read Branch_dt_twrp
if [ -z "${Branch_dt_twrp}" ]; then
    echo "Input branch device tree Kosong !"
    echo " "
    main
fi
echo "Device Path : "
read Device_Path
if [ -z "${Device_Path}" ]; then
    echo "Input Device path Kosong!"
    echo " "
    main
fi
echo "Device Name : "
read Device_Name
if [ -z "{$Device_Name}" ]; then
    echo "Input Device Name Kosong!"
    echo " "
    main
fi
echo "Build Target (recovery,boot,vendorboot) : "
read Build_Target
 if [ -z "${Build_Target}" ]; then
    echo "Input Build Target Kosong!"
    echo " "
    main
fi

# menyimpan konfigurasi

echo " "
echo "Konfigurasi Tersimpan"
echo " "
sed -i "s|Device_tree=.*|Device_tree=$Device_tree|" ${current_directory}/save_settings.txt
 
sed -i "s|Branch_dt_twrp=.*|Branch_dt_twrp=$Branch_dt_twrp|" ${current_directory}/save_settings.txt


sed -i "s|Device_Path=.*|Device_Path=$Device_Path|" ${current_directory}/save_settings.txt

sed -i "s|Device_Name=.*|Device_Name=$Device_Name|" ${current_directory}/save_settings.txt

sed -i "s|Build_Target=.*|Build_Target=$Build_Target|" ${current_directory}/save_settings.txt


# Menginstall Package yang diperlikan

echo " "
echo "  Build Environment "
echo " "

  apt update
  apt -y upgrade
  apt -y install gperf gcc-multilib gcc-10-multilib g++-multilib g++-10-multilib libc6-dev lib32ncurses5-dev x11proto-core-dev libx11-dev tree lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc bc ccache lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-gtk3-dev libxml2 lzop pngcrush schedtool squashfs-tools imagemagick libbz2-dev lzma ncftp qemu-user-static libstdc++-10-dev libtinfo5
   #add-apt-repository universe
   apt install nano bc bison ca-certificates curl flex gcc git libc6-dev libssl-dev openssl python-is-python3 ssh wget zip zstd  make clang gcc-arm-linux-gnueabi software-properties-common build-essential libarchive-tools gcc-aarch64-linux-gnu -y &&  apt install build-essential -y &&  apt install libssl-dev libffi-dev libncurses5-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev make gcc -y &&  apt install pigz -y &&  apt install python2 -y &&  apt install python3 -y &&  apt install cpio -y &&  apt install lld -y &&  apt install llvm -y
   apt -y install libncurses5
   apt -y install rsync
   apt -y install repo
   


   # Sync Minimal Manifest
   
        git config --global user.name "Nico170420"
        git config --global user.email "b170420nc@gmail.com"
        
        repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-${Manifest_branch}
        
        repo sync



        # Cloning Device tree
        echo " "
        echo " Cloning Device Tree "
        echo " "
        git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}
        echo " "

        # Start Building 
        
        echo " Building Recovery "
        echo " "
        sleep 1
         export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; cd ${Device_Path}; lunch twrp_${Device_Name}-eng; mka ${Build_Target}image

        # Menyalin Hasil Build Ke direktori saat ini 
        
       if [ "${Build_Target}" = "vendorboot" ]; then
         cp -r ../../../out/target/product/${Device_Name}/vendor_boot.img ${current_directory}
         else
         cp -r ../../../out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}     
        fi
cd ${current_directory}
if [ "${Build_Target}" = "vendorboot" ]; then
mv vendor_boot.img TWRP_${Device_Name}_vendor_boot.img
tar -czvf TWRP_${Device_Name}.tar.gz TWRP_${Device_Name}_vendor_boot.img
else
mv ${Build_Target}.img TWRP_${Device_Name}_${Build_Target}.img
tar -czvf TWRP_${Device_Name}.tar.gz TWRP_${Device_Name}_${Build_Target}.img
fi


bot
main #kembali ke menu
}

###########################################################
###########################################################

#Fungsi Rebuild 

ReAosp()
{
current_directory = ${pwd}


# Permintaan Pilihan ke Pengguna
echo "Memanggil Konfigurasi yang Tersimpan"

echo "Ingin ubah konfigurasi tersimpan?"
echo "1. Ya"
echo "2. Tidak"
echo "Pilih: "
read settings

# Mendeteksi Pilihan dari Perubahan konfigurasi


if [ "${settings}" = 1 ]; then  # Jika Pilihan 1 dijalan kan #
  
  # Membuat Masukkan Ulang Konfigurasi
    echo "Link Device tree twrp : "
read Device_tree
if [ -z "${Device_tree}" ]; then
    echo "Input Device tree Kosong !"
    echo " "
    main
fi
echo "Branch Device_tree_twrp : "
read Branch_dt_twrp
if [ -z "${Branch_dt_twrp}" ]; then
    echo "Input branch device tree Kosong !"
    echo " "
    main
fi
echo "Device Path : "
read Device_Path
if [ -z "${Device_Path}" ]; then
    echo "Input Device path Kosong!"
    echo " "
    main
fi
echo "Device Name : "
read Device_Name
if [ -z "{$Device_Name}" ]; then
    echo "Input Device Name Kosong!"
    echo " "
    main
fi
echo "Build Target (recovery,boot,vendorboot) : "
read Build_Target
 if [ -z "${Build_Target}" ]; then
    echo "Input Build Target Kosong!"
    echo " "
    main
fi

 # Menyimpan dan Memperbarui Konfigurasi saat pengguna pilih 1
sed -i "s|Device_tree=.*|Device_tree=$Device_tree|" ${current_directory}/save_settings.txt
 
sed -i "s|Branch_dt_twrp=.*|Branch_dt_twrp=$Branch_dt_twrp|" ${current_directory}/save_settings.txt


sed -i "s|Device_Path=.*|Device_Path=$Device_Path|" ${current_directory}/save_settings.txt

sed -i "s|Device_Name=.*|Device_Name=$Device_Name|" ${current_directory}/save_settings.txt

sed -i "s|Build_Target=.*|Build_Target=$Build_Target|" ${current_directory}/save_settings.txt

 
    echo " Diperbarui!"
sleep 1



    
    # Menghapus Sumber daya yang telah dibuat sebelumnya
    rm -rf /.workspace/twrp/${Device_Path}
   rm -rf /.workspace/twrp/out/target/product/${Device_Name}
# Memanggil Konfigurasi Yang tersimpan
    source ${current_directory}/save_settings.txt
    
# Cloning Device tree

cd /.workspace/twrp
echo " "
echo " Cloning Device tree "
echo " "

# Clone device tree
git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}
        echo " "
        echo " BUILDING TWRP "
        echo " "
        sleep 1
        
        # Start Building 
        
         export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; cd ${Device_Path}; lunch twrp_${Device_Name}-eng; mka ${Build_Target}image

        # Menyalin hasil ke direktori saat ini
        
       if [ "${Build_Target}" = "vendorboot" ]; then
         cp -r ../../../out/target/product/${Device_Name}/vendor_boot.img ${current_directory}
         else
         cp -r ../../../out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}     
        fi
cd ${current_directory}
if [ "${Build_Target}" = "vendorboot" ]; then
mv vendor_boot.img TWRP_${Device_Name}_vendor_boot.img
tar -czvf TWRP_${Device_Name}.tar.gz TWRP_${Device_Name}_vendor_boot.img
else
mv ${Build_Target}.img TWRP_${Device_Name}_${Build_Target}.img
tar -czvf TWRP_${Device_Name}.tar.gz TWRP_${Device_Name}_${Build_Target}.img
    fi
    bot
    ## Akhir dari Pilihan 1 ##
    
main
elif [ "${settings}" = 2 ]; then ## Awal Dari Pilihan 2 ##

# Memanggil konfigurasi yang tersimpan

    source ${current_directory}/save_settings.txt

    # Menghapus sumber daya yang telah dibuat 
    rm -rf /.workspace/twrp/${Device_Path}
    rm -rf /.workspace/twrp/out/target/product/${Device_Name}

# Cloning Device tree

cd /.workspace/twrp
echo " "
echo " Cloning Device tree "
echo " "

git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}
        echo " "
        echo " BUILDING TWRP "
        echo " "
        sleep 1

        # start building
         export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; cd ${Device_Path}; lunch twrp_${Device_Name}-eng; mka ${Build_Target}image

        # Menyalin Hasil build ke direktori saat ini
        
       if [ "${Build_Target}" = "vendorboot" ]; then
         cp -r ../../../out/target/product/${Device_Name}/vendor_boot.img ${current_directory}
         else
         cp -r ../../../out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}     
        fi
cd ${current_directory}
if [ "${Build_Target}" = "vendorboot" ]; then
mv vendor_boot.img TWRP_${Device_Name}_vendor_boot.img
tar -czvf TWRP_${Device_Name}.tar.gz TWRP_${Device_Name}_vendor_boot.img
else
mv ${Build_Target}.img TWRP_${Device_Name}_${Build_Target}.img
tar -czvf TWRP_${Device_Name}.tar.gz TWRP_${Device_Name}_${Build_Target}.img
fi
bot
    ## Akhir Dari pilihan 2 ##


main  #Kembali Ke menu

else ## Jika Pengguna Memasukkan Tidak sesuai dengan pilihan ##
echo "Invalid karakter"
echo " "
main
fi

main
}


###########################################################
###########################################################
#Fungsi Omni
Omni()
{
 
current_directory=$(pwd)

 echo " "
 echo " BUILD CONFIGURATION TWRP "
 echo " "
 cd /.workspace
 mkdir twrp
 cd twrp
 
 echo "Manifest Omni branch AVAILABLE : \
 - 5.1 \
 - 6.0 \
 - 7.1 \
 - 8.1 \
 - 9.0 "
 echo "Pilih Manifest branch : "
read Manifest_branch
if [ -z "$Manifest_branch" ]; then
    echo "Input Manifest branch kosong!."
    echo " "
    main
fi
echo "Link Device tree twrp : "
read Device_tree
if [ -z "${Device_tree}" ]; then
    echo "Input Device tree Kosong !"
    echo " "
    main
fi
echo "Branch Device_tree_twrp : "
read Branch_dt_twrp
if [ -z "${Branch_dt_twrp}" ]; then
    echo "Input branch device tree Kosong !"
    echo " "
    main
fi
echo "Device Path : "
read Device_Path
if [ -z "${Device_Path}" ]; then
    echo "Input Device path Kosong!"
    echo " "
    main
fi
echo "Device Name : "
read Device_Name
if [ -z "{$Device_Name}" ]; then
    echo "Input Device Name Kosong!"
    echo " "
    main
fi
echo "Build Target (recovery,boot) : "
read Build_Target
 if [ -z "${Build_Target}" ]; then
    echo "Input Build Target Kosong!"
    echo " "
    main
fi

sed -i "s|Device_tree=.*|Device_tree=$Device_tree|" ${current_directory}/save_settings.txt
 
sed -i "s|Branch_dt_twrp=.*|Branch_dt_twrp=$Branch_dt_twrp|" ${current_directory}/save_settings.txt


sed -i "s|Device_Path=.*|Device_Path=$Device_Path|" ${current_directory}/save_settings.txt

sed -i "s|Device_Name=.*|Device_Name=$Device_Name|" ${current_directory}/save_settings.txt

sed -i "s|Build_Target=.*|Build_Target=$Build_Target|" ${current_directory}/save_settings.txt



 
echo " "
echo " Build Environment... "
echo " "

  apt update
  apt -y upgrade
  apt -y install gperf gcc-multilib gcc-10-multilib g++-multilib g++-10-multilib libc6-dev lib32ncurses5-dev x11proto-core-dev libx11-dev tree lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc bc ccache lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-gtk3-dev libxml2 lzop pngcrush schedtool squashfs-tools imagemagick libbz2-dev lzma ncftp qemu-user-static libstdc++-10-dev libtinfo5
   #add-apt-repository universe
   apt install nano bc bison ca-certificates curl flex gcc git libc6-dev libssl-dev openssl python-is-python3 ssh wget zip zstd  make clang gcc-arm-linux-gnueabi software-properties-common build-essential libarchive-tools gcc-aarch64-linux-gnu -y &&  apt install build-essential -y &&  apt install libssl-dev libffi-dev libncurses5-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev make gcc -y &&  apt install pigz -y &&  apt install python2 -y &&  apt install python3 -y &&  apt install cpio -y &&  apt install lld -y &&  apt install llvm -y
   apt -y install libncurses5
   apt -y install rsync
   apt -y install repo
   
   
        git config --global user.name "Nico170420"
        git config --global user.email "b170420nc@gmail.com"
        
        repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-${Manifest_branch}
        
        repo sync
        echo " "

        echo " Cloning Device Tree "
        echo " "
        git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}
        echo " "
        echo " Building recovery..."
        echo " "
        sleep 1
        
        
         export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; cd ${Device_Path}; lunch omni_${Device_Name}-eng; mka ${Build_Target}image
       
     
         cp -r ../../../out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}     
        
cd ${current_directory}
mv ${Build_Target}.img TWRP_${Device_Name}_${Build_Target}.img
tar -czvf TWRP_${Device_Name}.tar.gz TWRP_${Device_Name}_${Build_Target}.img
bot
main
}

###########################################################
###########################################################

# Fungsi Reomni
ReOmni()
{

current_directory = ${pwd}

echo "Memanggil Konfigurasi yang Tersimpan"

echo "Ingin ubah konfigurasi tersimpan?"
echo "1. Ya"
echo "2. Tidak"
echo "Pilih: "
read settings

if [ "${settings}" = 1 ]; then
    echo "Link Device tree twrp : "
read Device_tree
if [ -z "${Device_tree}" ]; then
    echo "Input Device tree Kosong !"
    echo " "
    main
fi
echo "Branch Device_tree_twrp : "
read Branch_dt_twrp
if [ -z "${Branch_dt_twrp}" ]; then
    echo "Input branch device tree Kosong !"
    echo " "
    main
fi
echo "Device Path : "
read Device_Path
if [ -z "${Device_Path}" ]; then
    echo "Input Device path Kosong!"
    echo " "
    main
fi
echo "Device Name : "
read Device_Name
if [ -z "{$Device_Name}" ]; then
    echo "Input Device Name Kosong!"
    echo " "
    main
fi
echo "Build Target (recovery,boot,vendorboot) : "
read Build_Target
 if [ -z "${Build_Target}" ]; then
    echo "Input Build Target Kosong!"
    echo " "
    main
fi

    sed -i "s|Device_tree=.*|Device_tree=$Device_tree|" ${current_directory}/save_settings.txt
 
sed -i "s|Branch_dt_twrp=.*|Branch_dt_twrp=$Branch_dt_twrp|" ${current_directory}/save_settings.txt


sed -i "s|Device_Path=.*|Device_Path=$Device_Path|" ${current_directory}/save_settings.txt

sed -i "s|Device_Name=.*|Device_Name=$Device_Name|" ${current_directory}/save_settings.txt

sed -i "s|Build_Target=.*|Build_Target=$Build_Target|" ${current_directory}/save_settings.txt


echo " Dipeebarui!"
sleep 1

    
    
    rm -rf /.workspace/twrp/${Device_Path}
    rm -rf /.workspace/twrp/out/target/product/${Device_Name}

source ${current_directory}/save_settings.txt
cd /.workspace/twrp
echo " "
echo "Cloning Device Tree "
echo " "
git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}
echo " "
echo " Building recovery "
echo " "
sleep 1
        
         export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; cd ${Device_Path}; lunch twrp_${Device_Name}-eng; mka ${Build_Target}image
        
   
         cp -r ../../../out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}     

        cd ${current_directory}
mv ${Build_Target}.img TWRP_${Device_Name}_${Build_Target}.img
tar -czvf TWRP_${Device_Name}.tar.gz TWRP_${Device_Name}_${Build_Target}.img
bot
main


#end of 1

elif [ "${settings}" = 2 ]; then #Start of 2
    source ${current_directory}/save_settings.txt
    rm -rf /.workspace/twrp/${Device_Path}
    rm -rf /.workspace/twrp/out/target/product/${Device_Name}


cd /.workspace/twrp
echo " "
echo "Cloning Device Tree "
echo " "
git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}
echo " "
echo " Building recovery "
echo " "
sleep 1
        
         export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; cd ${Device_Path}; lunch twrp_${Device_Name}-eng; mka ${Build_Target}image
        
   
         cp -r ../../../out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}     

        cd ${current_directory}
mv ${Build_Target}.img TWRP_${Device_Name}_${Build_Target}.img
tar -czvf TWRP_${Device_Name}.tar.gz TWRP_${Device_Name}_${Build_Target}.img
bot
main
#end of 2
else #else of Reomni
    echo "Input tidak valid. Perintah dibatalkan."
    echo " "
    main
fi



}

###########################################################
###########################################################


# Menjalankan Fungsi Main 
clear
main
exit 0
