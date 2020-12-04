defmodule AdventOfCode2020.ReportRepair do
  @input_file Application.app_dir(:advent_of_code_2020, "priv/day1.txt")

  @part1 "Find the two entries that sum to 2020 and then multiply those two numbers together."
  @part2 "Find three numbers in your expense report that meet the same criteria."
  def part1, do: {@part1, &bad_entries/0}
  def part2, do: {@part2, &more_bad_entries/0}

  @doc """
  Examples:
      iex> AdventOfCode2020.ReportRepair.bad_entries(\"\"\"
      ...> 1721
      ...> 979
      ...> 366
      ...> 299
      ...> 675
      ...> 1456
      ...> \"\"\")
      514579
  """
  def bad_entries(input \\ file_input()) do
    report_amounts = input
    |> process_input

    [a,b] = report_amounts
    |> Enum.filter(fn amount ->
      Enum.member?(report_amounts, 2020-amount)
    end)

    a * b
  end

  @doc """
  Examples:
      iex> AdventOfCode2020.ReportRepair.more_bad_entries(\"\"\"
      ...> 1721
      ...> 979
      ...> 366
      ...> 299
      ...> 675
      ...> 1456
      ...> \"\"\")
      241861950
  """
  def more_bad_entries(input \\ file_input()) do
  end

  defp process_input(text) do
    text
    |> String.trim
    |> String.split("\n")
    |> Enum.map(&String.to_integer(&1))
  end

  defp file_input, do: File.read!(@input_file)
end
