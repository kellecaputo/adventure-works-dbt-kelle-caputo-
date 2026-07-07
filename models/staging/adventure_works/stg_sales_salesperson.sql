with source as (

    select * from {{ source('adventure_works', 'sales_salesperson') }}

),

renamed as (

    select

        businessentityid as business_entity_id,
        territoryid as territory_id,
        commissionpct as commission_pct,
        bonus,
        salesquota as sales_quota,
        salesytd as sales_ytd,
        saleslastyear as sales_last_year,
        cast(modifieddate as date) as modified_date

    from source

)

select * from renamed