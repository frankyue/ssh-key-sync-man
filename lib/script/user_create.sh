#!/bin/sh

useradd -m -s /bin/bash sa
cp /home/app/.bash* /home/sa
mkdir -p /home/sa/.ssh
sed -i -e "/app/d" /etc/sudoers
echo "sa  ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8vG/A6d0ywWyDixev6uBOk/o3HMHOkbWuFY5TRUNUdey4sgsBfzO0+ML1VIsPSpu088VGqIb4ROw7sRd0ZfqX2qrm6NrfbjbBT8OwXMat0p86uYtQMUUk84N6F8uKNamiEFvIV0CJ6gnb1EMQv1yTLV6/g02oSe3fXiSwvuBOPCKtGp2lhqlyX5OpmemXrxIJ9ZekTSU4d+v+dTfjPm7wOm9ihve4/VvQxnS7UDGFCSZQDGXSZ159BTG7gfOd4PopjBgbjZBppcoRrJIgKZcP6zh56GGyB+2YXOK5gyu3oDs9FQBvcl4qGj8VEL+f+m0yMvuMZvSrGOxnUfiEy5eB frankyue@frankyue-MBP" >> /home/sa/.ssh/authorized_keys

chown -R sa:sa /home/sa
