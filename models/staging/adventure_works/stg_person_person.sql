with source as (

    select * from {{ source('adventure_works', 'person_person') }}

),

renamed as (

    select

        businessentityid as business_entity_id,
        persontype as person_type,
        firstname as first_name,
        middlename as middle_name,
        lastname as last_name,
        cast(modifieddate as date) as modified_date

    from source

)

select * from renamed