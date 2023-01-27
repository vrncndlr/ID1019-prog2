defmodule EnvTree do

  def new() do nil end
  # a node {:node, key, value, left, right}

  # adding a key-value pair to an empty tree
  def add(nil, key, value) do {:node, key, value, nil, nil} end
  # if the key is found we replace it
  def add({:node, key, _value, left, right}, key, value) do {:node, key, value, left, right} end
  # return a tree that looks like the one we have but where the left branch has been updated
  # smaller values to the left, larger to the right
  def add({:node, k, v, left, right}, key, value) when key<k do
    {:node, k, v, add(left, key, value), right}
  end
  def add({:node, k, v, left, right}, key, value) when key>k do
    {:node, k, v, left, add(right, key, value)}
  end

  def lookup(nil, _key) do nil end
  def lookup({:node, key, value, _left, _right}, key) do {key, value} end
  def lookup({:node, k, value, left, right}, key) do
    if key<k do
      lookup(left, key)
    else
      lookup(right, key)
    end
  end

  def delete(nil, _) do nil end
  #deleting a leaf node
  def delete({:node, key, _, nil, nil}, key) do nil end
  #deleting node with one child
  def delete({:node, key, _, nil, right}, key) do right end
  def delete({:node, key, _, left, nil}, key) do left end
  #deleting node with two children
  def delete({:node, key, _, left, right}, key) do
    {key, value, new} = smallest_right(right)
    {:node, key, value, left, new}
  end
  #traversing down the tree if match is not immidiate
  def delete({:node, k, v, left, right}, key) when key<k do {:node, k, v, delete(left, key), right} end
  def delete({:node, k, v, left, right}, key) do {:node, k, v, left, delete(right, key)} end
  #if the right branch doesn't have a left branch
  def smallest_right({:node, key, value, nil, new}) do
    {key, value, new}
  end
  #otherwise recursion until we find the smallest value in the right branch
  def smallest_right({:node, k, v, left, right}) do
    {key, value, new} = smallest_right(left)
    {key, value, {:node, k, v, new, right}}
  end


#t = {:node, 10, :ten,{:node, 3, :three, {:node, 1, :one, nil, nil}, {:node, 4, :four, nil, nil}},{:node, 15, :ft,{:node, 11, :el, nil, nil},{:node, 16, :st, nil, nil}}}

end
