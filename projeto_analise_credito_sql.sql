-- =============================================================================
-- PROJETO: ANALISE DE RISCO FINANCEIRO E INADIMPLÊNCIA
-- OBJETIVO: Monitorar pagamentos, classificar risco de clientes e gerar KPIs.
-- ANALISTA: Juliano Lima
-- =============================================================================

-- 1. CONFIGURAÇÃO INICIAL E LIMPEZA
-- Garante que o script rode do zero sem conflitos de tabelas existentes.
CREATE DATABASE IF NOT EXISTS projeto_financas;
USE projeto_financas;

DROP TABLE IF EXISTS Pagamentos;
DROP TABLE IF EXISTS Contratos;
DROP TABLE IF EXISTS Clientes;

-- 2. ESTRUTURAÇÃO DO BANCO DE DATAS (DDL)
-- Criação das tabelas com Chaves Primárias (PK) e Estrangeiras (FK).

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    nome_cliente VARCHAR(100),
    data_nascimento DATE,
    renda_mensal DECIMAL(10,2),
    score_credito INT,
    cidade VARCHAR(50)
);

CREATE TABLE Contratos (
    id_contrato INT PRIMARY KEY,
    id_cliente INT,
    data_contratacao DATE,
    valor_total DECIMAL(10,2),
    quantidade_parcelas INT,
    status_contrato VARCHAR(20),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Pagamentos (
    id_pagamento INT PRIMARY KEY,
    id_contrato INT,
    data_vencimento DATE,
    data_pagamento DATE, -- Se NULL, indica que o boleto não foi pago ainda.
    valor_parcela DECIMAL(10,2),
    status_pagamento VARCHAR(20),
    FOREIGN KEY (id_contrato) REFERENCES Contratos(id_contrato)
);

-- 3. POPULANDO O SISTEMA (DML)
-- Inserção de dados simulados para testes de lógica.

INSERT INTO Clientes VALUES
(1, 'Carlos Silva', '1985-05-20', 5500.00, 850, 'São Paulo'),
(2, 'Mariana Souza', '1992-08-12', 3200.00, 450, 'Rio de Janeiro'),
(3, 'Roberto Gomes', '1978-03-30', 8900.00, 920, 'Curitiba'),
(4, 'Juliana Paes', '2000-01-15', 2100.00, 300, 'Salvador'),
(5, 'Ricardo Alves', '1988-11-25', 4500.00, 600, 'Brasilia'); -- Novo cliente Score 600 (Alto)

INSERT INTO Contratos VALUES
(101, 1, '2024-01-10', 12000.00, 12, 'Ativo'),
(102, 2, '2024-02-05', 5000.00, 5, 'Ativo'),
(103, 3, '2023-11-20', 25000.00, 24, 'Ativo'),
(104, 4, '2024-03-01', 3000.00, 3, 'Ativo'),
(105, 5, '2024-04-01', 5000.00, 5, 'Ativo');

INSERT INTO Pagamentos VALUES
(1, 101, '2024-02-10', '2024-02-10', 1000.00, 'Pago'),
(2, 101, '2024-03-10', '2024-03-08', 1000.00, 'Pago'),
(3, 102, '2024-03-05', '2024-03-05', 1000.00, 'Pago'),
(4, 102, '2024-04-05', NULL, 1000.00, 'Atrasado'),
(5, 104, '2024-04-01', NULL, 1000.00, 'Atrasado'),
(6, 105, '2024-05-01', NULL, 1000.00, 'Atrasado');

-- 4. INTELIGÊNCIA DE DADOS (VIEWS)
-- Criando uma camada de resumo para facilitar o consumo por ferramentas de BI.

CREATE OR REPLACE VIEW vw_resumo_financeiro AS
SELECT 
    c.nome_cliente,
    c.renda_mensal,
    c.score_credito,
    SUM(CASE WHEN p.status_pagamento = 'Pago' THEN p.valor_parcela ELSE 0 END) AS total_pago,
    SUM(CASE WHEN p.status_pagamento = 'Atrasado' THEN p.valor_parcela ELSE 0 END) AS total_em_atraso
FROM Clientes c
INNER JOIN Contratos ct ON c.id_cliente = ct.id_cliente
INNER JOIN Pagamentos p ON ct.id_contrato = p.id_contrato
GROUP BY c.nome_cliente, c.renda_mensal, c.score_credito;

-- 5. RELATÓRIOS E ANALYTICS
-- Consultas focadas em tomada de decisão.

-- A) Ranking de Risco por Cliente
-- A) Ranking de Risco por Cliente (Nova Escala)
SELECT 
    nome_cliente,
    score_credito,
    total_em_atraso,
    CASE 
        WHEN score_credito > 700 THEN 'Excelente'
        WHEN score_credito BETWEEN 501 AND 700 THEN 'Alto'
        WHEN score_credito BETWEEN 301 AND 500 THEN 'Médio'
        ELSE 'Crítico'
    END AS faixa_score -- Nomeando como faixa_score para o Power BI
FROM vw_resumo_financeiro
ORDER BY score_credito DESC;

-- B) KPI de Inadimplência Geral (Métrica de Negócio)
SELECT 
    CONCAT(ROUND((SUM(total_em_atraso) / (SUM(total_pago) + SUM(total_em_atraso))) * 100, 2), '%') AS taxa_inadimplencia_geral
FROM vw_resumo_financeiro;

-- 6. Soma de tudo que ja foi pago fluxo_caixa_real/ Soma de tudo que está Atrasado prejuizo_potencial
SELECT 
    SUM(total_pago) AS fluxo_caixa_real,
    SUM(total_em_atraso) AS prejuizo_potencial
FROM vw_resumo_financeiro;

-- 7. ANÁLISE GEOGRÁFICA: Onde está o maior prejuízo?
SELECT 
    c.cidade,
    SUM(CASE WHEN p.status_pagamento = 'Pago' THEN p.valor_parcela ELSE 0 END) AS total_recebido,
    SUM(CASE WHEN p.status_pagamento = 'Atrasado' THEN p.valor_parcela ELSE 0 END) AS prejuizo_potencial,
    COUNT(CASE WHEN p.status_pagamento = 'Atrasado' THEN 1 END) AS qtd_clientes_inadimplentes
FROM Clientes c
INNER JOIN Contratos ct ON c.id_cliente = ct.id_cliente
INNER JOIN Pagamentos p ON ct.id_contrato = p.id_contrato
GROUP BY c.cidade
ORDER BY prejuizo_potencial DESC;

USE projeto_financas;
