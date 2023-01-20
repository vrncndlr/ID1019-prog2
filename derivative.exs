defmodule Derivative do
  # step 1. document the data structures, what inputs should look like and how they're handled
  @type literal() ::{:num, number()}
                    |{:var, atom()}

  @type expr() :: literal()
                |{:add, expr(), expr()}
                |{:sub, expr(), expr()}
                |{:mul, expr(), expr()}
                |{:exp, expr(), literal()}
                |{:div, literal(), literal()}
                |{:ln, literal()}
                |{:sqrt, literal()}
                |{:sin, literal()}
                |{:cos, literal()}

#--------TESTS--------
  def test() do
    #2x
    #e = {:mul, {:num, 2}, {:var, :x} }
    #2x*3x
    e = {:mul, {:mul, {:num, 2}, {:var, :x}}, {:mul, {:num, 3}, {:var, :x}}}
    #2x^2+3x+5
    #e = {:add, {:add, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 2}}}, {:mul, {:num, 3}, {:var, :x}}}, {:num, 5}}
    #e = {:exp, {:var, :x}, {:num, 3}}
    #e = {:div, {:num, 1}, {:var, :x}}
    #e = {:div, {:num, 1}, {:exp, {:var, :x}, {:num, 4}}}
    #e = {:ln, {:var, :x}}
    #e = {:sqrt, {:var, :x}}
    #e = {:sin, {:var, :x}}
    #e = {:cos, {:var, :x}}
    #2x+3x
    #e = {:add, {:mul, {:num, 2}, {:var, :x}}, {:mul, {:num, 3}, {:var, :x}}}
    d = deriv(e, :x)
    IO.write("f = #{simpl(e)}\n")
    IO.write("f' = #{simpl(d)}\n")
    IO.write("   = #{simpl(clean(d))}\n")
  end
#---------------------

@doc """
    Find the derivative of an expression.
    create the function deriv with all rules and conditions
    deriv takes as argument a tuple and the variable of which to derive upon
    """
  # f=1, f'=0
  def deriv({:num, _}, _) do {:num, 0} end #_ represents that it can be whichever number
  # f=x, f'=1
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end
  def deriv({:sub, e1, e2}, v) do
    {:sub, deriv(e1, v), deriv(e2, v)}
  end
  def deriv({:mul, e1, e2}, v) do
    {:add,
      {:mul, e1, deriv(e2, v)},
      {:mul, deriv(e1, v), e2}}
  end
  #more complex expressions
  # x^n
  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul,
        {:exp, e, {:num, n-1}},
        {:num, n}},
      deriv(e, v)}
  end
  # 1/x^n
  def deriv({:div, a, {:exp, x, {:num, n}}}, v) do
    {:mul,
      deriv(x, v),
      {:mul,
        {:num, -n},
        {:div, a, {:exp, x, {:num, n+1}}}}}
  end
  # 1/x
  def deriv({:div, a, b}, v) do
    {:div,
      {:sub,
        {:mul, deriv(a, v), b}, {:mul, a, deriv(b, v)}},
      {:exp, b, {:num, 2}}}
  end
  # ln x
  def deriv({:ln, x}, v) do
    {:mul,
      {:div, {:num, 1}, x},
      deriv(x, v)} end
  # sqrt[x]
  def deriv({:sqrt, x}, v) do
    {:mul,
      {:div,
        {:num, 1},
        {:mul, {:num, 2}, {:sqrt, x}}},
      deriv(x, v)}
  end
  # sin x
  def deriv({:sin, x}, v) do
    {:mul,
      {:cos, x},
      deriv(x, v)}
  end
  def deriv({:cos, x}, v) do
    {:mul,
      {:num, -1},
      {:mul, deriv(x, v), {:sin, x}}}
  end

  #step 3. simplify the output expression
  def simpl({:num, n}) do "#{n}" end
  def simpl({:var, v}) do "#{v}" end
  def simpl({:add, e1, e2}) do "(#{simpl(e1)} + #{simpl(e2)})" end
  def simpl({:sub, e1, e2}) do "(#{simpl(e1)} - #{simpl(e2)})" end
  def simpl({:mul, e1, e2}) do "#{simpl(e1)} * #{simpl(e2)}" end
  def simpl({:exp, e1, e2}) do "#{simpl(e1)}^(#{simpl(e2)})" end
  def simpl({:div, e1, e2}) do "#{simpl(e1)}/(#{simpl(e2)})" end
  def simpl({:ln, e}) do "ln(#{simpl(e)})" end
  def simpl({:sqrt, e}) do "sqrt(#{simpl(e)})" end
  def simpl({:sin, e}) do "sin(#{simpl(e)})" end
  def simpl({:cos, e}) do "cos(#{simpl(e)})" end

  #further clean up the output by removing unnecessary characters like +0, *1 etc
  def clean({:add, e1, e2}) do
    clean_add(clean(e1), clean(e2))
  end
  def clean({:sub, e1, e2}) do
    clean_sub(clean(e1), clean(e2))
  end
  def clean({:mul, e1, e2}) do
    clean_mul(clean(e1), clean(e2))
  end
  def clean({:exp, e1, e2}) do
    clean_exp(clean(e1), clean(e2))
  end
  def clean({:div, e1, e2}) do
    clean_div(clean(e1), clean(e2))
  end
  def clean({:ln, e}) do
    clean_ln(clean(e))
  end
  def clean({:sqrt, e}) do
    clean_sqrt(clean(e))
  end
  def clean({:sin, e}) do
    clean_sin(clean(e))
  end
  def clean({:cos, e}) do
    clean_cos(clean(e))
  end
  def clean(e) do e end

  def clean_add({:num, 0}, e) do e end
  def clean_add(e, {:num, 0} ) do e end
  def clean_add({:num, e1}, {:num, e2}) do {:num, e1+e2} end
  def clean_add(e1, e2) do {:add, e1, e2} end

  def clean_sub({:num, 0}, e) do e end
  def clean_sub(e, {:num, 0} ) do e end
  def clean_sub({:num, e1}, {:num, e2}) do {:num, e1-e2} end
  def clean_sub(e1, e2) do {:sub, e1, e2} end

  def clean_mul({:num, 0}, _) do {:num, 0} end
  def clean_mul(_, {:num, 0} ) do {:num, 0} end
  def clean_mul({:num, 1}, e) do e end
  def clean_mul(e, {:num, 1} ) do e end
  def clean_mul({:num, e}, {:num, e}) do {:num, e*e} end
  def clean_mul({:num, e1}, {:num, e2}) do {:num, e1*e2} end
  def clean_mul(e1, e2) do {:mul, e1, e2} end

  def clean_exp(_, {:num, 0}) do {:num, 1} end
  def clean_exp(e, {:num, 1}) do e end
  def clean_exp({:num, e1}, {:num, e2}) do {:num, :math.pow(e1, e2)} end
  def clean_exp(e1, e2) do {:exp, e1, e2} end

  def clean_div(_, {:num, 0}) do "undefined" end
  def clean_div(e1, e2) do {:div, e1, e2} end

  def clean_ln({:num, n}) do {:num, :math.log(n)} end
  def clean_ln(e) do {:ln, e} end

  def clean_sqrt({:num, n}) do {:num, :math.sqrt(n)} end
  def clean_sqrt(e) do {:sqrt, e} end

  def clean_sin({:num, n}) do {:num, :math.sin(n)} end
  def clean_sin(e) do {:sin, e} end

  def clean_cos({:num, n}) do {:num, :math.cos(n)} end
  def clean_cos(e) do {:cos, e} end

end
