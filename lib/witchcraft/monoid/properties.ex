defmodule Witchcraft.Monoid.Properties do
  @moduledoc """
  Check samples to confirm that your data adheres to monoidal properties.
  All members of your datatype should adhere to these rules.
  There are placed here as a quick way to spotcheck some of your values.
  """

  import Witchcraft.Monoid
  import Witchcraft.Monoid.Functions

  @spec spotcheck_identity(any) :: boolean
  def spotcheck_identity(member) do
    (identity(member) <|> member) == member
  end

  @spec spotcheck_associativity(any, any, any) :: boolean
  def spotcheck_associativity(member1, member2, member3) do
    (member1 <|> (member2 <|> member3)) == ((member1 <|> member2) <|> member3)
  end

  @spec spotcheck(any, any, any) :: boolean
  def spotcheck(a, b, c) do
    spotcheck_identity(a) and spotcheck_associativity(a, b, c)
  end
end
