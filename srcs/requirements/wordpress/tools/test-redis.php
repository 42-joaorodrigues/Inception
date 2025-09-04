<?php
// Redis connection test for WordPress
if (extension_loaded('redis')) {
    try {
        $redis = new Redis();
        $redis->connect(getenv('WORDPRESS_REDIS_HOST') ?: 'redis', getenv('WORDPRESS_REDIS_PORT') ?: 6379);
        $redis->ping();
        echo "Redis connection: SUCCESS\n";
        echo "Redis info: " . $redis->info('server')['redis_version'] . "\n";
        $redis->close();
    } catch (Exception $e) {
        echo "Redis connection: FAILED - " . $e->getMessage() . "\n";
    }
} else {
    echo "Redis extension: NOT LOADED\n";
}
?>
