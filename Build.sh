# BAGIAN FUNGSI


###########################################################

main() {


echo "1. New Build Aosp (sync minimal manifest)"
echo "2. Rebuild Aosp (don't sync minimal manifest)"
echo "3. New Build Omni (sync minimal manifest)"
echo "4. Rebuild Omni (don't sync minimal manifest"
echo "5. Exit "
echo " "
echo "Pilih ( 1 - 5 )"
read Main

if [ "${Main}" = 1 ]; then
Aosp
main
elif [ "${Main}" = 2 ]; then
ReAosp
main
elif [ "${Main}" = 3 ]; then
Omni
main
elif [ "${Main}" = 4 ]; then
ReOmni
main
elif [ "${Main}" = 5 ]; then
exit 0
else
echo " "
echo " Invalid Karakter !!!!"
echo " "
main
fi
}

###########################################################


Aosp()
{

 
current_directory=$(pwd)
echo " "
echo " TWRP BUILD CONFIGURATION "
echo " "
 cd /.workspace
 mkdir twrp
 cd twrp
 echo "Manifest AOSP Branch AVAILABLE : \
 - 11 \
 - 12.1 \ "
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
echo "Build Target (recovery,boot,vendorboot) : "
read Build_Target
 if [ -z "${Build_Target}" ]; then
    echo "Input Build Target Kosong!"
    echo " "
    main
fi
echo " "
echo "Konfigurasi Tersimpan"
echo " "
sed -i "s/Device_tree=.*/Device_tree=$Device_tree/" ${current_directory}/save_settings.txt
 
sed -i "s/Branch_dt_twrp=.*/Branch_dt_twrp=$Branch_dt_twrp/" ${current_directory}/save_settings.txt


sed -i "s/Device_Path=.*/Device_Path=$Device_Path/" ${current_directory}/save_settings.txt

sed -i "s/Device_Name=.*/Device_Name=$Device_Name/" ${current_directory}/save_settings.txt

sed -i "s/Build_Target=.*/Build_Target=$Build_Target/" ${current_directory}/save_settings.txt




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
   
   
        git config --global user.name "Nico170420"
        git config --global user.email "b170420nc@gmail.com"
        
        repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-${Manifest_branch}
        
        repo sync
        echo " "
        echo " Cloning Device Tree "
        echo " "
        git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}
        echo " "
        echo " Building Recovery "
        echo " "
        sleep 1
         export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; cd ${Device_Path}; lunch twrp_${Device_Name}-eng; mka ${Build_Target}image
        
       if [ "${Build_Target}" = "vendorboot" ]; then
         cp -r ../../../out/target/product/${Device_Name}/vendor_boot.img ${current_directory}
         else
         cp -r ../../../out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}     
        fi
cd ${current_directory}
if [ "${Build_Target}" = "vendorboot" ]; then
mv vendor_boot.img TWRP_${Device_Name}_vendor_boot.img
else
mv ${Build_Target}.img TWRP_${Device_Name}_${Build_Target}.img
fi

cd ${current_directory}
echo " "
echo "Done Build"
echo " "
if [ "${Build_Target}" = "vendorboot" ]; then
chmod a+x TWRP_${Device_Name}_vendor_boot.img
else
chmod a+x TWRP_${Device_Name}_${Build_Target}.img
fi
main
}


###########################################################

ReAosp()
{
current_directory = ${pwd}

echo "Memanggil Konfigurasi yang Tersimpan"

echo "Ingin ubah konfigurasi tersimpan?"
echo "1. Ya"
echo "2. Tidak"
echo "Pilih: "
read settings

if [ "${settings}" = 1 ]; then  #Begin of 1#
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

    sed -i "s/Device_tree=.*/Device_tree=$Device_tree/" ${current_directory}/save_settings.txt
 
sed -i "s/Branch_dt_twrp=.*/Branch_dt_twrp=$Branch_dt_twrp/" ${current_directory}/save_settings.txt


sed -i "s/Device_Path=.*/Device_Path=$Device_Path/" ${current_directory}/save_settings.txt

sed -i "s/Device_Name=.*/Device_Name=$Device_Name/" ${current_directory}/save_settings.txt

sed -i "s/Build_Target=.*/Build_Target=$Build_Target/" ${current_directory}/save_settings.txt
echo " Diperbarui!"
sleep 1

    source ${current_directory}/save_settings.txt
    
    rm -rf /.workspace/twrp/device

cd /.workspace/twrp
echo " "
echo " Cloning Device tree "
echo " "

git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}
        echo " "
        echo " BUILDING TWRP "
        echo " "
        sleep 1
        
         export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; cd ${Device_Path}; lunch twrp_${Device_Name}-eng; mka ${Build_Target}image
        
       if [ "${Build_Target}" = "vendorboot" ]; then
         cp -r ../../../out/target/product/${Device_Name}/vendor_boot.img ${current_directory}
         else
         cp -r ../../../out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}     
        fi
