with endereco as (

    select * from {{ ref('stg_person_address') }}

),

estado as (

    select * from {{ ref('stg_person_stateprovince') }}

),

pais as (

    select * from {{ ref('stg_person_countryregion') }}

),

territorio as (

    select * from {{ ref('stg_sales_salesterritory') }}

),

joined as (

    select

        endereco.address_id,
        endereco.address_line_1,
        endereco.city,
        estado.state_province_name,
        pais.country_region_name,
        territorio.territory_name as region_name

    from endereco
    left join estado
        on endereco.state_province_id = estado.state_province_id
    left join pais
        on estado.country_region_code = pais.country_region_code
    left join territorio
        on estado.territory_id = territorio.territory_id

)

select * from joined