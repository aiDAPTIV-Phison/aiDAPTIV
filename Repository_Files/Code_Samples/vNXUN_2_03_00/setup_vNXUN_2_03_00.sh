#!/bin/bash

# Append env paths
appenvpath () {

    case ":$PATH:" in
        *:"$1":*)
            echo 'ENV path exists'
            ;;
        *)
            echo 'export PATH="/home/$USER/.local/bin:$PATH"' >> ~/.bashrc
            echo 'added ENV path to ~/.bashrc'
    esac
}


# Function to check if PATH exists in environment variables
check_path_exists() {
    if [[ ":$PATH:" == *":$1:"* ]]; then
        return 0
    else
        return 1
    fi
}

select_manual_update(){
    clear
    echo "Please enter all drive paths to be checked for version confirmation."
    return 1
}

select_automatic_update(){
    clear
    while true; do
        echo "If the FW version does not match, do you need to update the SSD FW? (Y/N)"
        read -p "Please enter Y or N: " yn_choice
        case $yn_choice in
            Y|y)
                return 1
                ;;
            N|n)
                echo "After installation is completed, the option for manual update will be available."
                return 0
                ;;
            *)
                echo "Invalid choice, please enter Y or N."
                clear
                continue
                ;;
        esac
    done
}

check_fw_version(){
    echo "check_fw_version"
    python3 -c "from phisonlib.moirai import nvme_update_flow; nvme_update_flow('${nvme_path_list[$i]}', 0)"
}

update_fw_version(){
    echo "update_fw_version"
    python3 -c "from phisonlib.moirai import nvme_update_flow; nvme_update_flow('${nvme_path_list[$i]}', 1)"
}

check_message_is_info() {
    local checking_message="$1"
    if [[ "$checking_message" =~ .* ]]; then
        return 0  
    else
        return 1  
    fi
}

