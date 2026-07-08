with produto_categorizado as (

    select * from {{ ref('int_produto_categorizado') }}

),

final as (

    select

        {{ dbt_utils.generate_surrogate_key(['product_id']) }} as produto_sk,
        product_id,
        product_name as nome_produto,
        concat(coalesce(product_color, 'N/A'), ' - ', coalesce(product_size, 'N/A')) as cor_tamanho,
        list_price as preco_lista,
        subcategory_name as subcategoria,
        category_name as categoria

    from produto_categorizado

)

select * from final