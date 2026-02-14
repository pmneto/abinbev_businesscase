# Case Ambev - Engenharia de Dados (Martech)

Este repositório contém a solução para o Business Case 1 (Beverage Sales). O objetivo do projeto é a transformação de arquivos brutos (CSVs com encoding e tipos genéricos) em uma estrutura de Lakehouse modelada para responder KPIs de negócio com performance e rastreabilidade.

---

### Tech Stack
* Linguagem: PySpark (Spark 3.x) - Escolhido pela escalabilidade e poder de processamento distribuído exigidos no case.
* Armazenamento: Delta Lake (Garante transações ACID e facilita o versionamento das camadas).
* Infraestrutura: Docker + Jupyter Lab (Ambiente isolado e reprodutível).

---

### Estrutura do Projeto
O projeto segue a Arquitetura Medallion para garantir a linhagem e a qualidade do dado:

1. Bronze (Ingestion): Ingestão dos CSVs originais com tratamento de encoding (latin1), sanitização de headers (limpeza de caracteres invisíveis e símbolos como $ e ï»¿) e tipagem inicial.
2. Silver (Refinement): Limpeza de strings (upper/trim), tratamento de nulos e de-duplicação de registros.
3. Gold (Business/Curated): Modelagem Dimensional (Star Schema) com tabelas de Dimensão e Fato, além de tabelas de resumo para os KPIs solicitados.

---

### Como subir o ambiente (Docker)
Para garantir a reprodutibilidade do ambiente Spark:

1. Clone o repositório e acesse a pasta:
    ```bash
    git clone <seu-repo-ssh>
    cd ambev_tech
    ```
2. Suba o container:
    ```bash
    docker-compose up -d
    ```
3. Acesse o Jupyter:
    Abra http://localhost:8888 no navegador. O token de acesso está disponível nos logs do container.

---

### Fluxo de Execução
Os notebooks estão numerados para indicar a dependência de dados:

* 01_bronze_ingestion.ipynb: Leitura dos CSVs e persistência em Delta. Realiza o tratamento de NaN na coluna CE_BRAND_FLVR e a conversão inicial de volume.
* 02_silver_cleaning.ipynb: Aplica as regras de padronização e limpeza de canais e marcas.
* 03_gold_business.ipynb: Realiza o JOIN final e responde às perguntas de negócio, como o Top 3 Trade Groups por Região e as vendas mensais por marca.



---

### Decisões Técnicas
* Sanitização na Ingestão: Optou-se por tratar o encoding (latin1) e headers diretamente na camada Bronze para evitar erros de cast em etapas posteriores.
* Resiliência do Pipeline: Uso de DROPMALFORMED e regexp_replace para garantir que inconsistências no CSV (como vírgulas em campos numéricos) não interrompam o processamento.
* Modelagem Dimensional: A camada Gold foi estruturada em Star Schema para otimizar o consumo por ferramentas de analytics e responder aos KPIs do case com eficiência.