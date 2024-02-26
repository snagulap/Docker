<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'srini' );

/** Database password */
define( 'DB_PASSWORD', '1234' );

/** Database hostname */
define( 'DB_HOST', 'mariadb' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',          'XT/%ijfwtk-x3h`tso{IR^BF0m.IPgt/L*PpRH=L=fm$C9/VL9,BuaB,sFjWUFHZ' );
define( 'SECURE_AUTH_KEY',   '{Rw!ed1Ang~~mnlouLn+A;sz6RH!8llY:Dzlp2%z}2~goT*Y*/7uH42kR/%mpI5T' );
define( 'LOGGED_IN_KEY',     'tQa/m/j|xSq^)<P,-P_;qL9+$qLdlB3!#kF:J#?%4)de|Htr-w[<Ys1/-mC.v=CM' );
define( 'NONCE_KEY',         'lm4=8+j*)Q5jCE+ht!>A3sd_B4Y *3|ZHjvd8ub8gi_Eagl:KOAV )X:jtaS>S`Q' );
define( 'AUTH_SALT',         '=}H^ezEG)u#JnA>Q4&~?~WLR7{SzGcd}?ajZ(#5]>^z&V(z_)Zn;MK9E_Im:b}FA' );
define( 'SECURE_AUTH_SALT',  'k;V3YL$Pl3aTqN]|sS^K8`MuRW-go.crml!;NG&UVFT8*>Q6&0hnWIm,w]`=c(cn' );
define( 'LOGGED_IN_SALT',    'vkVvh6)$<^q9< +)a&Ht-@tQ+IFB^?P&I:+-b`w/r~yfgk%`6R<4S=K$)(|[VvAR' );
define( 'NONCE_SALT',        'i,J1Ay{/#[#$?(5K@!n{O(+(Hq>U(A*%KA!gQ:j>QKEoNo,BTcA<:rfZU~BDw*=a' );
define( 'WP_CACHE_KEY_SALT', 'i+WvAa.{6BGx}6aoj?Ie{fBI_O]6RHXTfV(IpFy]$EXWx8|OPtsj+f<kY=~{GB-p' );


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Add any custom values between this line and the "stop editing" line. */



/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
if ( ! defined( 'WP_DEBUG' ) ) {
	define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
