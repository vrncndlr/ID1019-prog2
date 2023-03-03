defmodule Moves do
  @moduledoc """
  move: {:one, n}, {:two, n}
  state: {[main track], [track one], [track two]} > {[:a, :b], [], []}
  """

  @doc """
  binary function single/2 takes a move and an input state
  returns  a new state computed from the state with the move applied
  ex. single({:one, 1}, {[:a, :b], [], []}) >>

  -patter matching
  -is n pos or neg
  -moves with no effect are allowed (n=0)
  -use main/2 when moving from the main track
  n>1 move from main to track x
  n<1 move from track x to main
  """
  def single({_track, 0}, state) do state end

  def single({:one, n}, {main, one, two}) do
    if n>1 do
      {0, rem, move} = Train.main(main, n)
      {rem, Train.append(move, one), two}
    else
      move = Train.take(one, -n)
      {Train.append(main, move), Train.drop(one, -n), two}
    end
  end

  def single({:two, n}, {main, one, two}) do
    if n>1 do
      {0, rem, move} = Train.main(main, n)
      {rem, one, Train.append(move, two)}
    else
      move = Train.take(two, -n)
      {Train.append(main, move), one, Train.drop(two, -n)}
    end
  end

  @doc """
  seq/2 takes a list of moves and a state
  returns a list of states
  """
  def seq([], state) do [state] end
  # def seq([], {main, one, two}) do [state] end
  def seq([move1|rest], state) do
    [state| seq(rest, single(move1, state))]
  end

end

#("moves.ex")
##test1
# Moves.single({:one, 2}, {[:a,:b,:c,:d,:e,:f], [], []})

##test2
# Moves.single({:one, -2}, {[:a,:b,:c,:d], [:e,:f], []})

##test3
# Moves.single({:two, 2}, {[:a,:b,:c,:d,:e,:f], [], []})

##test4
# Moves.single({:two, -2}, {[:a,:b,:c,:d], [], [:e,:f]})

##test5
# moves=[{:one, 1}, {:two, 1}, {:one, -1}, {:two, -1}]
# Moves.seq([{:one, 1}, {:two, 1}, {:one, -1}, {:two, -1}], {[:a,:b], [], []})
# Moves.seq(moves, {[:a,:b], [], []})
