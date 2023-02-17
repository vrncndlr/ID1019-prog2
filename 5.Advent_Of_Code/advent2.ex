##  ROCK PAPER SCISSOR  ##
defmodule RPS do
  # module attributes cannor start with uppercase
  @input "./input.txt"

  @x 1
  @y 2
  @z 3

  @loss 0
  @draw 3
  @win 6

  # task 1
  def score1() do
    @input
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Stream.map(fn
        ["A", "X"] -> @x+@draw
        ["A", "Y"] -> @y+@win
        ["A", "Z"] -> @z+@loss
        ["B", "X"] -> @x+@loss
        ["B", "Y"] -> @y+@draw
        ["B", "Z"] -> @z+@win
        ["C", "X"] -> @x+@win
        ["C", "Y"] -> @y+@loss
        ["C", "Z"] -> @z+@draw
    end )
    |> Enum.sum()
  end

  # task 2
  # x - lose
  # y - draw
  # z - win
  def score2() do
    @input
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Stream.map(fn
        ["A", "X"] -> score1(["A", "Z"])
        ["A", "Y"] -> score1(["A", "X"])
        ["A", "Z"] -> score1(["A", "Y"])
        ["B", "X"] -> score1(["B", "X"])
        ["B", "Y"] -> score1(["B", "Y"])
        ["B", "Z"] -> score1(["B", "Z"])
        ["C", "X"] -> score1(["C", "Y"])
        ["C", "Y"] -> score1(["C", "Z"])
        ["C", "Z"] -> score1(["C", "X"])
    end )
    |> Enum.sum()
  end

end
