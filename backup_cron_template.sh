#!/bin/bash

# Define source and backup directories

declare -A source_backup_dirs=(
    ["/home/renef/workspace/pihole/etc-dnsmasq.d"]="sshUser@serverip:absolute/path/to/backup"
    ["/home/renef/workspace/pihole/etc-pihole"]="sshUser@serverip:absolute/path/to/backup"    
)
version_limit=5
# Loop through the arrays and perform backups
for source_dir in "${!source_backup_dirs[@]}"; do
    backup_dir="${source_backup_dirs[$source_dir]}"

    echo "$backup_dir"
    # Extract username@hostname part
    ssh_info=$(echo "$backup_dir" | cut -d ":" -f 1)

    # Extract path part
    path_part=$(echo "$backup_dir" | cut -d ":" -f 2)

    # Create the backup folder if it doesn't exist
    ssh -p YourSSHPortNumber -i /your/path/to/your/private/sshkey "$ssh_info" "mkdir -p $path_part"

    # Run rsync to copy data to the latest directory
    rsync -avzz -e "ssh -p YourSSHPortNumber -i /your/path/to/your/private/sshkey" --delete "$source_dir" "$backup_dir/latest"

    # Create a timestamped backup using hard links
    rsync -avzz -e "ssh -p YourSSHPortNumber -i /your/path/to/your/private/sshkey" --delete --link-dest="$backup_dir/latest" "$source_dir" "$backup_dir/backup_$(date +%Y%m%d_%H%M%S)"

    # Remove old backups, keeping only the latest N versions
    ssh -p YourSSHPortNumber -i /your/path/to/your/private/sshkey "$ssh_info" "cd $path_part && ls -1t | grep -E '^backup_' | tail -n +$((version_limit + 1)) | xargs -n1 rm -rf"
done
