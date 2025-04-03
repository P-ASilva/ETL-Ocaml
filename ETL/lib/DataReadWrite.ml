open DataProcessing

(*Impure Functions for Reading and Writing CSV*)

(**Reads the Orders from file and maps them to a type order list*)
let read_orders (filename: string) : order list =
  match Csv.load filename with
  | [] -> []
  | _ :: rows ->
    List.filter_map parse_order rows

(**Reads the Order Items from file and maps them to a type order_item list*)
let read_order_items (filename: string) : order_item list =
  match Csv.load filename with
  | [] ->
    []
  | _ :: rows ->
    List.filter_map parse_order_item rows

(**Writes the order totals to a CSV file.
  @param filename The name of the CSV file to write to.
  @param order_totals The list of order totals to write.
  @return Unit () *)
let write_order_totals_to_csv (filename: string) (order_totals: order_total list) : unit =
  let csv_data =
    List.map
      (fun { order_id; total_amount; total_taxes } ->
          [ string_of_int order_id;
            string_of_float total_amount;
            string_of_float total_taxes ])
      order_totals
  in
  let header = [ "Order ID"; "Total Amount"; "Total Taxes" ] in
  let all_data = header :: csv_data in
  if Sys.file_exists filename then
    Printf.printf "File %s already exists. Overwriting...\n" filename
  else
    Printf.printf "Creating file %s\n" filename;
  Csv.save filename all_data