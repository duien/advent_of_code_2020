defmodule AdventOfCode2020.CustomCustoms do
  @input_file Application.app_dir(:advent_of_code_2020, "priv/day6.txt")
  @part1 "For each group, count the number of questions to which anyone answered \"yes\". What is the sum of those counts?"
  @part2 "For each group, count the number of questions to which everyone answered \"yes\". What is the sum of those counts?"
  def part1, do: { @part1, &sum_of_counts_any/0 }
  def part2, do: { @part2, &sum_of_counts_all/0 }


  @doc """
  Examples:
      iex> AdventOfCode2020.CustomCustoms.sum_of_counts_any(\"\"\"
      ...> abc
      ...> 
      ...> a
      ...> b
      ...> c
      ...> 
      ...> ab
      ...> ac
      ...> 
      ...> a
      ...> a
      ...> a
      ...> a
      ...> 
      ...> b
      ...> \"\"\")
      11
  """
  def sum_of_counts_any(input \\ file_input()) do
    input
    |> process_input
    |> Enum.map(&count_group_answers(&1))
    |> Enum.sum
  end

  @doc """
  Examples:
      iex> AdventOfCode2020.CustomCustoms.sum_of_counts_all(\"\"\"
      ...> abc
      ...> 
      ...> a
      ...> b
      ...> c
      ...> 
      ...> ab
      ...> ac
      ...> 
      ...> a
      ...> a
      ...> a
      ...> a
      ...> 
      ...> b
      ...> \"\"\")
      6
  """
  def sum_of_counts_all(input \\ file_input()) do
    input
    |> process_input
    # |> Enum.take(20)
    |> Enum.map(&repeated_group_answers(&1))
    |> Enum.sum
  end

  def repeated_group_answers(group_text) do
    group_text
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&MapSet.new/1)
    # |> IO.inspect
    |> Enum.reduce(&MapSet.intersection(&1, &2))
    # |> IO.inspect
    |> Enum.count
  end

  def count_group_answers(group_text) do
    group_text
    |> String.replace([" ", "\n"], "")
    |> String.codepoints
    |> Enum.uniq
    |> Enum.count
  end

  defp process_input(text) do
    text
    |> String.trim
    |> String.split("\n\n")
  end

  defp file_input, do: File.read!(@input_file)
end
