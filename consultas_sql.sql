-- Índice Proprietário de Reputação — modelagem em SQL
-- Reproduz, em nível de banco de dados, o mesmo cálculo feito na planilha Reputation_Index_Scoring.xlsx
-- Dados fictícios, apenas para fins de demonstração de portfólio.

-- 1) Tabela de origem: inputs brutos por marca (equivalente à aba Base_Marcas)
CREATE TABLE base_marcas (
    marca                VARCHAR(60) PRIMARY KEY,
    setor                VARCHAR(40),
    destaque             DECIMAL(4,1),
    formato_noticia      DECIMAL(4,1),
    espaco_dedicado      DECIMAL(4,1),
    tipo_atendimento     DECIMAL(4,1),
    mensagem_chave       DECIMAL(4,1),
    fator_visibilidade   DECIMAL(4,1),
    fator_valoracao      DECIMAL(4,1)
);

-- 2) View de scoring: calcula os dois eixos, o score final e classifica o quadrante
CREATE VIEW vw_scoring_reputacao AS
SELECT
    marca,
    setor,
    ROUND((destaque + formato_noticia + espaco_dedicado + tipo_atendimento + mensagem_chave) / 5.0, 1)
        AS score_narrativa,
    ROUND((fator_visibilidade + fator_valoracao) / 2.0, 1)
        AS score_atratividade,
    ROUND(
        (
            (destaque + formato_noticia + espaco_dedicado + tipo_atendimento + mensagem_chave) / 5.0
            + (fator_visibilidade + fator_valoracao) / 2.0
        ) / 2.0
    , 1) AS score_final,
    CASE
        WHEN (destaque + formato_noticia + espaco_dedicado + tipo_atendimento + mensagem_chave) / 5.0 >= 5
             AND (fator_visibilidade + fator_valoracao) / 2.0 >= 5
            THEN 'Reputação Consolidada'
        WHEN (destaque + formato_noticia + espaco_dedicado + tipo_atendimento + mensagem_chave) / 5.0 < 5
             AND (fator_visibilidade + fator_valoracao) / 2.0 >= 5
            THEN 'Risco Narrativo'
        WHEN (destaque + formato_noticia + espaco_dedicado + tipo_atendimento + mensagem_chave) / 5.0 >= 5
             AND (fator_visibilidade + fator_valoracao) / 2.0 < 5
            THEN 'Oportunidade Latente'
        ELSE 'Baixa Relevância'
    END AS quadrante
FROM base_marcas;

-- 3) Benchmarking: ranking geral por score final
SELECT
    RANK() OVER (ORDER BY score_final DESC) AS posicao,
    marca,
    setor,
    score_narrativa,
    score_atratividade,
    score_final,
    quadrante
FROM vw_scoring_reputacao
ORDER BY posicao;

-- 4) Distribuição de marcas por quadrante (apoio para o benchmarking competitivo)
SELECT
    quadrante,
    COUNT(*) AS qtd_marcas,
    ROUND(AVG(score_final), 1) AS score_medio
FROM vw_scoring_reputacao
GROUP BY quadrante
ORDER BY score_medio DESC;
