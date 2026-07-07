with cartao as (

    select * from {{ ref('stg_sales_creditcard') }}

),

final as (

    select

        {{ dbt_utils.generate_surrogate_key(['credit_card_id']) }} as cartao_sk,
        credit_card_id,
        card_type as tipo_cartao

    from cartao

)

select * from final