FROM apache/airflow:3.1.5-python3.10

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-17-jdk wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV SPARK_VERSION=4.1.0
ENV SPARK_HOME=/opt/spark
ENV PATH="$SPARK_HOME/bin:$PATH"
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

RUN wget -q https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz -C /opt/ && \
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop3 $SPARK_HOME && \
    rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

USER airflow

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir \
    "pyspark==4.1.0" \
    "grpcio-status" \
    "apache-airflow-providers-common-compat==1.10.1" \
    "apache-airflow-providers-apache-spark==5.4.1"