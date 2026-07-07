with localizacao_completa as (

    select * from {{ ref('int_localizacao_completa') }}

),

final as (

    select

        {{ dbt_utils.generate_surrogate_key(['address_id']) }} as localizacao_sk,
        address_id,
        address_line_1 as endereco,
        city as cidade,
        state_province_name as estado,
        country_region_name as pais,
        region_name as regiao

    from localizacao_completa

)

select * from final