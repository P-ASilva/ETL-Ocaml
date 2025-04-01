open DataProcessing

(* Pure *)

let read_orders (filename: string) : order list =
  match Csv.load filename with
  | [] -> []
  | _ :: rows -> (*<elem1> :: <Some List> / header :: tail *)
    List.filter_map parse_order rows

let read_order_items (filename: string) : order_item list =
  match Csv.load filename with
  | [] ->
    (* Printf.printf "Order item file empty\n"; *)
    []
  | _ :: rows ->
    List.filter_map parse_order_item rows

(* Not Pure *)

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