cd ${current_directory}
if [ "${Build_Target}" = "vendorboot" ]; then
mv vendor_boot.img TWRP_${Device_Name}_vendor_boot.img
else
mv ${Build_Target}.img TWRP_${Device_Name}_${Build_Target}.img
    fi
    
    #End of 1 Aosp
    
main
elif [ "${settings}" = 2 ]; then #Begin of 2 Aosp
    source ${current_directory}/save_settings.txt
    rm -rf /.workspace/twrp/device

cd /.workspace/twrp
echo " "
echo " Cloning Device tree "
echo " "

git clone ${Device_tree} -b ${Branch_dt_twrp} ${Device_Path}
        echo " "
        echo " BUILDING TWRP "
        echo " "
        sleep 1
        
         export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; cd ${Device_Path}; lunch twrp_${Device_Name}-eng; mka ${Build_Target}image
        
       if [ "${Build_Target}" = "vendorboot" ]; then
         cp -r ../../../out/target/product/${Device_Name}/vendor_boot.img ${current_directory}
         else
         cp -r ../../../out/target/product/${Device_Name}/${Build_Target}.img ${current_directory}     
        fi
cd ${current_directory}
if [ "${Build_Target}" = "vendorboot" ]; then
mv vendor_boot.img TWRP_${Device_Name}_vendor_boot.img
else
mv ${Build_Target}.img TWRP_${Device_Name}_${Build_Target}.img
fi
#End of 2 Aosp
main
else #Else of Aosp
echo "Invalid karakter"
echo " "
main
fi

cd ${current_directory}
echo " "
echo "Done Build"
echo " "
if [ "${Build_Target}" = "vendorboot" ]; then
chmod a+x TWRP_${Device_Name}_vendor_boot.img
else
chmod a+x TWRP_${Device_Name}_${Build_Target}.img
fi
main
}


###########################################################

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

sed -i "s/Device_tree=.*/Device_tree=$Device_tree/" ${current_directory}/save_settings.txt
 
sed -i "s/Branch_dt_twrp=.*/Branch_dt_twrp=$Branch_dt_twrp/" ${current_directory}/save_settings.txt


sed -i "s/Device_Path=.*/Device_Path=$Device_Path/" ${current_directory}/save_settings.txt

sed -i "s/Device_Name=.*/Device_Name=$Device_Name/" ${current_directory}/save_settings.txt

sed -i "s/Build_Target=.*/Build_Target=$Build_Target/" ${current_directory}/save_settings.txt



 
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
chmod a+x TWRP_${Device_Name}_${Build_Target}.img

main
}

###########################################################



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

    sed -i "s/Device_tree=.*/Device_tree=$Device_tree/" ${current_directory}/save_settings.txt
 
sed -i "s/Branch_dt_twrp=.*/Branch_dt_twrp=$Branch_dt_twrp/" ${current_directory}/save_settings.txt


sed -i "s/Device_Path=.*/Device_Path=$Device_Path/" ${current_directory}/save_settings.txt

sed -i "s/Device_Name=.*/Device_Name=$Device_Name/" ${current_directory}/save_settings.txt

sed -i "s/Build_Target=.*/Build_Target=$Build_Target/" ${current_directory}/save_settings.txt
echo " Dipeebarui!"
sleep 1

    source ${current_directory}/save_settings.txt
    
    rm -rf /.workspace/twrp/device

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
main


#end of 1

elif [ "${settings}" = 2 ]; then #Start of 2
    source ${current_directory}/save_settings.txt
    rm -rf /.workspace/twrp/device

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
main
#end of 2
else #else of Reomni
    echo "Input tidak valid. Perintah dibatalkan."
    echo " "
    main
fi

chmod a+x TWRP_${Device_Name}_${Build_Target}.img


}




echo "--------------Building TWRP-----------"
main
exit 0