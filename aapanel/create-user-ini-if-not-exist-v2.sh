#!/bin/bash

# File tao file .user.ini cho cac domain chua co
# Nguon goc: echbay.com/bash-script/create-user-ini-if-not-exist.sh
# Muc dich: Tao file .user.ini de gioi han open_basedir cho PHP

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Cau hinh
readonly WWWROOT_DIR="/www/wwwroot"
readonly TEMP_DIR="/tmp/wwwroot-user-ini"
readonly LOG_FILE="/var/log/create-user-ini.log"

# Ham ghi log
log_message() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" | tee -a "$LOG_FILE"
}

# Ham tao thu muc tam
setup_temp_directory() {
    if ! mkdir -p "$TEMP_DIR"; then
        log_message "ERROR: Cannot create temp directory: $TEMP_DIR"
        exit 1
    fi
    
    chmod 755 "$TEMP_DIR" || {
        log_message "ERROR: Cannot set permissions for temp directory"
        exit 1
    }
    
    log_message "Temp directory created successfully: $TEMP_DIR"
}

# Ham kiem tra va tao file .user.ini
create_user_ini_file() {
    local domain_dir="$1"
    local domain_name="$2"
    local user_ini_file="$domain_dir/.user.ini"
    local temp_user_ini="$TEMP_DIR/.user.ini"
    
    # Kiem tra xem file .user.ini da ton tai chua
    if [[ -f "$user_ini_file" ]]; then
        log_message "SKIP: .user.ini already exists for domain: $domain_name"
        return 0
    fi
    
    log_message "CREATING: .user.ini for domain: $domain_name"
    
    # Tao noi dung file .user.ini
    cat > "$temp_user_ini" << EOF
; PHP .user.ini file for domain: $domain_name
; Created on: $(date)
; Purpose: Restrict PHP open_basedir for security

; Gioi han truy cap file chi trong thu muc domain va /tmp
open_basedir=$domain_dir/:/tmp/

; Tat ca cac cai dat khac co the them vao day neu can
; upload_max_filesize = 64M
; post_max_size = 64M
; memory_limit = 256M
EOF

    # Set permissions cho file tam
    if ! chmod 644 "$temp_user_ini"; then
        log_message "ERROR: Cannot set permissions for temp .user.ini file"
        return 1
    fi
    
    if ! chown root:root "$temp_user_ini"; then
        log_message "ERROR: Cannot set ownership for temp .user.ini file"
        return 1
    fi
    
    # Copy file vao thu muc domain
    if rsync -avzh "$temp_user_ini" "$domain_dir/"; then
        log_message "SUCCESS: .user.ini created for domain: $domain_name"
        return 0
    else
        log_message "ERROR: Failed to copy .user.ini to domain: $domain_name"
        return 1
    fi
}

# Ham chinh
main() {
    local processed_domains=0
    local created_files=0
    local skipped_files=0
    local error_count=0
    
    log_message "Starting .user.ini creation process..."
    log_message "WWW root directory: $WWWROOT_DIR"
    
    # Kiem tra thu muc wwwroot co ton tai khong
    if [[ ! -d "$WWWROOT_DIR" ]]; then
        log_message "ERROR: WWW root directory does not exist: $WWWROOT_DIR"
        exit 1
    fi
    
    # Tao thu muc tam
    setup_temp_directory
    
    # Duyet qua tat ca cac domain directories
    for domain_dir in "$WWWROOT_DIR"/*; do
        # Chi xu ly neu la directory
        if [[ ! -d "$domain_dir" ]]; then
            continue
        fi
        
        local domain_name=$(basename "$domain_dir")
        processed_domains=$((processed_domains + 1))
        
        log_message "Processing domain: $domain_name (Path: $domain_dir)"
        
        # Tao file .user.ini neu chua co
        if create_user_ini_file "$domain_dir" "$domain_name"; then
            if [[ -f "$domain_dir/.user.ini" ]]; then
                created_files=$((created_files + 1))
            else
                skipped_files=$((skipped_files + 1))
            fi
        else
            error_count=$((error_count + 1))
        fi
    done
    
    # Cleanup temp directory
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
        log_message "Temp directory cleaned up: $TEMP_DIR"
    fi
    
    # Bao cao ket qua
    log_message "=== SUMMARY ==="
    log_message "Processed domains: $processed_domains"
    log_message "Created .user.ini files: $created_files"
    log_message "Skipped (already exist): $skipped_files"
    log_message "Errors: $error_count"
    log_message ".user.ini creation process completed."
    
    # Return appropriate exit code
    if [[ $error_count -gt 0 ]]; then
        exit 1
    else
        exit 0
    fi
}

# Chay chuong trinh chinh
main "$@"
