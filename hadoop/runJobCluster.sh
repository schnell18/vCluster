export HADOOP_USER_NAME=mapred
hadoop jar build/libs/MaxTemperatureDriver.jar \
       org.home.hadoop.MaxTemperatureDriver    \
       -conf src/main/resources/hadoop-pri.xml \
       /users/justin/ncdc_data                 \
       /users/justin/maxTemp
