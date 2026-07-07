with detalhe as (

    select * from {{ ref('stg_sales_salesorderdetail') }}

),

pedido as (

    select * from {{ ref('stg_sales_salesorderheader') }}

),

motivo_pedido as (

    select
        sosr.sales_order_id,
        sosr.sales_reason_id,
        sr.sales_reason_name
    from {{ ref('stg_sales_salesorderheadersalesreason') }} sosr
    left join {{ ref('stg_sales_salesreason') }} sr
        on sosr.sales_reason_id = sr.sales_reason_id

),

motivo_principal as (

    select
        sales_order_id,
        coalesce(
            min(case when sales_reason_name = 'On Promotion' then sales_reason_id end),
            min(sales_reason_id)
        ) as sales_reason_id
    from motivo_pedido
    group by sales_order_id

),

final as (

    select

        detalhe.sales_order_id,
        detalhe.sales_order_detail_id,

        {{ dbt_utils.generate_surrogate_key(['pedido.order_date']) }} as data_fk,
        {{ dbt_utils.generate_surrogate_key(['detalhe.product_id']) }} as produto_fk,
        {{ dbt_utils.generate_surrogate_key(['pedido.customer_id']) }} as cliente_fk,
        {{ dbt_utils.generate_surrogate_key(['pedido.bill_to_address_id']) }} as localizacao_fk,
        {{ dbt_utils.generate_surrogate_key(['motivo_principal.sales_reason_id']) }} as motivo_fk,
        {{ dbt_utils.generate_surrogate_key(['pedido.credit_card_id']) }} as cartao_fk,
        {{ dbt_utils.generate_surrogate_key(['pedido.sales_person_id']) }} as vendedor_fk,

        detalhe.order_quantity as quantidade_comprada,
        detalhe.unit_price as preco_unitario,
        detalhe.unit_price_discount as desconto_preco_unitario,
        (detalhe.order_quantity * detalhe.unit_price) as valor_total_negociado,
        (detalhe.order_quantity * detalhe.unit_price * (1 - detalhe.unit_price_discount)) as valor_total_negociado_liquido,
        pedido.order_status as status_pedido

    from detalhe
    left join pedido
        on detalhe.sales_order_id = pedido.sales_order_id
    left join motivo_principal
        on detalhe.sales_order_id = motivo_principal.sales_order_id

)

select * from final