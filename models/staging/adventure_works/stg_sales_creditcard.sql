with source as (

    select * from {{ source('adventure_works', 'sales_creditcard') }}

),

renamed as (

    select

        creditcardid as credit_card_id,
        cardtype as card_type,
        cardnumber as card_number,
        expmonth as expiration_month,
        expyear as expiration_year,
        modifieddate as modified_date

    from source

)

select * from renamed