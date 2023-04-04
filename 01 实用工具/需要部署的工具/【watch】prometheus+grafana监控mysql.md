
```toc
```

## 示例视频
https://www.bilibili.com/video/BV17T4y1r7W4/?spm_id_from=333.788&vd_source=ccbe0c793ac5e34ebb735794692f049e

## prometheus监控mysql架构图
![[prometheus监控mysql架构图.png]]


## 环境搭建
1.创建docker网桥
```bash
root@lwh:/home/liuwh# docker network create -d bridge my-bridge
4713bb14d6eb92c174f5c589e810ff9861e1a689ef94e72bc6d132a4edfa1718
```

2.创建数据库(当前步骤有问题 sql语法错误，创建表及用户授权目前是创建数据库后手动添加，并且数据库首次创建后可能因为sql脚本问题 导致会初始化失败，且grafana数据不显示)

```mysql
mkdir -p /etc/mysql/init.d

cat > /etc/mysql/init.d/schema.sql << 'EOF'
SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS,UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS,FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE,SQL_MODE='TRADITIONAL';
DROP SCHEMA IF EXISTS `sakila`;
CREATE SCHEMA `sakila`;
USE `sakila`;
CREATE TABLE `actor`(
	actor_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	first_name VARCHAR(45) NOT NULL,
	last_name VARCHAR(45) NOT NULL,
	last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (actor_id),
	KEY idx_actor_last_name(last_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE USER remote@'%' IDENTIFIED with mysql_native_password BY 'remote';
grant all privileges on *.* to  'remote'@'%';
CREATE USER 'exporter'@'%' IDENTIFIED BY 'exporter';
GRANT PROCESS,REPLICATION CLIENT ON *.* to 'exporter'@'%';
GRANT SELECT ON performance_schema.* to 'exporter'@'%';
EOF
```

3.通过脚本创建docker mysql数据库

```bash
docker run \
	-p 3306:3306\
	--network my-bridge\
	--name db\
	-v /etc/mysql/init.d:/docker-entrypoint-initdb.d\
	-e MYSQL_ROOT_PASSWORD=root\
	-d mysql:8
```

4.通过脚本创建docker mysql_exporter

```bash
docker run -d\
	-p 9104:9104\
	--network my-bridge\
	--name mysql_exporter\
	-e DATA_SOURCE_NAME="exporter:exporter@(db:3306)/sakila"\
	prom/mysqld-exporter
```

5.创建Prometheus脚本
```bash
mkdir /etc/prometheus

cat > /etc/prometheus/prometheus.yml << 'EOF'
# my global config
global:
  # 设置抓取数据的时间间隔，间隔设置为每15秒一次。
  scrape_interval:     15s
  # 设定抓取数据的超时时间
  #scrape_timeout: 15s
  # 设置规则刷新，每15秒刷新一次规则。
  evaluation_interval: 15s

# 监控报警配置（需要额外安装 alertmanager组件
alerting:
  alertmanagers:
  - static_configs:
    # 设定alertmanager和prometheus交互的接口，即alertmanager监听的ip地址和端口，后续再配置
    - targets: 
      # - altermanager:9093

# 报警规则文件
rule_files:
  # - "first_rules.yml"

#Prometheus与抓取模块交互的接口配置
scrape_configs:
  # job一定要全局唯一, 采集 Prometheus 自身的 metrics
  - job_name: 'prometheus'
    static_configs:
    - targets: ["localhost:9090"]
#后续可配置文件自动发现功能，初次安装可以修改localhost为实际服务器IP地址
  - job_name: 'mysql_metrics'
    scrape_interval: 5s
    metrics_path: '/metrics'
    static_configs:
    - targets: ['mysql_exporter:9104']
EOF
```

6.创建docker Prometheus
```bash
docker run -d\
	-p 9090:9090\
	--name prometheus\
	-v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml\
	--network my-bridge\
	 bitnami/prometheus:latest
```

7.创建docker  grafana
```bash
docker run -d\
	-p 3000:3000\
	--name grafana\
	--network my-bridge\
	grafana/grafana
```

## 使用

后续补充