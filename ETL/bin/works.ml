type order = { id: int; client_id: int; order_date: string; status: string; origin: string; } [@@warning "-69"]
type order_item = { order_id: int; product_id: string; quantity: int; price: float; tax: float; } [@@warning "-69"]
type order_total = { order_id: int; total_amount: float; total_taxes: float; }

let parse_order (row: string list) : order option =
  match row with
  | [id; client_id; order_date; status; origin] -> (
      try
        Some {
          id = int_of_string id;
          client_id = int_of_string client_id;
          order_date;
          status;
          origin;
        }
      with Failure _ -> None
    )
  | _ -> Printf.printf "Incorrect order row format: %s\n" (String.concat "," row); None

let parse_order_item (row: string list) : order_item option =
  match row with
  | [order_id; quantity; price; tax; product_id] -> (
      try
        Some {
          order_id = int_of_string order_id;
          product_id;
          quantity = int_of_string quantity;
          price = float_of_string price;
          tax = float_of_string tax;
        }
      with Failure _ -> None
    )
  | _ -> Printf.printf "Incorrect order item row format: %s\n" (String.concat "," row); None

let read_orders (filename: string) : order list =
  match Csv.load filename with
  | [] -> Printf.printf "Order file empty\n"; []
  | _ :: rows -> let orders = List.filter_map parse_order rows in
                 Printf.printf "Total orders read: %d\n" (List.length orders); orders

let read_item_list (filename: string) : order_item list =
  match Csv.load filename with
  | [] -> Printf.printf "Order item file empty\n"; []
  | _ :: rows -> let items = List.filter_map parse_order_item rows in
                 Printf.printf "Total order items read: %d\n" (List.length items); items

let filter_order_items (order_id: int) (order_items: order_item list) : order_item list =
  let filtered_items = List.filter (fun (order_item:order_item) -> order_item.order_id = order_id) order_items in
  Printf.printf "Filtered %d items for order ID %d\n" (List.length filtered_items) order_id;
  filtered_items

let get_order_total (order_id: int) (order_items_filtered: order_item list) : order_total option =
  match order_items_filtered with
  | [] -> Printf.printf "No items for Order ID %d\n" order_id; None
  | _ ->
      let sum, tax = List.fold_left
        (fun (sum, tax) order_item ->
          (sum +. order_item.price *. float_of_int order_item.quantity,
           tax +. order_item.tax *. float_of_int order_item.quantity))
        (0.0, 0.0) order_items_filtered
      in
      Printf.printf "Computed total for Order ID %d: Amount %.2f, Taxes %.2f\n" order_id sum tax;
      Some { order_id; total_amount = sum; total_taxes = tax }

let compute_order_totals (orders: order list) (order_items: order_item list) : order_total list =
  List.filter_map (fun order -> get_order_total order.id (filter_order_items order.id order_items)) orders

let write_order_totals_to_csv (filename: string) (order_totals: order_total list) : unit =
  let csv_data = List.map (fun { order_id; total_amount; total_taxes } ->
    [string_of_int order_id; string_of_float total_amount; string_of_float total_taxes]
  ) order_totals in
  let header = ["Order ID"; "Total Amount"; "Total Taxes"] in
  let all_data = header :: csv_data in
  if Sys.file_exists filename then
    Printf.printf "File %s already exists. Overwriting...\n" filename
  else
    Printf.printf "Creating file %s\n" filename;
  Csv.save filename all_data

let () =
  Printf.printf "Starting program\n";
  let orders = read_orders "./data/order.csv" in
  let order_items = read_item_list "./data/order_item.csv" in
  let order_totals = compute_order_totals orders order_items in
  write_order_totals_to_csv "./data/order_totals.csv" order_totals;
  Printf.printf "Order totals written to ./data/order_totals.csv\n"