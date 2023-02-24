defmodule MC do
  @moduledoc """
  The Monte Carlo method aims to find a good estimation for Pi.
   4 ∗ h/n = Pi
  The challenge is to beat the estimates found by Archimedes, two decimals,
  and Zu Chongzhi, six decimals.
  """

  @doc """
  Generates a random coordinate representing where a dart hits on a square.
  Return true if dart hits inside the inner circle, false if it doesn't
  r=radius f circle
  """
  def dart(r) do
    x = Enum.random(0..r)
    y = Enum.random(0..r)
    # IO.puts(x)
    # IO.puts(y)
    if :math.pow(r,2) > :math.pow(x,2) + :math.pow(y,2) do
      true
    else false
    end
  end

  @doc """
  One singular round of dart throwing.
  Throws k darts on a target square with an inner circle with radius r
  and add the hits to the accumulated value a.
  Continiusly estimates a value for π
  k = darts
  r = radius
  a = nr of hits
  """
  def round(0, _, a) do a end #base case 0 darts?
  def round(k, r, a) do
    if dart(r)==true do
    round(k-1, r, a+1)
    else
    round(k-1, r, a)
    end
  end


  @doc """
  Method for estimating Pi based on total darts and nr of hits
  k: nr of rounds
  j: nr of darts in a round
  t: total dart in every round
  r: radius
  a: nr of hits in the circle
  """
  def rounds(k, j, r) do
    rounds(k, j, 0, r, 0)
  end

  def rounds(0, _, t, _, a) do 4*a/t end # Basecase 0 rounds?
  def rounds(k, j, t, r, a) do
    a = round(j, r, a)
    t = t + j
    j = j*4
    pi = 4*a/t
    :io.format("pi= ~.6f, difference= (~.6f) \n", [pi, (pi - :math.pi())])
    rounds(k-1, j, t, r, a)
  end

  @doc """
  This is the function you call. Send nr of rounds and radius as arguments
  Function calls the accumulation method round/3 which calculated the hits and then
  the estimation method round/5 to calculate Pi
  """
  def run(rounds, darts, radius) do
    a = round(rounds, radius, 0)
    rounds(rounds, darts, darts*rounds, radius, a) #def rounds(k, j, t, r, a)
  end

  @doc """
  The Leibniz formula for Pi
  """
  def leibniz(n) do
    4 * Enum.reduce(0..n, 0, fn(k,a) -> a + 1/(4*k + 1) - 1/(4*k + 3) end)
  end

end

#c("carlo.ex")
