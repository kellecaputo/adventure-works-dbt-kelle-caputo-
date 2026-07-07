with source as (

    select * from {{ source('adventure_works', 'person_address') }}

),

renamed as (

    select

        addressid as address_id,
        addressline1 as address_line_1,
        city,
        stateprovinceid as state_province_id,
        postalcode as postal_code,
        cast(modifieddate as date) as modified_date

    from source

)

select * from renamed