defmodule Eval do

  #representation of exressions
  @type literal() ::{:num, number()}
                  |{:var, atom()}
                  |{:q, number(), number()}

  @type expr() :: literal()
                |{:add, expr(), expr()}
                |{:sub, expr(), expr()}
                |{:mul, expr(), expr()}
                |{:div, expr(), expr()}

  #-------- EVALUATE --------
  # This method takes an expression y and value of x in order to calculate a function f(x)=y
  # env (x) is written as a map e.g. %{x:1, y:2, z:3}

  #a constant evaluates to itself, regardless of environment
  def eval({:num, n}, _env) do {:num, n} end
  # when evaluating a variable, call the Map.get function on the defined environment to get value
  def eval({:var, v}, env) do {:num, env[v]} end #Map.get(env, v) end
  #when rational expression, simplify
  def eval({:q, q1, q2}, _env) do divd({:num, q1}, {:num, q2}) end #{:q, q1, q2} end
  #when expression, call eval recursively until we end up with variable/constant/rational
  def eval({:add, e1, e2}, env) do add(eval(e1, env), eval(e2, env)) end
  def eval({:sub, e1, e2}, env) do sub(eval(e1, env), eval(e2, env)) end
  def eval({:mul, e1, e2}, env) do mul(eval(e1, env), eval(e2, env)) end
  def eval({:div, e1, e2}, env) do divd(eval(e1, env), eval(e2, env)) end

#-------- OPERATIONS ----------
  #defp because environment used only locally (private method)
  #add/2
  defp add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  defp add({:q, q1, q2}, {:num, n1}) do divd({:num, (n1*q2)+q1}, {:num, q2}) end
  defp add({:num, n1}, {:q, q1, q2}) do divd({:num, (n1*q2)+q1}, {:num, q2}) end
  defp add({:q, q1, q2}, {:q, q3, q4}) do divd({:num, (q1*q4)+(q2*q3)}, {:num, (q2*q4)}) end

  #sub/2
  defp sub({:num, n1}, {:num, n2}) do {:num, n1-n2} end
  defp sub({:num, n}, {:q, q1, q2}) do {:q, (n*q2)-q1, q2} end
  defp sub({:q, q1, q2}, {:num, n}) do {:q, q1-(n*q2), q2} end
  defp sub({:q, a, b}, {:q, c, d}) do {:q, ((a*d)-(b*c)), (b*d)} end

  #mul/2
  defp mul({:num, 0}, _) do {:num, 0} end
  defp mul(_, {:num, 0}) do {:num, 0} end
  defp mul({:num, n1}, {:num, n2}) do {:num, (n1*n2)} end
  defp mul({:num, n}, {:q, q1, q2}) do divd(q1*n, q2) end
  defp mul({:q, q1, q2}, {:num, n}) do divd(q1*n, q2) end
  defp mul({:q, q1, q2}, {:q, q3, q4}) do divd(q1*q3, q2*q4) end

  #div/2
  def divd(_, {:num, 0}) do :undefined end
  def divd({:num, 0}, _) do {:num, 0} end
  def divd({:num, n1}, {:num, n2}) do
    if rem(n1, n2)==0 do
      {:num, div(n1, n2)} #build in div/2 functions
    else
      {:q, div(n1, Integer.gcd(n1,n2)), div(n2, Integer.gcd(n1,n2))}
    end
  end
  def divd({:q, q1, q2}, {:q, q3, q4}) do
    if rem(q1, q2)==0 do
      {:num, div(q1, q2)}
    else
      {:q, div(q1 * q4, Integer.gcd(q1*q4, q2*q3)), div(q2 * q3, Integer.gcd(q1*q4, q2*q3))}
    end
  end
  def divd({:num, n}, {:q, q1, q2}) do
    if  rem(q1, q2)==0 do
      div({:num, n}, div(q1, q2))
    else
      {:q, div(n * q2, Integer.gcd(n * q2, q1)), div(q1, Integer.gcd(n * q2, q1))}
    end
  end
  def divd({:q, q1, q2}, {:num, n}) do
    if rem(q1, q2)==0 do
      div(div(q1, q2), {:num, n})
    else
      {:q, div(q1, Integer.gcd(n * q2, q1)), div(n * q2, Integer.gcd(n * q2, q1))}
    end
  end

#-------- PPRINT ----------
def pprint({:num, n}) do "#{n}" end
def pprint({:var, v}) do "#{v}" end
def pprint({:q, q1, q2}) do "(#{q1}/#{q2})" end
def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
def pprint({:sub, e1, e2}) do "(#{pprint(e1)} - #{pprint(e2)})" end
def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
def pprint({:div, e1, e2}) do "#{pprint(e1)}/(#{pprint(e2)})" end


  #-------- TEST  ----------
  def test() do
    env = %{x: 3, y: 4, z: 8}
    # expr = {:add, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 3}}, {:q, 1,2}}
    # expr = {:sub, {:add, {:mul, {:num, 2}, {:var, :x}}, {:mul, {:num, 3}, {:var, :y}}}, {:q, 1,2}}
    # expr = {:div, {:num, 10}, {:var, :x}}
    # expr = {:add, {:num, 2}, {:var, :x}}
    # expr = {:div, {:q, 1,2}, {:q, 3, 8}}
    # expr = {:div, {:q, 3, 5}, {:num, 2}}
    expr = {:div, {:num, 0}, {:num, 2}}
    e = eval(expr, env)
    IO.write("f = #{pprint(expr)}\n")
    IO.write(" = #{pprint(e)}\n")
  end
end
