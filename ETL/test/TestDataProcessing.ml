open OUnit2
open ETL.DataProcessing

(* Test cases for the Data Processing module *)

let test_parse_order _ =
  let input = ["1"; "100"; "2023-03-10"; "Shipped"; "Online"] in
  let expected = Some { id = 1; client_id = 100; order_date = "2023-03-10"; status = "Shipped"; origin = "Online" } in
  assert_equal expected (parse_order input)

let test_parse_order_item _ =
  let input = ["1"; "5"; "100.0"; "10.0"; "ProductA"] in
  let expected = Some { order_id = 1; product_id = "ProductA"; quantity = 5; price = 100.0; tax = 10.0 } in
  assert_equal expected (parse_order_item input)

let test_get_order_total _ =
  let items = [{ order_id = 1; product_id = "ProductA"; quantity = 2; price = 50.0; tax = 5.0 };
               { order_id = 1; product_id = "ProductB"; quantity = 3; price = 30.0; tax = 3.0 }] in
  let expected = Some { order_id = 1; total_amount = 190.0; total_taxes = 19.0 } in
  assert_equal expected (get_order_total 1 items)

let test_compute_order_totals _ =
  let orders = [{ id = 1; client_id = 100; order_date = "2023-03-10"; status = "Shipped"; origin = "Online" }] in
  let order_items = [{ order_id = 1; product_id = "ProductA"; quantity = 2; price = 50.0; tax = 5.0 };
                     { order_id = 1; product_id = "ProductB"; quantity = 3; price = 30.0; tax = 3.0 }] in
  let expected = [{ order_id = 1; total_amount = 190.0; total_taxes = 19.0 }] in
  assert_equal expected (compute_order_totals orders order_items)

let suite =
  "Order Processing Tests" >::: [
    "test_parse_order" >:: test_parse_order;
    "test_parse_order_item" >:: test_parse_order_item;
    "test_get_order_total" >:: test_get_order_total;
    "test_compute_order_totals" >:: test_compute_order_totals;
  ]

let () = run_test_tt_main suite