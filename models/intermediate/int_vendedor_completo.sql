with vendedor as (

    select * from {{ ref('stg_sales_salesperson') }}

),

pessoa as (

    select * from {{ ref('stg_person_person') }}

),

funcionario as (

    select * from {{ ref('stg_humanresources_employee') }}

),

joined as (

    select

        vendedor.business_entity_id,
        trim(concat(coalesce(pessoa.first_name, ''), ' ', coalesce(pessoa.last_name, ''))) as full_name,
        funcionario.job_title,
        vendedor.commission_pct,
        vendedor.bonus

    from vendedor
    left join pessoa
        on vendedor.business_entity_id = pessoa.business_entity_id
    left join funcionario
        on vendedor.business_entity_id = funcionario.business_entity_id

)

select * from joined