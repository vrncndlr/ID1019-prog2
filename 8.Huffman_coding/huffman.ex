defmodule Huffman do
  @moduledoc """
  Huffman coding:
  1. count how many times each character is used and put that in a list in order
  2. take the two least used, those two, together with their frequency (how many times used),
  are the bottom branches on your Huffman tree
  3. connect the two lowest branches one level up with the sum of their frequencies
  4. 0=left, 1=right
  """


  def sample do
      "the quick brown fox jumps over the lazy dog\
      this is a sample text that we will use when we build\
      up a table we will only handle lower case letters and\
      no punctuation symbols the frequency will of course not\
      represent english but it is probably not that far off"
  end

  def text() do
    "this is something we should encode"
  end

  def test do
    sample = sample()
    tree = tree(text())
    encode_table = encode_table(tree)
    decode = decode_table(tree)
    seq = encode(text(), encode_table)
    decode(seq, encode_table)
    |> to_string()
  end

  @doc """
  Create a Huffman tree given a sample text
  frequency ex: 'foo': f/1 o/2
  """
  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  @doc """
  count the individual characters frequencies in the sample text
  return a list of tuples {char, freq}.
  """
  def freq(sample) when is_binary(sample) do
    char_list = String.graphemes(sample)
    frq = Enum.reduce(char_list, %{}, &update_map/2)
    Enum.sort_by(frq, &get_frequency/1)
  end
  #private help functions
  defp update_map(char, val), do: Map.update(val, char, 1, fn n -> n + 1 end)
  defp get_frequency({_, frequency}), do: frequency

  # Build the actual Huffman tree inserting a character at
  # time based on the frequency.
  def huffman([{tree, _}]) do tree end
  def huffman([{k1, v1}, {k2, v2} | rest]) do
    parent = {{k1, k2}, (v1+v2)}
    huffman(insert(parent, rest))
  end

  def insert({k, v}, []), do: [{k, v}]
  def insert({k1, v1}, [{k2, v2} | queue]) do
    if v1 < v2 do
      [{k1, v1}, {k2, v2} | queue]
    else
      [{k2, v2} | insert({k1, v1}, queue)]
    end
  end

  @doc """
  Create a encoding table containing the mapping from characters to codes given a Huffman tree
  """
  def encode_table(tree) do
    Enum.sort(get_code(tree, []), fn({_,x},{_,y}) -> x < y end)
  end
  #get the code for each individual character
  def get_code({l, r}, code) do
    get_code(l, [0 | code]) ++ get_code(r, [1 | code])
    # left ++ right
  end
  def get_code(x, code) do
    [{x, Enum.reverse(code)}]
  end

  @doc """
  Encode the text using the mapping in the table return a sequence of bits
  e.g. "AABCBAD" => 1000101010101011
  """
  def encode([], _table) do [] end
  def encode([char|seq], encode_table) do
    codeRest = encode(seq, encode_table)
    {_, code} = List.keyfind(encode_table, char, 0)
    code ++ codeRest
  end

  @doc """
  Decode the bit sequence using the mapping in the table
  return a text
  """
  def decode_table(tree), do: encode_table(tree)

  def decode([], _table) do [] end
  def decode(encoded_msg, table) do
    {char, rest} = decode_char(encoded_msg, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(encoded_msg, n, table) do
    {code, rest} = Enum.split(encoded_msg, n)
    case List.keyfind(table, code, 1) do
      {_, char, _,} -> {char, rest}
      nil -> decode_char(encoded_msg, n+1, table)
    end
  end

end


# c("huffman.ex")
# txt = "AABCDB"
# tree = Huffman.tree(Huffman.sample())
# encode_table = Huffman.encode_table(tree)
# msg = Huffman.encode(txt, encode_table)
