(** Record representing a row of the "Order" Table. *)
type order = {
  id: int;
  client_id: int;
  order_date: string;
  status: string;
  origin: string;
}

(** Record representing a row of the "Order_item" Table. *)
type order_item = {
  order_id: int;
  product_id: string;
  quantity: int;
  price: float;
  tax: float;
} [@@warning "-69"]

(**Record representing athe total value of an order. *)
type order_total = {
  order_id: int;
  total_amount: float;
  total_taxes: float;
}

(** Maps a list of strings to an [order] record.
  @param row string representing an order row read from a csv source. format : [id; client_id; order_date; status; origin]
  @return The parsed [order] record.
*)
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

(** Maps a lis of strings to an [order_item] record.
  @param row string representing an order_item row read from a csv source. format : [order_id; quantity; price; tax; product_id]
  @return The parsed [order_item] record.
*)
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

(** Calculates the total amount and taxes of an order based on its order items.
  @param order_id The id of the order.
  @param order_items_filtered The list of order items filtered by the order_id.
  @return An [order_total] record containing the total amount and taxes of the order.
*)
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

(** Computes the total amount and taxes for each order based on its order items.
  @param orders The list of orders.
  @param order_items The list of order items.
  @return A list of [order_total] records containing the total amount and taxes for each order.
*)
let compute_order_totals (orders: order list) (order_items: order_item list) : order_total list =
  List.filter_map (fun order ->
    List.filter (fun (order_item:order_item) -> order_item.order_id = order.id) order_items
    |> get_order_total order.id 
  ) orders
