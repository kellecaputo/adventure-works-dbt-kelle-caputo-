select
    round(sum(fv.quantidade_comprada * fv.preco_unitario), 2) as valor_calculado,
    12646112.16 as valor_esperado_pelo_ceo

from {{ ref('fct_vendas') }} fv
inner join {{ ref('dim_data') }} dd
    on fv.data_fk = dd.data_sk

where dd.ano = 2011

having round(sum(fv.quantidade_comprada * fv.preco_unitario), 2) <> 12646112.16