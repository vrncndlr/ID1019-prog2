defmodule Shunt do

  @doc """
  find/2 takes two trains, xs to be tranformed into the formation ys onto the main track
  we require that both trains contain the same wagons, each wagon unique

  1. split xs into wagons hs & ts. hs are wagons before y in xs, ts wagons after y in xs
  2. move y and the following wagons (ts) to track one
  3. move remaining wagons (hs) to track two
  4. move all wagons on one to main including y
  5. move all wagons on track two to main
  6. append ts to hs and recursively call find on the appended train
  """
  def find([], []) do [] end
  def find(xs, [y|s]) do
    {hs, ts} = Train.split(xs, y)
    [{:one, length(ts)+1}, {:two, length(hs)}, {:one, -(length(ts)+1)}, {:two, -(length(hs))} | find(Train.append(hs, ts), s)]
  end

  @doc """
  Similar to find/2 but optimized to find the permutation in fewer moves
  """
  def few([], []) do [] end
  def few([y|tail],[y|rest]) do few(tail,rest) end
  def few(xs, [y|s]) do
    {hs, ts} = Train.split(xs, y)
    [{:one, length(ts)+1}, {:two, length(hs)}, {:one, -(length(ts)+1)}, {:two, -(length(hs))} | few(Train.append(hs, ts), s)]
  end

  @doc """
  Even further optimization
  """
  def compress(ms) do
    ns = rules(ms)
    if ns == ms do
      ms
    else
      compress(ns)
    end
  end

  @doc """
  rules to apply to a list of moves
  """
  def rules([]) do [] end
  def rules([{:one, 0}| tail]) do rules(tail) end
  def rules([{:two, 0}| tail]) do rules(tail) end
  def rules([{:one, n}, {:one, m}|tail]) do rules([{:one, n+m}|tail]) end
  def rules([{:two, n}, {:two, m}|tail]) do rules([{:two, n+m}|tail]) end
  def rules([head|tail]) do [head|rules(tail)] end


end

# c("shunt.ex")
# Shunt.find([:a,:b], [:b,:a])
# Shunt.few([:a,:b], [:b,:a])
