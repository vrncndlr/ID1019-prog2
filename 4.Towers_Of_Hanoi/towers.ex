defmodule Towers do
  #base case
  def hanoi(0, _, _, _) do [] end
  #recursive
  #Three steps:
  #1. moving a smaller tower from from to an auxiliary peg (using the third peg as the auxiliary),
  #2. moving the last disc from from to to
  #3. moving the smaller tower from the auxiliary peg to to (using the from peg as the auxiliary).
  def hanoi(n, from, aux, to) do
      hanoi((n-1), from, to, aux) ++
      [{:move, from, to}] ++
      #hanoi(1, from, aux, to) ++
      hanoi((n-1), aux, from, to)
  end

  def moves(list) do Enum.count(list) end

end

#c("towers.ex")
#list = Towers.hanoi(4, :a,:b,:c)
#Towers.moves(list)
