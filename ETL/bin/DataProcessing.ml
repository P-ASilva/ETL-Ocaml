type order = {
  id: int;
  client_id: int;
  order_date: string;
  status: string;
  origin: string;
}

type order_item = {
  order_id: int;
  product_id: string;
  quantity: int;
  price: float;
  tax: float;
} [@@warning "-69"]

type order_total = {
  order_id: int;
  total_amount: float;
  total_taxes: float;
}

(* Helper functions para carregar os campos nos Records *)
let parse_order (row: string list) : order option =
  match row with
  | [id; client_id; order_date; status; origin] ->
      (try
         Some {
           id = int_of_string id;
           client_id = int_of_string client_id;
           order_date;
           status;
           origin;
         }
       with Failure _ -> None)
  | _ -> None

let parse_order_item (row: string list) : order_item option =
  match row with
  | [order_id; quantity; price; tax; product_id] ->
      (try
         Some {
           order_id = int_of_string order_id;
           product_id;
           quantity = int_of_string quantity;
           price = float_of_string price;
           tax = float_of_string tax;
         }
       with Failure _ -> None)
  | _ -> None

(* let filter_order_by_status(status: string) (orders: order list) : order list =
  List.filter (fun (order:order) -> order.status = status) orders

let filter_order_by_origin(origin: string) (orders: order list) : order list =
  List.filter (fun (order:order) -> order.origin = origin) orders *)

let get_order_total (order_id: int) (order_items_filtered: order_item list) : order_total option =
  match order_items_filtered with
  | [] -> None
  | _ ->
      let sum, tax = List.fold_left
        (fun (sum, tax) order_item ->
           (sum +. order_item.price *. float_of_int order_item.quantity,
            tax +. order_item.tax *. float_of_int order_item.quantity))
        (0.0, 0.0)
        order_items_filtered
      in
      Some { order_id; total_amount = sum; total_taxes = tax }

let compute_order_totals (orders: order list) (order_items: order_item list) : order_total list =
  List.filter_map (fun order ->
    List.filter (fun (order_item:order_item) -> order_item.order_id = order.id) order_items
    |> get_order_total order.id 
  ) orders
