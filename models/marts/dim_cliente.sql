with cliente_unificado as (

    select * from {{ ref('int_cliente_unificado') }}

),

final as (

    select

        {{ dbt_utils.generate_surrogate_key(['customer_id']) }} as cliente_sk,
        customer_id,
        full_name as nome_completo,
        customer_type as tipo_cliente,
        store_name

    from cliente_unificado

)

select * from final