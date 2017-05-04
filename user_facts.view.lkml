view: user_facts {
  derived_table: {
    sql: select user_id
        ,sum(sale_price) as total_lifetime_sales
        ,count(*) as lifetime_item_count
        ,min(created_at) as first_order_date
        ,max(created_at) as latest_order_date

      from public.order_items
      group by 1
       ;;
      sql_trigger_value: select max(created_at)from public.order_items ;;
      sortkeys: ["user_id"]
      distribution: "user_id"
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: total_lifetime_sales {
    type: number
    sql: ${TABLE}.total_lifetime_sales ;;
  }

  dimension: lifetime_item_count {
    type: number
    sql: ${TABLE}.lifetime_item_count ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

measure:average_lifetime_value {
  type: average
  sql: ${total_lifetime_sales} ;;
}
  set: detail {
    fields: [user_id, total_lifetime_sales, lifetime_item_count, first_order_date_time, latest_order_date_time]
  }
}
