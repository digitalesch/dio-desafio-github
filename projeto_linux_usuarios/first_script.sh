#!/bin/bash
declare -A folder_permissions
folder_permissions[publico]=777
folder_permissions[adm]=770
folder_permissions[ven]=770
folder_permissions[sec]=770

echo "Script for creating folders";
# iterate over keys of array, creates folder and determines permissions for owner / group / others
for key in "${!folder_permissions[@]}"; 
    do
        echo "Creating folder $key";
        sudo mkdir "/$key"
        sudo chmod ${folder_permissions[$key]} /$key
    done

echo "Script for creating user groups";
groups=('GRP_ADM' 'GRP_VEN' 'GRP_SEC')
for i in "${groups[@]}"; 
    do   
        echo "Creating user group $i";
        sudo groupadd $i
    done

echo "Done creating groups";

declare -A user_groups_info
user_groups_info[carlos]='GRP_ADM'
user_groups_info[maria]='GRP_ADM'
user_groups_info[joao]='GRP_ADM'
user_groups_info[debora]='GRP_VEN'
user_groups_info[sebastiana]='GRP_VEN'
user_groups_info[roberto]='GRP_VEN'
user_groups_info[josefina]='GRP_SEC'
user_groups_info[amanda]='GRP_SEC'
user_groups_info[rogerio]='GRP_SEC'

# iterate over keys of array, creates folder and determines permissions for owner / group / others
for key in "${!user_groups_info[@]}";
    do
        echo "Creating user $key with group ${user_groups_info[$key]}";
        sudo useradd $key -m -s /bin/bash -p $(openssl passwd -crypt Senha123) -G ${user_groups_info[$key]};
    done

echo "Done creating users";

declare -A associated_folders
associated_folders[GRP_ADM]='/adm'
associated_folders[GRP_VEN]='/ven'
associated_folders[GRP_SEC]='/sec'

for i in "${groups[@]}"; 
    do   
        echo "Changing ownership of content ${associated_folders[$i]} to $i group";
        sudo chown :$i ${associated_folders[$i]}
    done