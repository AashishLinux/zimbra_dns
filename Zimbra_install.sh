apt update

apt install wget -y

cd /root/

echo DOWNLOADINGH ZIMBRA TAR

wget https://files.zimbra.com/downloads/8.8.15_GA/zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz

echo EXTRACTING TAR

tar -xf zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954.tgz 


#
echo " ##  NOW RUN
cd zcs-8.8.15_GA_4179.UBUNTU20_64.20211118033954
./install.sh
""