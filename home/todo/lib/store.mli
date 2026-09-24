val path : unit -> string
val load : unit -> Todo.t list
val save : Todo.t list -> unit
val next_id : Todo.t list -> int
