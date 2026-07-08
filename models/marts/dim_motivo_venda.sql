with motivo as (

    select * from {{ ref('stg_sales_salesreason') }}

),

final as (

    select

        {{ dbt_utils.generate_surrogate_key(['sales_reason_id']) }} as motivo_sk,
        sales_reason_id,
        sales_reason_name as nome_motivo,
        reason_type as tipo_motivo

    from motivo

)

select * from final