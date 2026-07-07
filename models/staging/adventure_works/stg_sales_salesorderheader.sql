with source as (

    select * from {{ source('adventure_works', 'sales_salesorderheader') }}

),

renamed as (

    select

        salesorderid as sales_order_id,
        cast(orderdate as date) as order_date,
        cast(duedate as date) as due_date,
        cast(shipdate as date) as ship_date,
        customerid as customer_id,
        salespersonid as sales_person_id,
        territoryid as territory_id,
        billtoaddressid as bill_to_address_id,
        shiptoaddressid as ship_to_address_id,
        creditcardid as credit_card_id,
        subtotal,
        taxamt as tax_amount,
        freight,
        totaldue as total_due,
        onlineorderflag as online_order_flag,

        case status
            when 1 then 'Em processo'
            when 2 then 'Aprovado'
            when 3 then 'Em espera'
            when 4 then 'Rejeitado'
            when 5 then 'Enviado'
            when 6 then 'Cancelado'
            else 'Desconhecido'
        end as order_status,

        cast(modifieddate as date) as modified_date

    from source

)

select * from renamed