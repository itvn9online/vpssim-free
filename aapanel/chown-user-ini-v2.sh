#!/bin/bash

# Script quan ly permissions cho file .user.ini va cleanup security risks
# Nguon goc: echbay.com/bash-script/chown-user-ini.sh
# Muc dich: Set permissions cho .user.ini files va remove unsafe file managers

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Cau hinh
readonly WWWROOT_DIR="/www/wwwroot"
readonly LOG_FILE="/var/log/chown-user-ini.log"
readonly USER_INI_PERM="644"
readonly USER_INI_OWNER="root:root"
readonly WEB_USER="www:www"

# Danh sach cac thu muc con can kiem tra
readonly SUBDIRS=("public_html" "public")

# Danh sach cac file/folder nguy hiem can xoa
readonly DANGEROUS_ITEMS=("tinyfilemanager")

# Ham ghi log
log_message() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" | tee -a "$LOG_FILE"
}

# Ham set permissions cho mot file .user.ini
set_user_ini_permissions() {
    local file_path="$1"
    
    if [[ ! -f "$file_path" ]]; then
        return 1
    fi
    
    log_message "Setting permissions for: $file_path"
    
    # Set file permissions
    if ! chmod "$USER_INI_PERM" "$file_path"; then
        log_message "ERROR: Failed to set permissions for $file_path"
        return 1
    fi
    
    # Set file ownership
    if ! chown "$USER_INI_OWNER" "$file_path"; then
        log_message "ERROR: Failed to set ownership for $file_path"
        return 1
    fi
    
    log_message "SUCCESS: Permissions set for $file_path"
    return 0
}

# Ham set permissions cho directory
set_directory_permissions() {
    local dir_path="$1"
    
    if [[ ! -d "$dir_path" ]]; then
        return 1
    fi
    
    log_message "Setting web user permissions for directory: $dir_path"
    
    if ! chown -R "$WEB_USER" "$dir_path"; then
        log_message "ERROR: Failed to set directory permissions for $dir_path"
        return 1
    fi
    
    log_message "SUCCESS: Directory permissions set for $dir_path"
    return 0
}

# Ham xoa cac item nguy hiem
remove_dangerous_item() {
    local item_path="$1"
    local item_name=$(basename "$item_path")
    
    if [[ ! -e "$item_path" ]]; then
        return 0  # Khong ton tai thi khong can xoa
    fi
    
    log_message "SECURITY: Removing dangerous item: $item_path"
    
    if rm -rf "$item_path"; then
        log_message "SUCCESS: Removed dangerous item: $item_path"
        return 0
    else
        log_message "ERROR: Failed to remove dangerous item: $item_path"
        return 1
    fi
}

# Ham xu ly mot domain directory
process_domain_directory() {
    local domain_dir="$1"
    local domain_name=$(basename "$domain_dir")
    local processed_files=0
    local errors=0
    
    log_message "Processing domain: $domain_name"
    
    # 1. Xu ly file .user.ini trong root directory
    local root_user_ini="$domain_dir/.user.ini"
    if [[ -f "$root_user_ini" ]]; then
        if set_user_ini_permissions "$root_user_ini"; then
            processed_files=$((processed_files + 1))
        else
            errors=$((errors + 1))
        fi
    fi
    
    # 2. Xu ly cac subdirectories
    for subdir in "${SUBDIRS[@]}"; do
        local subdir_path="$domain_dir/$subdir"
        
        if [[ -d "$subdir_path" ]]; then
            # Set permissions cho subdirectory
            if ! set_directory_permissions "$subdir_path"; then
                errors=$((errors + 1))
            fi
            
            # Xu ly .user.ini trong subdirectory
            local subdir_user_ini="$subdir_path/.user.ini"
            if [[ -f "$subdir_user_ini" ]]; then
                if set_user_ini_permissions "$subdir_user_ini"; then
                    processed_files=$((processed_files + 1))
                else
                    errors=$((errors + 1))
                fi
            fi
        fi
    done
    
    # 3. Cleanup dangerous items
    for dangerous_item in "${DANGEROUS_ITEMS[@]}"; do
        # Check in root directory
        local root_item="$domain_dir/$dangerous_item"
        if [[ -e "$root_item" ]]; then
            if ! remove_dangerous_item "$root_item"; then
                errors=$((errors + 1))
            fi
        fi
        
        # Check in subdirectories
        for subdir in "${SUBDIRS[@]}"; do
            local subdir_item="$domain_dir/$subdir/$dangerous_item"
            if [[ -e "$subdir_item" ]]; then
                if ! remove_dangerous_item "$subdir_item"; then
                    errors=$((errors + 1))
                fi
            fi
        done
    done
    
    log_message "Domain $domain_name: Processed $processed_files files, $errors errors"
    return $errors
}

# Ham bulk update bang find (backup method)
bulk_update_user_ini_files() {
    log_message "Running bulk update for all .user.ini files..."
    
    local find_errors=0
    
    # Change to wwwroot directory
    if ! cd "$WWWROOT_DIR"; then
        log_message "ERROR: Cannot change to wwwroot directory"
        return 1
    fi
    
    # Set permissions for all .user.ini files
    if ! find . -type f -name "*.user.ini" -exec chmod "$USER_INI_PERM" {} \; 2>/dev/null; then
        log_message "WARNING: Some files failed during bulk permission update"
        find_errors=$((find_errors + 1))
    fi
    
    # Set ownership for all .user.ini files
    if ! find . -type f -name "*.user.ini" -exec chown "$USER_INI_OWNER" {} \; 2>/dev/null; then
        log_message "WARNING: Some files failed during bulk ownership update"
        find_errors=$((find_errors + 1))
    fi
    
    # Return to home directory
    cd ~ || true
    
    log_message "Bulk update completed with $find_errors warnings"
    return 0
}

# Ham chinh
main() {
    local total_domains=0
    local processed_domains=0
    local total_errors=0
    
    log_message "Starting .user.ini permissions and security cleanup..."
    log_message "WWW root directory: $WWWROOT_DIR"
    
    # Kiem tra thu muc wwwroot co ton tai khong
    if [[ ! -d "$WWWROOT_DIR" ]]; then
        log_message "ERROR: WWW root directory does not exist: $WWWROOT_DIR"
        exit 1
    fi
    
    # Chay bulk update truoc
    bulk_update_user_ini_files
    
    # Xu ly tung domain directory
    for domain_dir in "$WWWROOT_DIR"/*; do
        # Chi xu ly neu la directory
        if [[ ! -d "$domain_dir" ]]; then
            continue
        fi
        
        total_domains=$((total_domains + 1))
        
        if process_domain_directory "$domain_dir"; then
            processed_domains=$((processed_domains + 1))
        else
            local domain_errors=$?
            total_errors=$((total_errors + domain_errors))
        fi
    done
    
    # Bao cao ket qua
    log_message "=== SUMMARY ==="
    log_message "Total domains: $total_domains"
    log_message "Successfully processed: $processed_domains"
    log_message "Total errors: $total_errors"
    log_message ".user.ini permissions and security cleanup completed."
    
    # Return appropriate exit code
    if [[ $total_errors -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}

# Chay chuong trinh chinh
main "$@"
