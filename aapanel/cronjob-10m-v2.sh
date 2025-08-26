#!/bin/bash

# file nay duoc luu lai code cua echbay.com
# /echbay.com/bash-script/cronjob-10m.sh

# chuyen ve root truoc khi chay lenh
cd ~


# Ko cho chay lien tuc neu tien trinh truoc day chua xong
# Su dung PID lock de dam bao chi co 1 tien trinh chay tai 1 thoi diem
LOCK_FILE="/tmp/cronjob-10m.lock"
SCRIPT_NAME=$(basename "$0")

# Ham check va tao lock file
acquire_lock() {
    # Neu lock file ton tai
    if [ -f "$LOCK_FILE" ]; then
        # Doc PID tu lock file
        LOCK_PID=$(cat "$LOCK_FILE" 2>/dev/null)
        
        # Kiem tra xem process co PID nay co dang chay khong
        if [ -n "$LOCK_PID" ] && kill -0 "$LOCK_PID" 2>/dev/null; then
            # Kiem tra ten process co phai script nay khong
            PROCESS_NAME=$(ps -p "$LOCK_PID" -o comm= 2>/dev/null)
            if [[ "$PROCESS_NAME" == *"bash"* ]] || [[ "$PROCESS_NAME" == *"sh"* ]]; then
                /usr/bin/echo "Process $LOCK_PID is still running ($SCRIPT_NAME), exit"
                exit 1
            fi
        fi
        
        # Neu PID khong ton tai hoac process da chet, xoa lock file cu
        /usr/bin/echo "Removing stale lock file (PID $LOCK_PID not found)"
        /usr/bin/rm -f "$LOCK_FILE"
    fi
    
    # Tao lock file moi voi PID hien tai
    /usr/bin/echo $$ > "$LOCK_FILE"
    /usr/bin/echo "Lock acquired with PID $$, started at $(date)"
}

# Ham giai phong lock
release_lock() {
    if [ -f "$LOCK_FILE" ]; then
        CURRENT_PID=$(cat "$LOCK_FILE" 2>/dev/null)
        if [ "$CURRENT_PID" = "$$" ]; then
            /usr/bin/rm -f "$LOCK_FILE"
            /usr/bin/echo "Lock released for PID $$"
        fi
    fi
}

# Trap de dam bao lock duoc giai phong khi script ket thuc
trap 'release_lock; exit' INT TERM EXIT

# Lay lock truoc khi bat dau
acquire_lock

# 
# /usr/bin/rm -rf /tmp/cronjob-10m-*.log
# /usr/bin/rm -rf /tmp/cronjob-1hrs-*.log
# /usr/bin/rm -rf /tmp/cronjob-1ngay-*.log

# Memcached Daemon
btpython /www/server/panel/script/restart_services.py memcached

# Redis Daemon
btpython /www/server/panel/script/restart_services.py redis

# Nginx Daemon
btpython /www/server/panel/script/restart_services.py nginx

# Mysql Daemon
btpython /www/server/panel/script/restart_services.py mysql



