<?php
// Merge into the real wp-config.php. Never commit credentials or salts.
define('DISALLOW_FILE_EDIT', true);
define('WP_DEBUG', true);
define('WP_DEBUG_DISPLAY', false);
define('WP_DEBUG_LOG', true);
// Example only. Existing sites require a planned DB/table migration before changing this.
$table_prefix = 'site_sec7_';
