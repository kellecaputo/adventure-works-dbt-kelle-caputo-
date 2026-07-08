with produto as (

    select * from {{ ref('stg_production_product') }}

),

subcategoria as (

    select * from {{ ref('stg_production_productsubcategory') }}

),

categoria as (

    select * from {{ ref('stg_production_productcategory') }}

),

joined as (

    select

        produto.product_id,
        produto.product_name,
        produto.product_color,
        produto.product_size,
        produto.list_price,
        subcategoria.product_subcategory_name as subcategory_name,
        categoria.product_category_name as category_name

    from produto
    left join subcategoria
        on produto.product_subcategory_id = subcategoria.product_subcategory_id
    left join categoria
        on subcategoria.product_category_id = categoria.product_category_id

)

select * from joined