# Tao lai file access log neu chua co va phan quyen cho tat ca log files
create_file_access_log(){
    local log_dir="/www/wwwlogs"
    local www_dir="/www/wwwroot"
    local created_files=0
    
    # Kiem tra thu muc log co ton tai khong
    if [ ! -d "$log_dir" ]; then
        /usr/bin/echo "Warning: Log directory $log_dir does not exist"
        return 1
    fi
    
    # Kiem tra thu muc www co ton tai khong  
    if [ ! -d "$www_dir" ]; then
        /usr/bin/echo "Warning: WWW directory $www_dir does not exist"
        return 1
    fi
    
    /usr/bin/echo "Checking and creating missing access log files..."
    
    # Duyet qua tat ca cac domain directory
    for domain_dir in "$www_dir"/*; do
        # Chi xu ly neu la directory
        if [ -d "$domain_dir" ]; then
            local domain_name=$(basename "$domain_dir")
            local error_log="$log_dir/$domain_name.error.log"
            local access_log="$log_dir/$domain_name.log"
            
            # Neu co error log nhung chua co access log thi tao moi
            if [ -f "$error_log" ] && [ ! -f "$access_log" ]; then
                /usr/bin/echo "Creating access log for domain: $domain_name"
                /usr/bin/echo "# Access log created on $(/usr/bin/date)" > "$access_log"
                created_files=$((created_files + 1))
            fi
        fi
    done
    
    # Luon phan quyen cho tat ca log files de dam bao consistency
    /usr/bin/echo "Setting permissions for all log files..."
    cd "$log_dir" || return 1
    
    # Phan quyen cho tat ca log files
    /usr/bin/find . -type f -name "*.log" -exec /usr/bin/chmod 644 {} \; 2>/dev/null
    /usr/bin/find . -type f -name "*.log" -exec /usr/bin/chown www:www {} \; 2>/dev/null
    
    # Quay ve thu muc goc
    cd ~ || return 1
    
    if [ $created_files -gt 0 ]; then
        /usr/bin/echo "Created $created_files new access log files"
    else
        /usr/bin/echo "No new access log files needed"
    fi
    
    /usr/bin/echo "Log file permissions updated successfully"
    return 0
}
# create_file_access_log



# Kiem tra va xu ly cac file log co dung luong lon (chay moi ngay 1 lan)
manage_large_log_files() {
    local log_dir="/www/wwwlogs"
    local max_size_mb=10
    local today_date=$(/usr/bin/date +%Y-%m-%d)
    local daily_log="/tmp/cronjob-1day-$today_date.log"
    
    /usr/bin/echo "Starting daily log file management..."
    /usr/bin/echo "Daily log file: $daily_log"
    
    # Kiem tra thu muc log co ton tai khong
    if [ ! -d "$log_dir" ]; then
        /usr/bin/echo "Warning: Log directory $log_dir does not exist"
        return 1
    fi
    
    # Neu file log ngay hom nay da ton tai thi bo qua
    if [ -f "$daily_log" ]; then
        /usr/bin/echo "Daily log file already exists, skipping log management for today"
        return 0
    fi
    
    # Xoa cac file log cu
    /usr/bin/rm -rf /tmp/cronjob-1day-*.log
    
    # Tao file log moi cho ngay hom nay
    /usr/bin/echo "# Daily log file created on $(/usr/bin/date)" > "$daily_log"
    /usr/bin/echo "# Log management started at $(/usr/bin/date)" >> "$daily_log"
    
    local processed_files=0
    local large_files_found=0
    
    # Duyet qua tat ca cac file log (chi access log, khong phai error log)
    for log_file in "$log_dir"/*.log; do
        # Kiem tra file co ton tai va khong phai la glob pattern
        if [ ! -f "$log_file" ]; then
            continue
        fi
        
        local filename=$(basename "$log_file")
        
        # Bo qua error log files
        if [[ "$filename" == *".error.log" ]]; then
            /usr/bin/echo "Skipping error log: $filename" >> "$daily_log"
            continue
        fi
        
        # Chi xu ly access log files (.log nhung khong phai .error.log)
        if [[ "$filename" == *.log ]]; then
            processed_files=$((processed_files + 1))
            
            # Lay thong tin dung luong file
            local size_info=$(du -sh "$log_file" 2>/dev/null)
            /usr/bin/echo "Checking: $log_file - Size: $size_info" >> "$daily_log"
            
            # Kiem tra neu file co dung luong lon hon 10MB
            if [[ "$size_info" == *"M"* ]]; then
                # Tach so MB tu output cua du command
                local size_mb=$(echo "$size_info" | grep -oE '[0-9]+\.?[0-9]*' | head -1)
                
                # Lam tron xuong (chi lay phan nguyen)
                size_mb=${size_mb%.*}
                
                if [ -n "$size_mb" ] && [ "$size_mb" -gt "$max_size_mb" ]; then
                    large_files_found=$((large_files_found + 1))
                    
                    /usr/bin/echo "Found large log file: $log_file (${size_mb}MB)" >> "$daily_log"
                    /usr/bin/echo "Processing large log file: $log_file (${size_mb}MB)"
                    
                    # Gui thong tin den server
                    if /usr/bin/curl -k -X POST -d "f=$log_file&dl=$size_mb" https://echbay.com/?act=daily_domain_access 2>/dev/null; then
                        /usr/bin/echo "Successfully sent log info to server" >> "$daily_log"
                    else
                        /usr/bin/echo "Failed to send log info to server" >> "$daily_log"
                    fi
                    
                    # Reset file log thay vi xoa hoan toan
                    /usr/bin/echo "# Log file reset on $(/usr/bin/date) - Previous size: ${size_mb}MB" > "$log_file"
                    /usr/bin/echo "Log file $log_file has been reset" >> "$daily_log"
                    
                    # Xoa file daily log de cho phep xu ly tiep tuc trong lan chay tiep theo
                    /usr/bin/rm -f /tmp/cronjob-1day-*.log
                    
                    /usr/bin/echo "Breaking loop after processing one large file"
                    break
                fi
            fi
        fi
    done
    
    # Ghi ket qua vao log
    /usr/bin/echo "# Summary: Processed $processed_files files, found $large_files_found large files" >> "$daily_log"
    /usr/bin/echo "# Log management completed at $(/usr/bin/date)" >> "$daily_log"
    
    /usr/bin/echo "Daily log management completed. Processed: $processed_files files, Large files: $large_files_found"
    return 0
}

# Chay ham quan ly log files
manage_large_log_files


# Quan ly gia han chung chi SSL Let's Encrypt (chay moi ngay 1 lan)
manage_ssl_renewal() {
    local today_date=$(/usr/bin/date +%Y-%m-%d)
    local daily_ssl_log="/tmp/cronjob-daily-$today_date.log"
    local acme_script="/www/server/panel/class/acme_v2.py"
    local python_path="/www/server/panel/pyenv/bin/python3"
    
    /usr/bin/echo "Starting SSL certificate renewal management..."
    /usr/bin/echo "Daily SSL log: $daily_ssl_log"
    
    # Kiem tra xem file acme script co ton tai khong
    if [ ! -f "$acme_script" ]; then
        /usr/bin/echo "Warning: ACME script not found at $acme_script"
        return 1
    fi
    
    # Kiem tra xem python co ton tai khong
    if [ ! -f "$python_path" ]; then
        /usr/bin/echo "Warning: Python not found at $python_path"
        return 1
    fi
    
    # Neu file log ngay hom nay da ton tai thi bo qua
    if [ -f "$daily_ssl_log" ]; then
        /usr/bin/echo "SSL renewal already completed today, skipping..."
        return 0
    fi
    
    # Xoa cac file log cu
    /usr/bin/rm -rf /tmp/cronjob-daily-*.log
    
    # Tao file log moi cho ngay hom nay
    /usr/bin/echo "# SSL renewal log for $today_date" > "$daily_ssl_log"
    /usr/bin/echo "# SSL renewal started at $(/usr/bin/date)" >> "$daily_ssl_log"
    
    local renewal_success=0
    local renewal_errors=0
    
    /usr/bin/echo "Running daily SSL certificate renewal..."
    
    # 1. Renew Let's Encrypt v3 certificates
    /usr/bin/echo "=== Let's Encrypt v3 Certificate Renewal ===" >> "$daily_ssl_log"
    /usr/bin/echo "Starting Let's Encrypt v3 certificate renewal..."
    
    if "$python_path" -u "$acme_script" --renew_v3=1 >> "$daily_ssl_log" 2>&1; then
        /usr/bin/echo "Let's Encrypt v3 renewal completed successfully" >> "$daily_ssl_log"
        /usr/bin/echo "Let's Encrypt v3 certificates renewed successfully"
        renewal_success=$((renewal_success + 1))
    else
        /usr/bin/echo "Let's Encrypt v3 renewal failed or had issues" >> "$daily_ssl_log"
        /usr/bin/echo "Warning: Let's Encrypt v3 renewal had issues"
        renewal_errors=$((renewal_errors + 1))
    fi
    
    # 2. Renew Let's Encrypt v2 certificates  
    /usr/bin/echo "=== Let's Encrypt v2 Certificate Renewal ===" >> "$daily_ssl_log"
    /usr/bin/echo "Starting Let's Encrypt v2 certificate renewal..."
    
    if "$python_path" -u "$acme_script" --renew_v2=1 >> "$daily_ssl_log" 2>&1; then
        /usr/bin/echo "Let's Encrypt v2 renewal completed successfully" >> "$daily_ssl_log"
        /usr/bin/echo "Let's Encrypt v2 certificates renewed successfully"
        renewal_success=$((renewal_success + 1))
    else
        /usr/bin/echo "Let's Encrypt v2 renewal failed or had issues" >> "$daily_ssl_log"
        /usr/bin/echo "Warning: Let's Encrypt v2 renewal had issues"
        renewal_errors=$((renewal_errors + 1))
    fi
    
    # Ghi ket qua vao log
    /usr/bin/echo "=== SSL Renewal Summary ===" >> "$daily_ssl_log"
    /usr/bin/echo "Successful renewals: $renewal_success" >> "$daily_ssl_log"
    /usr/bin/echo "Failed renewals: $renewal_errors" >> "$daily_ssl_log"
    /usr/bin/echo "# SSL renewal completed at $(/usr/bin/date)" >> "$daily_ssl_log"
    
    /usr/bin/echo "SSL renewal completed. Success: $renewal_success, Errors: $renewal_errors"
    
    # Return 0 if at least one renewal succeeded, 1 if all failed
    if [ $renewal_success -gt 0 ]; then
        return 0
    else
        return 1
    fi
}

# Chay quan ly gia han SSL
# manage_ssl_renewal


# Quan ly cac tac vu hang tuan cho WordPress (chay moi Thu Hai)
manage_wordpress_weekly_tasks() {
    local enable_wp_update=1  # Thay doi thanh 0 de tat tinh nang
    local today_weekday=$(/usr/bin/date +%u)  # 1=Monday, 7=Sunday
    local current_week=$(/usr/bin/date +%Y-%V)
    local weekly_log="/tmp/cronjob-1week-$current_week.log"
    
    /usr/bin/echo "Starting WordPress weekly tasks management..."
    /usr/bin/echo "Today is weekday: $today_weekday (1=Monday)"
    /usr/bin/echo "Current week: $current_week"
    
    # Kiem tra xem co cho phep update WordPress khong
    if [ $enable_wp_update -ne 1 ]; then
        /usr/bin/echo "WordPress auto-update is disabled (enable_wp_update=$enable_wp_update)"
        return 0
    fi
    
    # Chi chay vao Thu Hai (weekday = 1)
    if [ $today_weekday -ne 1 ]; then
        /usr/bin/echo "WordPress tasks only run on Monday. Current weekday: $today_weekday"
        return 0
    fi
    
    # Kiem tra xem tuan nay da chay chua
    if [ -f "$weekly_log" ]; then
        /usr/bin/echo "WordPress weekly tasks already completed for week $current_week"
        return 0
    fi
    
    # Xoa cac file log tuan cu
    /usr/bin/rm -rf /tmp/cronjob-1week-*.log
    
    # Tao file log cho tuan nay
    /usr/bin/echo "# WordPress weekly tasks log for week $current_week" > "$weekly_log"
    /usr/bin/echo "# Started at $(/usr/bin/date)" >> "$weekly_log"
    
    /usr/bin/echo "Running WordPress weekly maintenance tasks..."
    
    # 1. Update WordPress core and plugins
    /usr/bin/echo "=== WordPress Core & Plugin Updates ===" >> "$weekly_log"
    /usr/bin/echo "Starting WordPress updates for all sites..."
    
    if /usr/bin/bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/script/vpssim/menu/tienich/update-wordpress-for-all-site-auto.sh ) >> "$weekly_log" 2>&1; then
        /usr/bin/echo "WordPress updates completed successfully" >> "$weekly_log"
        /usr/bin/echo "WordPress updates completed successfully"
    else
        /usr/bin/echo "WordPress updates failed or had issues" >> "$weekly_log"
        /usr/bin/echo "Warning: WordPress updates had issues"
    fi
    
    # 2. Malware scan
    /usr/bin/echo "=== WordPress Malware Scan ===" >> "$weekly_log"
    /usr/bin/echo "Starting malware scan for all WordPress sites..."
    
    # Tao file config cho malware scanner
    local scan_config="/tmp/server_wp_all_scan"
    cat > "$scan_config" << EOF
# Malware scan configuration
root_dir=/www/wwwroot
MaxCheck=3
checkWgrCode=0
# displayLog=0
EOF
    
    if /usr/bin/bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/script/vpssim/menu/tienich/scan-wordpress-malware.sh ) >> "$weekly_log" 2>&1; then
        /usr/bin/echo "Malware scan completed successfully" >> "$weekly_log"
        /usr/bin/echo "Malware scan completed successfully"
    else
        /usr/bin/echo "Malware scan failed or had issues" >> "$weekly_log"
        /usr/bin/echo "Warning: Malware scan had issues"
    fi
    
    # 3. Create .user.ini files if not exist
    /usr/bin/echo "=== .user.ini File Management ===" >> "$weekly_log"
    /usr/bin/echo "Creating missing .user.ini files..."
    
    if /usr/bin/bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/aapanel/create-user-ini-if-not-exist.sh ) >> "$weekly_log" 2>&1; then
        /usr/bin/echo ".user.ini creation completed successfully" >> "$weekly_log"
        /usr/bin/echo ".user.ini files created successfully"
    else
        /usr/bin/echo ".user.ini creation failed or had issues" >> "$weekly_log"
        /usr/bin/echo "Warning: .user.ini creation had issues"
    fi
    
    # 4. Set permissions for .user.ini files
    /usr/bin/echo "Setting permissions for .user.ini files..."
    
    if /usr/bin/bash <( curl -k https://raw.echbay.com/itvn9online/vpssim-free/master/aapanel/chown-user-ini.sh ) >> "$weekly_log" 2>&1; then
        /usr/bin/echo ".user.ini permissions set successfully" >> "$weekly_log"
        /usr/bin/echo ".user.ini permissions set successfully"
    else
        /usr/bin/echo ".user.ini permission setting failed or had issues" >> "$weekly_log"
        /usr/bin/echo "Warning: .user.ini permission setting had issues"
    fi
    
    # Cleanup temporary files
    /usr/bin/rm -f "$scan_config"
    
    # Ghi ket thuc vao log
    /usr/bin/echo "# WordPress weekly tasks completed at $(/usr/bin/date)" >> "$weekly_log"
    /usr/bin/echo "WordPress weekly maintenance tasks completed for week $current_week"
    
    return 0
}

# Chay cac tac vu hang tuan cho WordPress
manage_wordpress_weekly_tasks


# Script ket thuc, lock se duoc tu dong giai phong boi trap
