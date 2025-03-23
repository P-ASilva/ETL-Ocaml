open DataProcessing
open DataReadWrite

let () =
  Printf.printf "Starting program\n";
  let orders = read_orders "./data/order.csv" in
  let order_items = read_order_items "./data/order_item.csv" in
  let order_totals = compute_order_totals orders order_items in
  write_order_totals_to_csv "./data/order_totals.csv" order_totals;
  Printf.printf "Order totals written to ./data/order_totals.csv\n"