open ETL.DataProcessing
open ETL.DataReadWrite

(* Main program to read orders, filter them, compute totals, and write to CSV *)

(** This program reads orders from a CSV file, filters them based on command line arguments,
computes the total amount and taxes for each order, and writes the results to a new CSV file. *)
let () =
  Printf.printf "Starting program\n";
  let orders = read_orders "./data/order.csv" in
  let origin = try Sys.argv.(1) with _ -> "" in
  let status = try Sys.argv.(2) with _ -> "" in
  let filtered_orders =
    let filter_orders = 
      match origin, status with
      | "", "" -> (fun _ -> true)
      | "", status -> (fun order -> order.status = status)
      | origin, "" -> (fun order -> order.origin = origin)
      | origin, status -> (fun order -> order.origin = origin && order.status = status)
    in List.filter filter_orders orders in
  let order_items = read_order_items "./data/order_item.csv" in
  let order_totals = compute_order_totals filtered_orders order_items in
  write_order_totals_to_csv "./data/order_totals.csv" order_totals;
  Printf.printf "Order totals written to ./data/order_totals.csv\n"

