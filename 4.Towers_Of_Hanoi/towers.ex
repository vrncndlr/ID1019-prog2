defmodule Towers do
  #base case
  def hanoi(0, _, _, _) do [] end
  def hanoi(1, :a, _, :c) do [ {:move, :a, :c} ] end
  def hanoi(2, :a, :b, :c) do
    [ {:move, :a, :b}
    {:move, :a, :c},
    {:move, :b, :c} ]
  end
  def hanoi(3, :a, :b, :c) do
    [ {:move, :a, :c},
      {:move, :a, :b},
      {:move, :c, :b},
      {:move, :a, :c},
      {:move, :b, :a},
      {:move, :b, :c},
      {:move, :a, :c} ]
  end
  #recursive
  #Three sequences:
#1. moving a smaller tower from from to an auxiliary peg (using the third peg as the auxiliary),
#2. moving the last disc from from to to
#3. moving the smaller tower from the auxiliary peg to to (using the em from peg as the auxiliary).
  def hanoi(n, from, aux, to) do ... end

end
