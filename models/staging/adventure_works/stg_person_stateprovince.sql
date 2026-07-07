with source as (

    select * from {{ source('adventure_works', 'person_stateprovince') }}

),

renamed as (

    select

        stateprovinceid as state_province_id,
        stateprovincecode as state_province_code,
        countryregioncode as country_region_code,
        name as state_province_name,
        territoryid as territory_id,
        cast(modifieddate as date) as modified_date

    from source

)

select * from renamed