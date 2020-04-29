{{
  config(
    materialized='view'
  )
}}

with orders as (
    select 
        *
    from {{ ref('stg_orders') }}
),
payments as (
    select
        "orderID" as order_id,
        sum(AMOUNT)/100 as amount
    from raw.stripe.payment
    group by 1
),
final as (
    select
        orders.order_id,
        orders.customer_id,
        payments.amount
    from orders
    left join payments using (order_id)
)
select * from final