# Case Ambev - Engenharia de Dados (Martech)

Este repositório contém a solução para o Business Case 1 (Beverage Sales). O objetivo do projeto é a transformação de arquivos brutos (CSVs com encoding e tipos genéricos) em uma estrutura de Lakehouse modelada para responder KPIs de negócio com performance e rastreabilidade.

---

### Tech Stack
* Linguagem: PySpark (Spark 3.x) - Escolhido pela escalabilidade e poder de processamento distribuído exigidos no case.
* Armazenamento: Delta Lake (Garante transações ACID e facilita o versionamento das camadas).
* Infraestrutura: Docker + Jupyter Lab (Ambiente isolado e reprodutível).


---

## Entregas de Negócio (KPIs)

 A camada Gold está preparada para responder: 
* **Top 3 Trade Groups** por Região (usando Window Functions). 
* **Volume de vendas mensal** consolidado por Marca. 
* **Lowest Performance Brands** por Região para ações de Trade Marketing. 

---

##  Arquitetura e Camadas (Medallion)

O pipeline orquestra o ciclo de vida do dado através de camadas persistidas em formato Delta, garantindo a linhagem do dado (Data Lineage): 

1.  **Landing Zone:** Zona de pouso dos arquivos originais (`.csv`) preservando a imutabilidade da fonte. 
2.  **Bronze (Raw/Sanitized):** Ingestão com **Schema Enforcement** via `StructType`. Resolvemos problemas de encoding (UTF-16/Latin1) e delimitadores específicos. 
3.  **Silver (Standardized):** Higienização profunda, remoção de duplicatas (`dropDuplicates`), tratamento de nulos (`na.drop`) e padronização de nomenclatura (snake_case).
4.  **Gold (Curated/Analytics):** Modelagem **Star Schema** (Fatos e Dimensões). Inclui enriquecimento de calendário e expansão de granularidade de canais via `explode`. 

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



### Opção 2: Setup Automático (Recomendado)
Se você estiver no Windows ou Linux, use os scripts de automação inclusos:
* **Windows (PowerShell):** `./setup.ps1`
* **Linux/WSL2 (Bash):** `chmod +x setup.sh && ./setup.sh`

---

### Fluxo de Execução
Os notebooks estão numerados para indicar a dependência de dados:

* 01_bronze_ingestion.ipynb: Leitura dos CSVs e persistência em Delta. Realiza o tratamento de NaN na coluna CE_BRAND_FLVR e a conversão inicial de volume.
* 02_silver_cleaning.ipynb: Aplica as regras de padronização e limpeza de canais e marcas.
* 03_gold_business.ipynb: Realiza o JOIN final e responde às perguntas de negócio, como o Top 3 Trade Groups por Região e as vendas mensais por marca.

---


## Segurança e Boas Práticas
* **Isolamento:** Processos rodando com usuário não-privilegiado (`jovyan`). 
* **Integridade:** Uso de logs do Delta Lake para auditoria e prevenção de corrupção de arquivos.
* **Modularização:** Uso de `%run` para reaproveitamento de funções de Spark Session e caminhos. 


---

### Decisões Técnicas
* Sanitização na Ingestão: Optou-se por tratar o encoding (UTF-16) e headers diretamente na camada Bronze para evitar erros de cast em etapas posteriores.
* Resiliência do Pipeline: Uso de DROPMALFORMED e regexp_replace para garantir que inconsistências no CSV (como vírgulas em campos numéricos) não interrompam o processamento.
* Modelagem Dimensional: A camada Gold foi estruturada em Star Schema para otimizar o consumo por ferramentas de analytics e responder aos KPIs do case com eficiência.


---
*Desenvolvido como um MVP de Engenharia de Dados para o processo seletivo ABInBev/NTT.* 