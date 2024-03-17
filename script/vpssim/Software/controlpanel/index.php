<?php

/**
 * Control panel
 * Copy code to /home/vpssim.demo/private_html and run
 * Code công cụ quản trị hosting
 */

//
include '/etc/vpssim/defaulpassword.php';
if (defined('ADMIN_USERNAME') && ADMIN_USERNAME != '') {
    if (
        !isset($_SERVER['PHP_AUTH_USER'])
        || !isset($_SERVER['PHP_AUTH_PW'])
        || $_SERVER['PHP_AUTH_USER'] != ADMIN_USERNAME
        || $_SERVER['PHP_AUTH_PW'] != ADMIN_PASSWORD
    ) {
        Header("WWW-Authenticate: Basic realm=\"View Server Status Login\"");
        Header("HTTP/1.0 401 Unauthorized");

        // 
        die('Permission deny!');
    }
}

// 
error_reporting(1);
header("content-Type: text/html; charset=utf-8");

// 
die(__FILE__ . ':' . __LINE__);
