open DataProcessing
open DataReadWrite

let origin =
  try Sys.argv.(1) with _ -> ""

let status =
  try Sys.argv.(2) with _ -> ""

let () =
  Printf.printf "Starting program\n";
  let orders = read_orders "./data/order.csv" in
  let origin = origin in
  let status = status in
  let filtered_orders =
    if origin <> "" && status <> "" then
      List.filter (fun order -> order.origin = origin && order.status = status) orders
    else if origin <> "" then
      filter_order_by_origin origin orders
    else if status <> "" then
      filter_order_by_status status orders
    else
      orders 
  in
  let order_items = read_order_items "./data/order_item.csv" in
  let order_totals = compute_order_totals filtered_orders order_items in
  write_order_totals_to_csv "./data/order_totals.csv" order_totals;
  Printf.printf "Order totals written to ./data/order_totals.csv\n"

