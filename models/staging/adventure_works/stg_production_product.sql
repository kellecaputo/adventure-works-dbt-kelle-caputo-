with source as (

    select * from {{ source('adventure_works', 'production_product') }}

),

renamed as (

    select

        productid as product_id,
        name as product_name,
        productnumber as product_number,
        color as product_color,
        size as product_size,
        productsubcategoryid as product_subcategory_id,
        productmodelid as product_model_id,
        standardcost as standard_cost,
        listprice as list_price,
        makeflag as make_flag,
        finishedgoodsflag as finished_goods_flag,
        cast(sellstartdate as date) as sell_start_date,
        cast(sellenddate as date) as sell_end_date,
        cast(modifieddate as date) as modified_date

    from source

)

select * from renamed