double_check_fw_version(){
        # Double-check phase
    local controller=$1
    while true; do
        clear
        echo "Double-check the nvme_path list:"
        echo "Current nvme_path list:"
        for i in "${!nvme_path_list[@]}"; do
            echo "$((i+1))) ${nvme_path_list[$i]}"
        done
        echo "Choose an action:"
        echo "1) Confirm"
        echo "2) Back"
        read -p "Please select an action: " final_choice
        case $final_choice in
            1)
                if [[ "$controller" -eq 0 ]]; then
                    echo "Confirming and checking..."
                    for i in "${!nvme_path_list[@]}"; do
                        echo "Checking firmware for: ${nvme_path_list[$i]}"
                        check_message=$(check_fw_version "${nvme_path_list[$i]}")

                        if check_message_is_info "$check_message"; then
                            echo "$check_message"
                        else
                            echo "[PHISON AIDAPTIV][ERROR] Firmware check failed, please check your device."
                        fi    

                    done
                elif [[ "$controller" -eq 1 ]]; then
                    echo "Confirming and Updating..."
                    for i in "${!nvme_path_list[@]}"; do
                        echo "Updating firmware for: ${nvme_path_list[$i]}"
                        update_message=$(update_fw_version "${nvme_path_list[$i]}")

                        if check_message_is_info "$update_message"; then
                            echo "$update_message"
                        else
                            echo "[PHISON AIDAPTIV][ERROR] Firmware update failed, please check your device."
                        fi   
                                            
                    done
                fi
                
                
                return 0
                ;;
            2)
                echo "Returning to the initial step to decide whether to add nvme_path."
                return 1 # Break out of the double-check loop and return to adding nvme_path
                ;;
            *)
                echo "Invalid choice, please try again."
                sleep 2
                ;;
        esac
    done
}
update_fw_script() {
    nvme_path_list=()  # Initialize an empty nvme_path list
    local update_controller=$1  # Accept controller value as an argument
    local task_controller=$2 
    local checking_message="$1"
    if [[ "$update_controller" -eq 0 ]]; then
        select_manual_update "$controller"
    elif [[ "$update_controller" -eq 1 ]]; then
        select_automatic_update "$controller"
    fi
    local result=$?  
    while true; do
        if [[ "$result" -eq 0 ]]; then
            break
        elif [[ "$result" -eq 1 ]]; then
            # Initial loop to add or modify nvme_path_list
            while true; do
                # Check if nvme_path_list is empty
                if [ ${#nvme_path_list[@]} -eq 0 ]; then
                    # Offer only Add and Terminate options if list is empty
                    clear
                    echo "Choose an action:"
                    echo "1) Add nvme_path"
                    echo "2) Terminate adding nvme_path"
                    read -p "Please select an action: " choice
                    case $choice in
                        1)
                            read -p "Enter nvme_path to add: " nvme_path
                            nvme_path_list+=("$nvme_path")
                            echo "$nvme_path has been added to the list"
                            ;;
                        2)
                            echo "[Error] nvme_path list is empty. Please try again."
                            sleep 3

                            ;;
                        *)
                            echo "[Error] Invalid choice, please try again."
                            sleep 2
                            ;;
                    esac
                else
                    clear
                    # Display current nvme_path list with numbering
                    echo "Current nvme_path list:"
                    for i in "${!nvme_path_list[@]}"; do
                        echo "$((i+1))) ${nvme_path_list[$i]}"
                    done
                    # Offer Add, Remove, and Terminate options if list is not empty
                    echo "Choose an action:"
                    echo "1) Add nvme_path"
                    echo "2) Remove nvme_path"
                    echo "3) Terminate adding nvme_path"
                    read -p "Please select an action: " choice
                    case $choice in
                        1)
                            read -p "Enter nvme_path to add: " nvme_path
                            nvme_path_list+=("$nvme_path")
                            echo "$nvme_path has been added to the list"
                            ;;
                        2)
                            if [ ${#nvme_path_list[@]} -gt 0 ]; then
                                read -p "Enter the index of the nvme_path to remove: " index
                                if [[ $index -gt 0 && $index -le ${#nvme_path_list[@]} ]]; then
                                    nvme_path="${nvme_path_list[$((index-1))]}"
                                    unset nvme_path_list[$((index-1))]
                                    nvme_path_list=("${nvme_path_list[@]}")  # Re-index the array
                                    echo "$nvme_path has been removed from the list"
                                else
                                    echo "Invalid index, please try again"
                                    sleep 2
                                fi
                            else
                                echo "nvme_path list is empty, cannot remove"
                            fi
                            ;;
                        3)
                            echo "Terminating nvme_path addition"
                            double_check_fw_version "$task_controller"
                            check=$?  
                            if [[ "$check" -eq 0 ]]; then
                                return $result
                            fi
                            ;;
                        *)
                            echo "Invalid choice, please try again"
                            sleep 2
                            ;;
                    esac
                fi
            done
        fi
    done
}

# Function to deploy aiDAPTIV
deploy_aiDAPTIV() {

    

    current_dir=$(pwd)
    is_rhel=$(grep -q 'rhel' /etc/os-release && echo "true" || echo "false")
    # Install pytorch and related package
    # sudo apt install -y python3-pip libaio-dev libstdc++-12-dev
    if [ "$is_rhel" = "true" ]; then
        sudo yum -y groupinstall "Development tools" 
        sudo yum -y install gcc libffi-devel zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel 
        sudo yum -y update
    else
        sudo apt update
        sudo apt install -y wget libaio1 libaio-dev liburing2 liburing-dev libboost-all-dev python3-pip libstdc++-12-dev
        sudo apt install -y gcc-12 g++-12
        sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 50
    fi

    # 檢查pip的路徑
    PYTHON_PATH=$(which python3 | xargs dirname)
    echo "Found python3 at:"$PYTHON_PATH

    if [ "$PYTHON_PATH" == "" ]; then
        echo "Python3 Path is not found. Please check 'which python3' working correctly."
        exit 1
    fi

    if [ "$is_rhel" = "true" ]; then
        cd "$current_dir" 
        sudo yum install -y libaio libaio-devel liburing liburing-devel boost-devel python3-pip python3-devel
        sudo yum install -y gcc gcc-c++ 
    fi


    current_user=$(whoami)
    local update_controller=1
    local controller=-1  
    update_fw_script "$update_controller" "$controller"
    local result=$?  


    # Download aiDAPTIV package
    mkdir -p /home/$current_user/
    rm -rf /home/$current_user/dm /home/$current_user/aiDAPTIV2
    mkdir /home/$current_user/dm /home/$current_user/aiDAPTIV2  


    # Download aiDAPTIV+ Package
    TAR_NAME="vNXUN_2_03_00.tar"
    
    sleep 3
    clear
    while true; do
        echo "Hi user $current_user, would you like to download $TAR_NAME from cloud? (Y/N)"
        read -p "Please enter Y or N: " yn_choice
        case $yn_choice in
            Y|y)
                rm -f $TAR_NAME
                
                if ! wget --tries=3 https://phisonbucket.s3.ap-northeast-1.amazonaws.com/$TAR_NAME --no-check-certificate; then
                    read -p "Can't get $TAR_NAME from cloud, Please enter the path to the $TAR_NAME file: " filepath    
                    tar xvf "$filepath" -C /home/$current_user/aiDAPTIV2
                    echo 'unzip package'
                else
                    echo 'Get package from cloud'
                    tar xvf $TAR_NAME -C /home/$current_user/aiDAPTIV2     
                    echo 'unzip package'
                fi

                break ;;
            N|n)
                read -p "Please enter the path to the $TAR_NAME file: " filepath    
                tar xvf "$filepath" -C /home/$current_user/aiDAPTIV2
                echo 'unzip package'

                break ;;
            *)
                echo "Invalid choice, please enter Y or N."
                clear
                continue
                ;;
        esac
    done

    echo "Start to build env..."

    GPU_INFO=$(lspci | grep -E -i "vga|3d|display")
 
    # 判斷 GPU 廠牌
    if echo "$GPU_INFO" | grep -i 'nvidia' > /dev/null; then
        echo "NVIDIA GPU DETECTED"
        GPU_TYPE="Nvidia"
    elif echo "$GPU_INFO" | grep -i 'amd' > /dev/null; then
        echo "AMD GPU DETECTED"
        GPU_TYPE="AMD"
        if echo "$GPU_INFO" | grep -i "Radeon"; then
            GPU_NAME="Radeon"
        elif echo "$GPU_INFO" | grep -i "MI"; then
            GPU_NAME="MI"
        else
            echo "UNKNOWN AMD GPU"
            GPU_TYPE="Unknown"
            exit 1
        fi
    else
        echo "UNKNOWN GPU"
        GPU_TYPE="Unknown"
        exit 1
    fi

    pip install --upgrade pip
    # # 判斷pip路徑
    if [[ "$PYTHON_PATH" == "/usr/bin" && "$current_user" != "root" ]]; then
        # 使用--user選項來安裝套件
        echo "installed required packages in" $(python3 -m site --user-site)

        if [ "$GPU_TYPE" == "Nvidia" ]; then
            yes | pip install --user -r /home/$current_user/aiDAPTIV2/requirements_nv.txt
        elif [ "$GPU_TYPE" == "AMD" ]; then
            if [ "$GPU_NAME" == "MI" ]; then
                yes | pip install --user -r /home/$current_user/aiDAPTIV2/requirements_amd_mi.txt
                pip install flash-attn --no-build-isolation
            elif [ "$GPU_NAME" == "Radeon" ]; then   
                yes | pip install --user -r /home/$current_user/aiDAPTIV2/requirements_amd_radeon.txt  
            fi
        fi
        appenvpath /home/$current_user/.local/bin
    else
        # 直接使用pip安裝套件
        if [ "$current_user" == "root" ]; then
            echo "installed required packages in /usr/local/lib/python3.10/dist-packages"
        else
            echo "installed required packages in"  $(realpath $PYTHON_PATH/../lib/python3.10/site-packages/)
        fi

        if [ "$GPU_TYPE" == "Nvidia" ]; then
            yes | pip install -r /home/$current_user/aiDAPTIV2/requirements_nv.txt
        elif [ "$GPU_TYPE" == "AMD" ]; then
            if [ "$GPU_NAME" == "MI" ]; then
                yes | pip install -r /home/$current_user/aiDAPTIV2/requirements_amd_mi.txt
                pip install flash-attn --no-build-isolation
            elif [ "$GPU_NAME" == "Radeon" ]; then   
                yes | pip install -r /home/$current_user/aiDAPTIV2/requirements_amd_radeon.txt 
            fi
        fi
    fi

    cd /home/$current_user/aiDAPTIV2
    # Set executable permissions
    sudo chmod +x bin/*
    echo 'Edited bin permissions'
    mv *.so ./phisonlib
    sudo chmod +x ./phisonlib/ada.exe
    sudo setcap cap_sys_admin,cap_dac_override=+eip ./phisonlib/ada.exe


    if [[ "$PYTHON_PATH" == "/usr/bin" && "$current_user" != "root" ]]; then
        # Move bin files to dm directory

        cp bin/* /home/$current_user/dm/
        mv bin/* /home/$current_user/.local/bin/
        rm -rf bin
        echo 'Moved bin files'S
        rm -rf /home/$current_user/.local/lib/python3.10/site-packages/phisonlib
        mv phisonlib /home/$current_user/.local/lib/python3.10/site-packages/
        rm -rf phisonlib
        # echo 'export PYTHONPATH="/home/$USER/.local/lib/python3.10/site-packages/phisonlib"' >> ~/.bashrc
        echo "updated phisonlib to /home/$current_user/.local/lib/python3.10/site-packages"

    else
        cp bin/* /home/$current_user/dm/
        # Move bin files to dm directory
        
        mv bin/* $PYTHON_PATH
        rm -rf bin
        echo 'Move bin files to dm/ and ' $PYTHON_PATH

        if [ "$current_user" == "root" ] ; then
            rm -rf /usr/local/lib/python3.10/dist-packages/phisonlib
            mv phisonlib /usr/local/lib/python3.10/dist-packages
            rm -rf phisonlib
            # echo 'export PYTHONPATH="/usr/local/lib/python3.10/dist-packages/phisonlib"' >> ~/.bashrc        
            echo 'updated phisonlib to /usr/local/lib/python3.10/dist-packages'

        else
            rm -rf  $PYTHON_PATH/../lib/python3.10/site-packages/phisonlib
            mv phisonlib $PYTHON_PATH/../lib/python3.10/site-packages/
            rm -rf phisonlib    
            # echo 'export PYTHONPATH="$PYTHON_PATH/../lib/python3.10/site-packages/phisonlib"' >> ~/.bashrc
            echo 'updated phisonlib to' $(realpath $PYTHON_PATH/../lib/python3.10/site-packages/)
            
        fi

    fi


    # echo 'export PYTHONPATH="/home/$USER/.local/lib/python3.10/site-packages/Phisonlib"' >> ~/.bashrc
    # echo 'export PYTHONPATH="/home/$USER/Desktop/aiDAPTIV2:$PYTHONPATH"' >> ~/.bashrc
    if [[ "$result" -eq 1 ]]; then
        echo "Confirming and updating..."
        # Add your update logic here
        echo "Update complete with nvme_path list:"
        for i in "${!nvme_path_list[@]}"; do
            echo "Updating firmware for: ${nvme_path_list[$i]}"
            update_message=$(update_fw_version "${nvme_path_list[$i]}")
            
            if check_message_is_info "$update_message"; then
                echo "$update_message"
            else
                echo "[PHISON AIDAPTIV][INFO] Firmware update failed, please check your device."
            fi   
        done
    fi
    cd "$current_dir"
    echo 'Deploy Phison aiDAPTIV+ successfully, You MUST restart the session for the changes to take effect.'

    if [ -n "$DESKTOP_SESSION" ]; then 
        # Delete old aiDAPTIV+
        mkdir -p /home/$current_user/Desktop/
        rm -rf /home/$current_user/Desktop/dm /home/$current_user/Desktop/aiDAPTIV2
        mkdir /home/$current_user/Desktop/dm /home/$current_user/Desktop/aiDAPTIV2 

        ln -s /home/$current_user/aiDAPTIV2 /home/$current_user/Desktop/aiDAPTIV2
        ln -s /home/$current_user/dm /home/$current_user/Desktop/dm
    fi


}

# Option to select action
while true; do
    current_user=$(whoami)
    echo "Hi user $current_user"
    echo "Select an action:"
    echo "1. Deploy aiDAPTIV+"
    echo "2. Exit"
    if python3 -c "import phisonlib.moirai" &>/dev/null && result=$(phisonai2 -v && version=$(echo "$result" | awk -F ': ' '{print $2}')) && [[ " $TAR_NAME " == *"$version"* ]]; then
        echo "3. FW update"
        read -p "Enter your choice (1, 2 or 3): " choice
    else
        read -p "Enter your choice (1, 2): " choice
    fi

    update_mode=0
    controller_check=0
    controller_update=1  
    
    
    case $choice in
        1)
            deploy_aiDAPTIV
            ;;
        2)
            exit 0
            ;;
        3)
            clear
            while true; do
              echo "Choose an action:"
              echo "1) Check FW version"
              echo "2) Update FW version"
              echo "3) Back"
              echo "4) Exit"
              
            read -p "Enter your choice (1, 2, or 3): " final_choice
                case $final_choice in
                    1)
                        update_fw_script "$update_mode" "$controller_check"
                        ;;
                    2)
                        update_fw_script "$update_mode" "$controller_update"
                        ;;
                    3)
                        break
                        ;;
                    4)
                        exit 0
                        ;;                      
                                
                    *)
                        echo "Invalid choice, please try again."
                        ;;
                
                esac
            done

            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done
