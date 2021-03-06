import TypeClass

defclass Witchcraft.Apply do
  extend Witchcraft.Functor

  import Witchcraft.Functor

  defmacro __using__(_) do
    quote do
      import Witchcraft.Functor
      import unquote(__MODULE__)
    end
  end

  where do
    def ap(wrapped_funs, wrapped)
  end

  def reverse_ap(wrapped, wrapped_funs), do: ap(wrapped_funs, wrapped)

  defalias wrapped_funs <<~ wrapped, as: :ap
  defalias wrapped ~>> wrapped_funs, as: :reverse_ap

  def lift(a, fun, b), do: fun <~ a <<~ b
  def lift(a, fun, b, c), do: fun <~ a <<~ b <<~ c
  def lift(a, fun, b, c, d), do: fun <~ a <<~ b <<~ c <<~ d
  def lift(a, fun, b, c, d, e), do: fun <~ a <<~ b <<~ c <<~ d <<~ e
  def lift(a, fun, b, c, d, e, f), do: fun <~ a <<~ b <<~ c <<~ d <<~ e <<~ f
  def lift(a, fun, b, c, d, e, f, g), do: fun <~ a <<~ b <<~ c <<~ d <<~ e <<~ f <<~ g
  def lift(a, fun, b, c, d, e, f, g, h), do: fun <~ a <<~ b <<~ c <<~ d <<~ e <<~ f <<~ g <<~ h
  def lift(a, fun, b, c, d, e, f, g, h, i), do: fun <~ a <<~ b <<~ c <<~ d <<~ e <<~ f <<~ g <<~ h <<~ i

  properties do
    def composition(data) do
      alias Witchcraft.Functor
      alias Witchcraft.Apply
      use Quark

      as = data |> generate |> Functor.map(&inspect/1)
      fs = data |> generate |> Functor.replace(fn x -> x <> x end)
      gs = data |> generate |> Functor.replace(fn y -> y <> "foo" end)

      left  = Apply.ap(fs, Apply.ap(gs, as))
      right = fs |> Functor.lift(&compose/2) |> Apply.ap(gs) |> Apply.ap(as)

      equal?(left, right)
    end
  end
end

# definst Witchcraft.Apply, for: Function do
#   use Quark
#   def ap(f, g) when is_function(g), do: fn x -> curry(f).(x).(curry(g).(x)) end
# end

definst Witchcraft.Apply, for: List do
  def ap(fun_list, list) when is_list(list) do
    Witchcraft.Foldable.right_fold(fun_list, [], fn(fun, acc) ->
      acc ++ Witchcraft.Functor.lift(list, fun)
    end)
  end
end

# definst Witchcraft.Apply, for: Tuple do
#   def ap(fun_tuple, arg_tuple) when is_tuple(arg_tuple) do
#     fun_tuple
#     |> Tuple.to_list
#     |> Witchcraft.Apply.ap(Tuple.to_list(arg_tuple))
#     |> List.to_tuple
#   end
# end
