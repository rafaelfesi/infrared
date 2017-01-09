
let extract_files args = 
  []

let parse_single ~file = 
  let ast = Parser.parse file in
  match ast with
  | Ok _ -> ast
  | Error msg -> 
      (ErrorHandling.report ~msg:msg ~level:Level.Med);
      ast
 
let generate_ast_list ~args ~flags =
  let files = extract_files args in
  let rec parse_files files asts =
    match files with
    | [] -> asts
    | file :: tl -> (parse_files tl ([(parse_single file)] @ asts))
  in parse_files files []

let command = {
  Command.
  name = "Parse";
  flags = [];
  exec = generate_ast_list;
}

