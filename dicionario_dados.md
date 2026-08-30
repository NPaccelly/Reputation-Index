# Dicionário de Dados — Índice Proprietário de Reputação

Case fictício de portfólio. Todas as marcas, setores e valores deste repositório são simulados e não representam clientes reais.

## Aba `Base_Marcas` (inputs brutos)

| Coluna | Tipo | Escala | Descrição |
|---|---|---|---|
| `Marca` | Texto | — | Nome fictício da marca avaliada |
| `Setor` | Texto | — | Setor de atuação da marca |
| `Destaque` | Numérico | 0–10 | Grau de destaque da marca na notícia (manchete, primeiro parágrafo, menção secundária) |
| `Formato da Notícia` | Numérico | 0–10 | Peso do formato editorial (matéria dedicada, nota, citação em pauta ampla) |
| `Espaço Dedicado` | Numérico | 0–10 | Proporção do conteúdo dedicada à marca dentro da peça |
| `Tipo de Atendimento` | Numérico | 0–10 | Qualidade do enquadramento (proativo/reativo, porta-voz, resposta a crise) |
| `Mensagem-Chave` | Numérico | 0–10 | Grau de presença e clareza da mensagem-chave da marca na cobertura |
| `Fator de Visibilidade` | Numérico | 0–10 | Alcance estimado do veículo/conteúdo (audiência, engajamento, replicação) |
| `Fator de Valoração` | Numérico | 0–10 | Valor comercial equivalente da exposição obtida (proxy de AVE ajustado) |

Todos os inputs são hardcoded (fonte: avaliação qualitativa simulada de clipping) e aparecem em fonte azul na planilha, seguindo a convenção de que azul = input editável e preto = fórmula.

## Aba `Scoring` (cálculo do modelo)

| Coluna | Fórmula | Descrição |
|---|---|---|
| `Score Narrativa` | `=AVERAGE(Destaque:Mensagem-Chave)` | Média simples dos 5 atributos do eixo de Eficiência de Narrativa |
| `Score Atratividade` | `=AVERAGE(Fator de Visibilidade, Fator de Valoração)` | Média simples dos 2 atributos do eixo de Atratividade de Conteúdo |
| `Score Final` | `=AVERAGE(Score Narrativa, Score Atratividade)` | Média dos dois eixos — peso 50/50 entre narrativa e atratividade |
| `Quadrante` | `IF` aninhado com corte em 5.0 nos dois eixos | Classifica a marca em um dos 4 quadrantes (ver abaixo) |
| `Desempate` | `=Score Final + linha × 0,00001` | Coluna auxiliar apenas para garantir ranking sem empates — não tem significado analítico |
| `Rank` | `=RANK(Desempate)` | Posição da marca no ranking geral |

### Premissa assumida (documentar com o cliente em um case real)

O peso 50/50 entre os dois eixos e o corte em 5,0 para definição de quadrante são premissas metodológicas simplificadas para fins de demonstração. Em um projeto real, esses pesos e o ponto de corte devem ser validados com a área de negócio e podem variar por setor.

## Quadrantes

| Quadrante | Condição | Leitura |
|---|---|---|
| Reputação Consolidada | Narrativa ≥ 5 e Atratividade ≥ 5 | Cobertura bem enquadrada e com bom alcance/valor |
| Risco Narrativo | Narrativa < 5 e Atratividade ≥ 5 | Boa exposição, mas mensagem/enquadramento fragilizado |
| Oportunidade Latente | Narrativa ≥ 5 e Atratividade < 5 | Discurso bem construído, mas baixo alcance/valor de mídia |
| Baixa Relevância | Narrativa < 5 e Atratividade < 5 | Cobertura fraca nos dois eixos |

## Aba `Matriz_Quadrantes`

Réplica dos scores de Narrativa (X) e Atratividade (Y) usada apenas como fonte do gráfico de dispersão — sem cálculo adicional.

## Aba `Benchmarking`

Ranking ordenado do maior para o menor `Score Final`, reconstruído via `INDEX`/`MATCH` sobre a coluna `Rank` da aba `Scoring` (o ambiente de cálculo usado não suporta as funções nativas de ordenação `SORT`/`FILTER`).
