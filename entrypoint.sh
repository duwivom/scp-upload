#!/usr/bin/env bash

# Copy the key
echo "$INPUT_KEY" > key
chmod 400 key

# Create remote dir if needed
remote_dir="$INPUT_REMOTE_DIR"
if [ "$remote_dir" = "~" ]; then
    remote_dir="/home/$INPUT_USERNAME/"
else
    ssh -i key -o "StrictHostKeyChecking no" -p $INPUT_PORT "$INPUT_USERNAME"@"$INPUT_HOST" "mkdir -p ${remote_dir}/"
fi

# run command before scp
if [ "$before" != ""]; then
    ssh -i key -o "StrictHostKeyChecking no" -p $INPUT_PORT "$INPUT_USERNAME"@"$INPUT_HOST" "${before}"
fi

# Copy the file
scp -i key -o "StrictHostKeyChecking no" -P $INPUT_PORT "$INPUT_SOURCE" "$INPUT_USERNAME"@"$INPUT_HOST":$remote_dir

# run command after scp
if [ "$after" != ""]; then
    ssh -i key -o "StrictHostKeyChecking no" -p $INPUT_PORT "$INPUT_USERNAME"@"$INPUT_HOST" "${after}"
fi

# Clean
cat /dev/null > ~/.bash_history
rm key