defmodule EnvList do

  #return a new list
  def new() do [] end

  #add a new association
  def add([], key, value) do [{key, value}] end
  #if the key already exists, replace its value
  def add([{key,_}|map], key, value) do [{key, value}|map] end
  def add([pair|map], key, value) do [pair|add(map, key, value)] end

  #lookup a key value pair
  def lookup([], _key) do nil end
  def lookup([{key,_}=pair], key) do pair end
  def lookup([_|map], key) do lookup(map, key) end

  #remove a pair
  def delete([], _key) do [] end
  def delete([{key,_}|map], key) do map end
  def delete([pair|map], key) do [pair|delete(map, key)] end

end
