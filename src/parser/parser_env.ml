
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

(*
let print_doesnt_work node indent =
  let indentation = String.make indent ' ' in
  let step = 4 in
  match ast with
  | Program.Module node -> 
    begin
      Printf.sprintf 
        "%sModule { \n\
        %sdirective: %s \n\
        %sitems: %s \n\
        %s}"
        indentation
        (indentation ^ indentation)
        (List.fold_left 
          (fun acc directive -> ast_to_string ~indent=(i + step))
          "" node.directives)
        (indentation ^ indentation)
        "[items]"
        indentation
    end
  | Program.Module.Statement statement ->
    begin
      match statement with
      | VariableDeclarationStatement v -> "VariableDeclarationStatement"
      | _ -> "Unimplemented Statement node"
    end
  | _ -> "Unimplemented AST node"
*)

let print_single_ast env =
  Printf.printf "%s\n" (ast_to_string ~indent:2 env.ast)
