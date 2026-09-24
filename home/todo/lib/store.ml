let path () =
  let home =
    match Sys.getenv_opt "HOME" with
    | Some h -> h
    | None -> failwith "HOME is not set"
  in
  Filename.concat home ".todo-cli"

let ensure_parent file =
  let dir = Filename.dirname file in
  if not (Sys.file_exists dir) then Unix.mkdir dir 0o755

let load () =
  let file = path () in
  if not (Sys.file_exists file) then []
  else
    let ic = open_in file in
    let rec loop acc =
      match input_line ic with
      | line ->
          let acc =
            match Todo.of_line line with
            | Some t -> t :: acc
            | None -> acc
          in
          loop acc
      | exception End_of_file ->
          close_in ic;
          List.rev acc
    in
    loop []

let save items =
  let file = path () in
  ensure_parent file;
  let oc = open_out file in
  List.iter
    (fun t ->
      output_string oc (Todo.to_line t);
      output_char oc '\n')
    items;
  close_out oc

let next_id items =
  List.fold_left (fun acc t -> max acc t.Todo.id) 0 items + 1
