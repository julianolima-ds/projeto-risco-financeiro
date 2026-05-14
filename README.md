# Análise de Risco Financeiro: Pipeline SQL, Python e Power BI

Este projeto simula um cenário real de análise de risco de crédito, onde estruturei um pipeline de dados automatizado para monitorar o comportamento de pagamento de clientes.

## 🚀 Tecnologias Utilizadas
* **Banco de Dados:** MySQL (Modelagem Relacional)
* **Linguagem:** Python 3.12.4
* **Bibliotecas:** Pandas, SQLAlchemy, mysql-connector-python
* **Visualização:** Power BI
* **Editor de Código:** VS Code

## 🛠️ O Pipeline de Dados (ETL)
O projeto consiste em um fluxo completo de dados:
1.  **Extração (SQL):** Os dados são consultados diretamente do banco MySQL através de JOINs entre as tabelas de Clientes, Contratos e Pagamentos.
2.  <img width="1915" height="1029" alt="image" src="https://github.com/user-attachments/assets/eae870ba-e49b-4dfe-b705-25ae9c76a836" />

3.  **Transformação (Python):** Eu utilizei Python para automatizar a limpeza, calcular o volume de atraso por cliente e criar uma lógica de classificação de Score personalizada (Excelente, Alto, Médio e Crítico).
4.  <img width="1911" height="1032" alt="image" src="https://github.com/user-attachments/assets/d57ec27e-2f53-463c-a316-d0acb8cdd448" />

5.  **Carga (CSV/Power BI):** Os dados são exportados em formato otimizado (UTF-8-SIG e delimitador de ponto e vírgula) para garantir integridade na leitura do Power BI e compatibilidade com Excel.
6.  <img width="1905" height="1027" alt="image" src="https://github.com/user-attachments/assets/7a6fb449-1191-440c-95e8-56a7e422eaf7" />


## 📊 O Dashboard
O dashboard permite visualizar:
* **Indicadores Financeiros:** Total pago vs. Total em atraso.
* **Análise de Risco:** Distribuição de clientes por faixa de Score.
* **Geolocalização:** Identificação de inadimplência por região.
* **Ordenação Lógica:** Hierarquia de risco personalizada para facilitar a tomada de decisão.

## 🧠 Desafios Superados
* Configuração de codificação de caracteres para evitar erros em termos acentuados.
* Manipulação do Power Query para aceitar colunas dinâmicas via script.
* Sincronização de dados entre banco relacional e ferramenta de BI.

---
Desenvolvido por [Juliano Lima](https://github.com/julianolima-ds) 🚀
