FROM mariadb:10.11

# Copy init script
COPY init.sql /docker-entrypoint-initdb.d/

# Expose MariaDB port
EXPOSE 3306
