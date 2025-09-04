FROM debian:bullseye

# Install Redis server
RUN apt-get update && apt-get install -y redis-server \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/lib/redis \
    && chown redis:redis /var/lib/redis

# Copy custom Redis configuration
COPY conf/redis.conf /etc/redis/redis.conf

# Set correct permissions
RUN chown redis:redis /etc/redis/redis.conf

EXPOSE 6379

# Switch to redis user for security
USER redis

# Start Redis server with custom config
ENTRYPOINT ["redis-server", "/etc/redis/redis.conf"]
