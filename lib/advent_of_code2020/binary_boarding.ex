defmodule AdventOfCode2020.BinaryBoarding do
  @input_file Application.app_dir(:advent_of_code_2020, "priv/day5.txt")

  @part1 "What is the highest seat ID on a boarding pass?"
  @part2 "What is the ID of your seat?"
  def part1, do: {@part1, &highest_seat_id/0}
  def part2, do: {@part2, &gap_in_seats/0}

  @doc """
  Examples:
      iex> AdventOfCode2020.BinaryBoarding.highest_seat_id(\"\"\"
      ...> FBFBBFFRLR
      ...> BFFFBBFRRR
      ...> FFFBBBFRRR
      ...> BBFFBBFRLL
      ...> \"\"\")
      820
  """
  def highest_seat_id(input \\ file_input()) do
    input
    |> all_seat_ids
    |> Enum.max
  end

  def gap_in_seats(input \\ file_input()) do
    seats_found = input
    |> all_seat_ids

    {min,max} = seats_found
    |> Enum.min_max

    all_seats = Enum.into(min..max, [])
    [mine] = all_seats -- seats_found

    mine
  end

  def all_seat_ids(input \\ file_input()) do
    input
    |> process_input
    |> Enum.map(fn specifier ->
      specifier
      |> decode_seat
      |> seat_id
    end)
  end

  @doc """
  Examples:
      iex> AdventOfCode2020.BinaryBoarding.decode_seat("FBFBBFFRLR")
      {44,5}
      
      iex> AdventOfCode2020.BinaryBoarding.decode_seat("BFFFBBFRRR")
      {70,7}

      iex> AdventOfCode2020.BinaryBoarding.decode_seat("FFFBBBFRRR")
      {14,7}

      iex>  AdventOfCode2020.BinaryBoarding.decode_seat("BBFFBBFRLL")
      {102,4}
  """
  def decode_seat(specifier) do
    with {row_spec, column_spec} = String.split_at(specifier, 7),
      row = String.replace(row_spec, ["F", "B"], fn
        "F" -> "0"
        "B" -> "1"
      end),
      row = String.to_integer(row, 2),
      column = String.replace(column_spec, ["L", "R"], fn
        "L" -> "0"
        "R" -> "1"
      end),
      column = String.to_integer(column, 2)
    do
      {row,column}
    end
    
  end

  @doc """
  Examples:
      iex> AdventOfCode2020.BinaryBoarding.seat_id({44,5})
      357
      
      iex> AdventOfCode2020.BinaryBoarding.seat_id({70,7})
      567

      iex> AdventOfCode2020.BinaryBoarding.seat_id({14,7})
      119

      iex>  AdventOfCode2020.BinaryBoarding.seat_id({102,4})
      820
  """
  def seat_id({row,column}), do: row * 8 + column

  defp process_input(text) do
    text
    |> String.trim
    |> String.split("\n")
  end

  defp file_input, do: File.read!(@input_file)
end
