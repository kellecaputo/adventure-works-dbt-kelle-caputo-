with datas as (

    select order_date as data_completa
    from {{ ref('stg_sales_salesorderheader') }}
    where order_date is not null

    union

    select due_date as data_completa
    from {{ ref('stg_sales_salesorderheader') }}
    where due_date is not null

    union

    select ship_date as data_completa
    from {{ ref('stg_sales_salesorderheader') }}
    where ship_date is not null

),

final as (

    select

        {{ dbt_utils.generate_surrogate_key(['data_completa']) }} as data_sk,
        data_completa,
        day(data_completa) as dia,
        month(data_completa) as mes,
        year(data_completa) as ano,
        quarter(data_completa) as trimestre,
        dayofweek(data_completa) as dia_semana,
        date_format(data_completa, 'MMMM') as nome_mes

    from datas

)

select * from final