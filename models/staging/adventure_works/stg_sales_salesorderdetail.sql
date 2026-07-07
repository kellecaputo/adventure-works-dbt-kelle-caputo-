with source as (

    select * from {{ source('adventure_works', 'sales_salesorderdetail') }}

),

renamed as (

    select

        salesorderid as sales_order_id,
        salesorderdetailid as sales_order_detail_id,
        productid as product_id,
        orderqty as order_quantity,
        unitprice as unit_price,
        unitpricediscount as unit_price_discount,
        cast(modifieddate as date) as modified_date

    from source

)

select * from renamed