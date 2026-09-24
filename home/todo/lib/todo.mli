type t = {
  id : int;
  text : string;
  done_ : bool;
}

val create : id:int -> text:string -> t
val mark_done : t -> t
val to_line : t -> string
val of_line : string -> t option
val pp : Format.formatter -> t -> unit
