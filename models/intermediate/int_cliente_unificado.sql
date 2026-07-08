with cliente as (

    select * from {{ ref('stg_sales_customer') }}

),

pessoa as (

    select * from {{ ref('stg_person_person') }}

),

loja as (

    select * from {{ ref('stg_sales_store') }}

),

joined as (

    select

        cliente.customer_id,

        case
            when cliente.person_id is not null then 'Pessoa Física'
            when cliente.store_id is not null then 'Loja'
            else 'Desconhecido'
        end as customer_type,

        trim(concat(coalesce(pessoa.first_name, ''), ' ', coalesce(pessoa.last_name, ''))) as full_name,
        loja.store_name

    from cliente
    left join pessoa
        on cliente.person_id = pessoa.business_entity_id
    left join loja
        on cliente.store_id = loja.business_entity_id

)

select * from joined