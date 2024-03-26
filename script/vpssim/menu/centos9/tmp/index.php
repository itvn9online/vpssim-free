<p>Webcome to EchBay Hosting!</p>
<p>Domain: <?php echo $_SERVER['HTTP_HOST']; ?></p>
<p>Your IP: <?php echo (isset($_SERVER['HTTP_X_FORWARDED_FOR']) ? $_SERVER['HTTP_X_FORWARDED_FOR'] : (isset($_SERVER['HTTP_CF_CONNECTING_IP']) ? $_SERVER['HTTP_CF_CONNECTING_IP'] : $_SERVER['REMOTE_ADDR'])); ?> (<?php echo $_SERVER['REMOTE_ADDR']; ?>)</p>
<p>User agent: <?php echo (isset($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : ''); ?></p>
<p>PHP version: <?php echo phpversion(); ?></p>
<p>Server software: <?php echo $_SERVER['SERVER_SOFTWARE']; ?></p>