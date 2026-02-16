FROM jupyter/all-spark-notebook:latest

USER root


RUN curl https://jdbc.postgresql.org/download/postgresql-42.5.0.jar -o /usr/local/spark/jars/postgresql-42.5.0.jar

RUN curl https://repo1.maven.org/maven2/io/delta/delta-spark_2.12/3.1.0/delta-spark_2.12-3.1.0.jar -o /usr/local/spark/jars/delta-spark_2.12-3.1.0.jar \
    && curl https://repo1.maven.org/maven2/io/delta/delta-storage/3.1.0/delta-storage-3.1.0.jar -o /usr/local/spark/jars/delta-storage-3.1.0.jar

RUN pip install --no-cache-dir \
    duckdb \
    delta-spark==3.1.0 \
    pygwalker \
    streamlit \
    plotly \
    seaborn

WORKDIR /home/jovyan/work


RUN chmod -R 777 /home/jovyan/work


EXPOSE 8888 8501
