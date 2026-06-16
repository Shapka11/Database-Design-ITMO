CREATE TABLE default.queue_house_point_logs
(
    value String
) ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'pg_cdc.public.house_point_logs',
    kafka_group_name = 'clickhouse_group_shapovalov',
    kafka_format = 'JSONAsString';