MYSQL_HOST=127.0.0.1
MYSQL_PORT=3306

# Execute the following command to route the connection:
kubectl port-forward svc/mysql 3306

mysql -h ${MYSQL_HOST} -P${MYSQL_PORT} -u root -p${MYSQL_ROOT_PASSWORD}

