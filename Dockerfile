FROM jupyter/all-spark-notebook:latest

USER root

# Instalando o que falta para o Lakehouse
RUN pip install --no-cache-dir duckdb delta-spark==3.1.0 \ pygwalker \
    streamlit \
    plotly \
    seaborn

# Pasta padrão dessa imagem já é /home/jovyan/work
WORKDIR /home/jovyan/work


RUN chmod -R 777 /home/jovyan/work


EXPOSE 8888

# O comando padrão dessa imagem já sobe o Jupyter, então nem precisamos de CMD

