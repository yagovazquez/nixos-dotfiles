let usage () =
  prerr_endline
    {|Usage:
  todo add <text>     Add a new todo
  todo list           List all todos
  todo done <id>      Mark a todo as done
  todo rm <id>        Remove a todo
  todo clear          Remove completed todos
  todo help           Show this help|}

let die msg =
  prerr_endline ("Error: " ^ msg);
  usage ();
  exit 1

let require_id = function
  | [] -> die "missing id"
  | id_s :: _ ->
      (try int_of_string id_s with Failure _ -> die ("invalid id: " ^ id_s))

let cmd_add words =
  let text = String.concat " " words |> String.trim in
  if text = "" then die "missing todo text"
  else
    let items = Store.load () in
    let item = Todo.create ~id:(Store.next_id items) ~text in
    Store.save (items @ [ item ]);
    Printf.printf "Added #%d: %s\n" item.id item.text

let cmd_list () =
  match Store.load () with
  | [] -> print_endline "No todos yet. Add one with: todo add <text>"
  | items ->
      List.iter (fun t -> Format.printf "%a@." Todo.pp t) items

let cmd_done id =
  let items = Store.load () in
  let found = ref false in
  let items =
    List.map
      (fun t ->
        if t.Todo.id = id then (
          found := true;
          Todo.mark_done t)
        else t)
      items
  in
  if not !found then die (Printf.sprintf "no todo with id %d" id)
  else (
    Store.save items;
    Printf.printf "Done #%d\n" id)

let cmd_rm id =
  let items = Store.load () in
  let items', removed =
    List.partition (fun t -> t.Todo.id <> id) items
  in
  match removed with
  | [] -> die (Printf.sprintf "no todo with id %d" id)
  | _ ->
      Store.save items';
      Printf.printf "Removed #%d\n" id

let cmd_clear () =
  let items = Store.load () in
  let kept, cleared = List.partition (fun t -> not t.Todo.done_) items in
  Store.save kept;
  Printf.printf "Cleared %d completed todo(s)\n" (List.length cleared)

let () =
  match Array.to_list Sys.argv with
  | _ :: "add" :: rest -> cmd_add rest
  | [ _; "list" ] | [ _ ] -> cmd_list ()
  | _ :: "done" :: rest -> cmd_done (require_id rest)
  | _ :: ("rm" | "remove") :: rest -> cmd_rm (require_id rest)
  | [ _; "clear" ] -> cmd_clear ()
  | [ _; "help" ] | [ _; "-h" ] | [ _; "--help" ] -> usage ()
  | _ :: cmd :: _ -> die ("unknown command: " ^ cmd)
  | [] -> assert false
