defmodule ElixirMarkov do


  @regex_verses ~r/\d+\.\s+/


  def get_chain(list, order) do
    list
      |> Enum.chunk_every(order + 1, 1)
      |> Enum.reduce(%{}, fn(x, chain) ->
        s = Enum.split(x, order)
        key = s |> elem(0) |> Enum.join(" ")
        follower = elem(s, 1)
        if Map.has_key?(chain, key) do
          Map.merge(chain, %{key => follower}, fn(_k, v1, v2) ->
            v1 ++ v2
          end)
        else
          Map.put(chain, key, follower)
        end
      end)
  end

  def get_random_follower(chain, key) do
    chain
      |> Map.get(key)
      |> Enum.take_random(1)
      |> List.first
  end

  def get_key(list, order) do
    list
      |> Enum.chunk_every(order)
      |> List.first()
      |> Enum.reverse()
      |> Enum.join(" ")
  end

  def get_initial_key(chain) do
    chain
      |> Enum.take_random(1)
      |> hd()
      |> elem(0)
  end

  def get_list_length(list) do
    list 
      |> Enum.join(" ") 
      |> String.length()
  end

  def extend_list(config, max_length, list, key, _) do
    follower = get_random_follower(config.chain, key)
    if follower do
      next_list = [follower | list]
      next_length = get_list_length(next_list)
      next_key = get_key(next_list, config.order)
      extend_list(config, max_length, next_list, next_key, next_length)
    else
      list
    end
  end

  def generate_reverese_text_list(config, max_length, list, key) do
    length = get_list_length(list)
    IO.inspect(length)
    IO.inspect(list)
    extend_list(config, max_length, list, key, length)
  end

  def generate_text(source_text, order \\ 1, max_length \\ 140, focus \\ nil) do
    text_list = String.split(source_text)
    chain = get_chain(text_list, order)
    initial_key = if focus, do: focus, else: get_initial_key(chain)
    initial_list = initial_key |> String.split() |> Enum.reverse
    %{
      chain: chain,
      order: order,
      maxLength: max_length,
    }
    |> IO.inspect(label: "before generate reverse: ")
    |> generate_reverese_text_list(max_length, initial_list, initial_key)
    |> IO.inspect(label: "after generate reverse: ")
    |> Enum.reverse()
    |> Enum.join(" ")
    |> IO.inspect(label: "end of generate text: ")
  end

  def generate_text_with_word(source_text, focus) do
    generate_text(source_text, 1, 140, focus)
  end

  def generate_bible_text() do
    File.read!("tiny_bible")
    |> IO.inspect(label: "file read: ")
    |> generate_text(2, 10)
  end

  def generate_horoscope() do
    File.read!("tiny_horoskop")
    |> IO.inspect(label: "file read: ")
    |> generate_text(2, 10)
  end

end
