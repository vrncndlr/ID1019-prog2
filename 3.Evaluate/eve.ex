
defmodule Evaluate do
  @type literal() :: {:num, number()}
  | {:var, atom()}
  | {:q, number(), number()}
  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:sub, expr(), expr()}
  | {:div, expr(), expr()}

  def test() do
    # expr = {:add, {:add, {:mul, {:num, 3}, {:var, :x}}, {:div, {:num,7},{:num, 2}}},{:mul, {:div, {:var, :y}, {:num, 3}}, {:num, 5}}}
    # expr = {:add, {:sub, {:mul, {:num, 3}, {:var, :x}}, {:q, 7, 2}}, {:var, :y}}
    # expr =  {:div, {:add, {:num, 10}, {:var, :x}}, {:num, 5}}
    expr = {:div, {:num, 5}, {:var, :y}}
    # expr3 = {:div, {:var, :z}, {:num, 0}}
    # expr5 = {:add, {:div, {:num, 3}, {:num, 4}}, {:div, {:num, 3}, {:num, 4}}}
    env = %{x: 5, y: 15, z: 20}
    eval(expr, env)
  end
  def eval({:q, n1, n2}, _env) do divi({:num, n1},{:num, n2}) end
  def eval({:num, number}, _env) do {:num, number} end
  def eval({:var, v}, env) do {:num, env[v]} end
  def eval({:add, n1, n2}, env) do eval(add(eval(n1, env), eval(n2, env)),env) end
  def eval({:sub, n1, n2}, env) do sub(eval(n1, env), eval(n2,env)) end
  def eval({:mul, n1, n2}, env) do mul(eval(n1, env), eval(n2, env)) end
  def eval({:div, n1, n2}, env) do divi(eval(n1, env), eval(n2,env)) end

  def add({:num, n1}, {:num, n2}) do {:num, (n1 + n2)} end
  def add({:q, q1, q2}, {:num, n}) do divi({:num, (q1+(q2*n))}, {:num, q2}) end
  def add({:num, n}, {:q, q1, q2}) do divi({:num, (q1+(q2*n))},{:num, q2}) end
  def add({:q, q1, q2}, {:q, q3, q4}) do {:q, ((q1*q4)+(q2*q3)),(q2*q4)} end

  def sub({:num, n1},{:num, n2}) do n1 - n2 end
  def sub({:q, q1, q2}, {:num, n}) do divi({:num, q1-(q2*n)},{:num, q2}) end
  def sub({:num, n}, {:q, q1, q2}) do divi({:num, (q2*n)-q1},{:num, q2}) end
  def sub({:q, q1, q2}, {:q, q3, q4}) do {:q, ((q1*q4)-(q2*q3)),(q2*q4)} end

  def divi(_, {:num, 0}) do nil end
  def divi({:num, 0}, _) do {:num, 0} end
  def divi({:num, n1},{:num, n2}) do
    case rem(n1,n2) do
    0 -> {:num, (div(n1,n2))}
    _ -> {:q, (div(n1, Integer.gcd(n1,n2))), (div(n2, Integer.gcd(n1,n2)))}
    end
  end

  def mul({:num, 0}, _) do 0 end
  def mul(_, {:num, 0} ) do 0 end
  def mul({:num, n1},{:num, n2}) do {:num, (n1*n2)} end
  def mul({:q, q1, q2}, {:num, n}) do divi(q1*n, q2) end
  def mul({:num, n},{:q, q1, q2}) do divi(q1*n, q2) end
  def mul({:q, q1, q2},{:q, q3, q4}) do divi(q1*q3, q2*q4) end

end
