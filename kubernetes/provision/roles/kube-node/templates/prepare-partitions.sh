calc() {
    nbr=$1

    each=$(expr 100 \/ $nbr)

    echo "mklabel gpt"
    for i in $(seq 1 $nbr); do
        start=$(expr $i \* $each - $each)
        end=$(expr $i \* $each)
        if [ $i -ne $nbr ]; then
            echo "mkpart partition${i} ext2 $start% $end%"
        else
            echo "mkpart partition${i} ext2 $start% 100%"
        fi
    done
}

mkpart() {
    device=$1
    partitions=$2

    calc $partitions > /tmp/mkpart.txt
    cat /tmp/mkpart.txt | xargs -L 50 parted -s $device
}

## start of script entrace section
########### script arguments start ###########
device="{{ item.device }}"
root="{{ discovery_directory }}"
disk="{{ item.disk }}"
fstype="{{ item.fstype}}"
partitions={{ item.partitions }}
########### script arguments end ###########
changes=0

# check if device is partitioned
existing_partitions=$(parted -m $device print | wc -l)
existing_partitions=$(expr $existing_partitions - 2)
if [ $existing_partitions -eq 0 ]; then
    mkpart $device $partitions
    changes=$(expr $changes + 1)
    existing_partitions=$partitions
fi

for i in $(seq 1 $existing_partitions); do
    # make file system for each partition
    dev=$device$i
    existing_fstype=$(blkid -s TYPE -o value $dev)
    if [ -z $existing_fstype ]; then
        mkfs -t $fstype $dev
        changes=$(expr $changes + 1)
    fi

    # create mount point if absent
    mount_point="$root/${disk}p$i"
    if [ ! -d $mount_point  ]; then
        mkdir -p $mount_point
        changes=$(expr $changes + 1)
    fi

    # register partition in /etc/fstab w/ UUID
    UUID=$(blkid -s UUID -o value $dev)
    grep $UUID /etc/fstab > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "UUID=$UUID $mount_point $fstype defaults 0 2" >> /etc/fstab
        changes=$(expr $changes + 1)
    fi

    # mount the partition
    grep $mount_point /proc/mounts > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        mount $mount_point
        changes=$(expr $changes + 1)
    fi
done

if [ $changes -gt 0 ]; then
    echo "Prepared partitions"
else
    echo "No changes"
fi
