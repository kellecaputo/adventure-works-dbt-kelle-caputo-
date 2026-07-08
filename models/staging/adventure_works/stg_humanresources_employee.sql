with source as (

    select * from {{ source('adventure_works', 'humanresources_employee') }}

),

renamed as (

    select

        businessentityid as business_entity_id,
        jobtitle as job_title,
        cast(birthdate as date) as birth_date,
        cast(hiredate as date) as hire_date,
        gender,
        maritalstatus as marital_status,
        currentflag as current_flag,
        cast(modifieddate as date) as modified_date

    from source

)

select * from renamed