# /bin/bash

# install dependencies
apt-get update -y
sudo apt-get install slurmctld -y
sudo apt-get install slurm-wlm -y
sudo apt install slurmdbd -y
sudo apt-get install slurm-client -y
sudo apt install mysql-server -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install mailutils -y

# set up sql
service mysql start
mysql -u root -p <<EOF
CREATE DATABASE slurm_acct_db;
CREATE USER 'slurm'@'localhost' IDENTIFIED BY 'Magics.2048';
GRANT ALL PRIVILEGES ON slurm_acct_db.* TO 'slurm'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

# restart service
cp -r ./slurm /etc/.
service munge stop
service slurmd stop
service slurmdbd stop
service slurmctld stop
service munge start
service slurmd start
service slurmdbd start
service slurmctld start
service munge status
service slurmd status
service slurmdbd status
service slurmctld status

# check
sinfo
squeue
sacct