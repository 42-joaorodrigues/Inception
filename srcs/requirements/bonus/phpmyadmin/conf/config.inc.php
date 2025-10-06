<?php
/**
 * phpMyAdmin configuration file
 */

// Prevent timeout
$cfg['LoginCookieValidity'] = 1440;

// Server configuration
$cfg['Servers'][1]['host'] = 'mariadb';
$cfg['Servers'][1]['port'] = '3306';
$cfg['Servers'][1]['socket'] = '';
$cfg['Servers'][1]['connect_type'] = 'tcp';
$cfg['Servers'][1]['extension'] = 'mysqli';
$cfg['Servers'][1]['auth_type'] = 'cookie';
$cfg['Servers'][1]['user'] = '';
$cfg['Servers'][1]['password'] = '';

// Allow user to override settings
$cfg['Servers'][1]['AllowUserDropDatabase'] = true;

// Blowfish secret for cookie auth
$cfg['blowfish_secret'] = 'inception-phpmyadmin-secret-key-42';

// Temporary directory
$cfg['TempDir'] = '/var/www/html/phpmyadmin/tmp';

// Default language
$cfg['DefaultLang'] = 'en';

// Theme
$cfg['ThemeDefault'] = 'pmahomme';

// SQL upload settings
$cfg['UploadDir'] = '';
$cfg['SaveDir'] = '';

// Security settings
$cfg['CheckConfigurationPermissions'] = false;
$cfg['ShowPhpInfo'] = false;
$cfg['ShowChgPassword'] = true;
$cfg['ShowCreateDb'] = true;

?>