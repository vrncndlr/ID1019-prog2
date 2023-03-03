defmodule Train do
  @moduledoc """
  Train: [:a, :b]
  Wagon :a, :b...
  Move: {:one, n}, {:two, n}
  """

  @doc """
  take(train, n) returns a train containing the first n wagons of train
  """
  def take(_, 0) do [] end
  def take([first|rest], n) when n>0 do [first|take(rest, n-1)] end
  def take([first|rest], n) when n<0 do [first|take(rest, n+1)] end

  @doc """
  drop(train, n) returns the train without its first n wagons
  """
  def drop([_a|_b]=train, 0) do train end
  # def drop([], 0) do [] end
  def drop([], _n) do [] end
  def drop([_|rest], n) when n>0 do drop(rest, n-1) end
  def drop([_|rest], n) when n<0 do drop(rest, n+1) end

  @doc """
  append(train1, train2) returns a train that is the combination of the two trains
  e.g. append([:a, :b], [:c]) returns [:a, :b, :c]
  """
  def append([], []) do [] end
  def append([], t) do t end
  def append([first|rest], t) do [first| append(rest, t)] end

  @doc """
  member(train, :w) tests if w is a wagon in train
  """
  def member([], _w) do :false end
  def member([w|_], w) do :true end
  def member([_|rest], w) do member(rest, w) end

  @doc """
  position(train, w) returns the position of wagon w in train, assuming it is a member
  1 indexed
  """
  def position([w|_], w) do 1 end
  def position([_|rest], w) do position(rest, w)+1 end

  @doc """
  split(train, w) returns a tuple with two trains, all the wagons before w and all
  wagons after w, with w not part of either trains
  e.g.  split([:a,:b,:c], :a) >> {[], [:b, :c]}
        split([:a,:b,:c], :b) >> {[:a], [:c]}
  """
  def split([w|t], w) do {[], t} end
  def split([first|rest], w) do
    {rest, c} = split(rest, w)
    {[first|rest], c}
  end

  @doc """
  The wagons on the main track are in reversed order i.e the first wagon in the list is on
  the left-most position on the track. When you're asked to move two wagons to another track,
  you should divide the train into two segments: the segment that should remain & the two last
  wagons to the right (the end of the list) that should be moved.

  main(train, n) returns the tuple {k, remain, take}
  INPUT:
  train: the train to divide
  n: n wagons to take
  OUTPUT:
  k: number of wagons remaining after taking n wagons
  remain: wagons of train to remain on the main track
  take: wagons to move

  e.g. main([:a, :b, :c, :d], 3) >> {0, [:a], [:b, :c, .d]}
  """
  #no recursion
  # def main([a|b]=train, n) do
  #   total = Enum.count(train)
  #   k = total - n
  #   {k, take([a|b], k), drop([a|b], k)}
  # end

  #recursion
  def main([], n) do {n, [] , []} end
  def main([first|rest], n) do
    {k, remain, take} = main(rest, n)
    if k==0 do
      {k, [first|remain], take}
    else
      {k-1, remain, [first|take]}
    end
  end

end

# iex c("train.ex")
# t=[:a,:b,:c,:d,:e]
