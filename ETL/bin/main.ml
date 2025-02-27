let read_csv filename =
  let csv = Csv.load filename in
  List.iter (fun row ->
    List.iter (fun field ->
      Printf.printf "%s " field
    ) row;
    print_newline ()
  ) csv

let () =
  let filename = "./data/order.csv" in
  read_csv filename
