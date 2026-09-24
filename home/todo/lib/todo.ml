type t = {
  id : int;
  text : string;
  done_ : bool;
}

let create ~id ~text = { id; text; done_ = false }

let mark_done t = { t with done_ = true }

let to_line t =
  Printf.sprintf "%d|%d|%s" t.id (if t.done_ then 1 else 0) t.text

let of_line line =
  match String.split_on_char '|' line with
  | [ id_s; done_s; text ] ->
      (try
         Some
           {
             id = int_of_string id_s;
             done_ = done_s = "1";
             text;
           }
       with Failure _ -> None)
  | _ -> None

let pp fmt t =
  let mark = if t.done_ then "[x]" else "[ ]" in
  Format.fprintf fmt "%2d. %s %s" t.id mark t.text
