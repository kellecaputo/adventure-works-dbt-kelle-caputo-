with vendedor_completo as (

    select * from {{ ref('int_vendedor_completo') }}

),

final as (

    select

        {{ dbt_utils.generate_surrogate_key(['business_entity_id']) }} as vendedor_sk,
        business_entity_id,
        full_name as nome_vendedor,
        commission_pct as comissao,
        bonus

    from vendedor_completo

)

select * from final