# Adventure Works — Plataforma de Analytics de Vendas

Projeto de Engenharia de Analytics desenvolvido como desafio final da Certificação em Analytics Engineering da Indicium Academy.

## Sobre o projeto

A Adventure Works é uma indústria de bicicletas fictícia, com mais de 500 produtos, 20.000 clientes e 31.000 pedidos. Este projeto constrói um Data Warehouse dimensional a partir dos dados transacionais de vendas da empresa, com o objetivo de responder às principais perguntas de negócio da diretoria e sustentar a construção de dashboards no Power BI.

O trabalho segue um fluxo completo de Analytics Engineering: investigação e mapeamento das fontes de dados, modelagem dimensional em camadas com dbt, testes automatizados de qualidade e controle de versão via Git/GitHub.

## Stack utilizada

| Camada | Tecnologia |
|---|---|
| Dados brutos | Databricks — catalog `fea_academy` (ambiente oficial Indicium) |
| Data Warehouse | Databricks (Unity Catalog) |
| Transformação | dbt Cloud |
| Controle de versão | GitHub |
| Dashboard | Power BI |

## Modelagem dimensional

O modelo segue o padrão estrela (star schema), com uma tabela fato central de vendas conectada a sete dimensões.

### Dimensões

| Dimensão | Tabelas fonte |
|---|---|
| `dim_produto` | `production_product`, `production_productsubcategory`, `production_productcategory` |
| `dim_data` | `sales_salesorderheader` (order_date, due_date, ship_date) |
| `dim_cliente` | `sales_customer`, `person_person`, `sales_store` |
| `dim_localizacao` | `person_address`, `person_stateprovince`, `person_countryregion`, `sales_salesterritory` |
| `dim_motivo_venda` | `sales_salesreason`, `sales_salesorderheadersalesreason` |
| `dim_cartao_credito` | `sales_creditcard` |
| `dim_vendedor` | `sales_salesperson`, `person_person`, `humanresources_employee` |

### Fato

| Fato | Grão | Tabelas fonte |
|---|---|---|
| `fct_vendas` | 1 linha = 1 produto em 1 pedido (`sales_order_id` + `sales_order_detail_id`) | `sales_salesorderdetail`, `sales_salesorderheader` |

### Métricas principais (Implementadas em DAX no Power BI)

| Métrica | Fórmula / Cálculo |
|---|---|
| Faturamento Total | `SUM(fct_vendas[valor_total_negociado])` |
| Quantidade Vendida | `SUM(fct_vendas[quantidade_comprada])` |
| Total Descontos | `SUM(fct_vendas[desconto_preco_unitario])` |
| Total Pedidos | `DISTINCTCOUNT(fct_vendas[sales_order_id])` |
| Ticket Médio | `DIVIDE([Faturamento Total] - [Total Descontos], [Total Pedidos], 0)` |

## Decisões de modelagem

Algumas decisões relevantes tomadas durante o desenvolvimento, documentadas para transparência técnica:

- **Correção de código de país ausente:** o registro da Namíbia apresentava o código de país nulo na origem, pois o código ISO padrão do país (`NA`) é interpretado por diversos sistemas como valor ausente. O valor foi restaurado na camada de staging.
- **Padronização de tipos de data:** todas as colunas de data chegam da origem como texto (`STRING`) e são convertidas para `DATE` já na camada de staging.
- **Tratamento de motivo de venda:** a relação entre pedido e motivo de venda é muitos-para-muitos. Para preservar o grão da tabela fato (evitando duplicidade de linhas e inflação de receita), cada pedido recebe um único motivo principal, priorizando "On Promotion" quando presente entre os motivos, garantindo que análises de vendas por promoção não percam informação.
- **Dimensão de cliente sem e-mail:** o campo não foi incluído por não haver, entre as fontes disponibilizadas para o desafio, uma tabela de e-mail associada às pessoas.
- **Chaves substitutas com tratamento de nulos:** as chaves estrangeiras da fato são geradas via hash (`surrogate key`), preservando o valor nulo quando a informação de origem também é nula (por exemplo, pedidos sem cartão de crédito ou sem vendedor associado), garantindo integridade referencial correta com as dimensões.

## Estrutura do projeto

    models/
    ├── staging/
    │   └── adventure_works/       # 17 modelos stg_* + sources.yml documentado e testado
    ├── intermediate/               # 4 modelos int_* com as principais regras de negócio
    └── marts/                      # 7 dimensões + fct_vendas, com schema.yml documentado
    tests/
    └── teste_ceo_2011.sql          # Teste singular de validação de receita (R$ 12.646.112,16)

    ## Testes implementados

- **Testes de sources:** `unique` e `not_null` aplicados diretamente nas tabelas brutas de origem.
- **Testes de qualidade na staging e intermediate:** validação de chaves e regras de transformação.
- **Testes de chave primária:** `unique` e `not_null` nas surrogate keys de todas as dimensões e da fato, incluindo teste de combinação única de chaves na fato.
- **Testes de integridade referencial:** `relationships` entre todas as chaves estrangeiras da fato e suas respectivas dimensões.
- **Teste de negócio (singular):** valida que a receita bruta de vendas de 2011 é de **R$ 12.646.112,16**, conforme exigido pela diretoria.

Todos os testes passam com sucesso.

## Perguntas de negócio respondidas

O modelo foi construído para suportar, no Power BI, análises como:

- Desempenho de vendas por produto, cliente, região e motivo de venda
- Melhores clientes por valor total negociado
- Cidades e regiões com maior receita gerada
- Evolução de pedidos, quantidade e valor ao longo do tempo
- Produto com maior volume de vendas associado ao motivo "On Promotion"

## Dashboard

O dashboard interativo está disponível em: [Adventure Works — Analytics Dashboard](https://drive.google.com/file/d/1Q5irKbz_QCfgmseKlOjaOC_rkKUNTB0x/view?usp=sharing)

## Diagrama conceitual

O diagrama conceitual do modelo dimensional está disponível na pasta do repositório, representando a tabela fato, as sete dimensões e suas respectivas fontes de origem.

## Autor

Kelle Caputo

