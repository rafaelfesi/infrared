
open Ast
open Token
open Lex_env

type t = {
  source: string;
  tokens: Token.t list;
  ast: Program.t;
}

(* Return the nth token in a list *)
let lookahead ?(n=1) tokens =
  try Some (List.nth tokens (n - 1))
  with _ -> None

(* Return next token in env if one exists and the rest of the tokens
 * without the first *)
let pop tokens = 
  match tokens with
  | t :: toks -> Some (t, toks)
  | _ -> None

(* Destroy n tokens from the front of the list *)
let eat ?(n=1) tokens = 
  let rec inner_eat n tokens = 
    match tokens with
    | _ :: toks when n > 0 -> inner_eat (n - 1) toks
    (* Either n has hit zero or no tokens left to eat *)
    | _ -> tokens
  in inner_eat n tokens

(* 
  Doesn't work due to @@deriving.show exception error with recursive modules
  https://github.com/whitequark/ppx_deriving/issues/142

let rec ast_to_string ?(indent=0) ast =
  Printf.sprintf "%s" (Bytes.to_string (Ast.Program.show ast))
*)

let print_single_ast env =
  (* We will always start at parsing a Ast.Program if we're parsing right *)
  Printf.printf "%s\n" (Ast_printer.pp_program env.ast)