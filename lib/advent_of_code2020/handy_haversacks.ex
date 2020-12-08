defmodule AdventOfCode2020.HandyHaversacks do
  @input_file Application.app_dir(:advent_of_code_2020, "priv/day7.txt")
  @part1 "How many bag colors can eventually contain at least one shiny gold bag?"
  # @part2 "For each group, count the number of questions to which everyone answered \"yes\". What is the sum of those counts?"
  def part1, do: { @part1, &count_containing_colors/0 }
  # def part2, do: { @part2, &sum_of_counts_all/0 }


  @doc """
  Examples:
      iex> AdventOfCode2020.HandyHaversacks.count_containing_colors(\"\"\"
      ...> light red bags contain 1 bright white bag, 2 muted yellow bags.
      ...> dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      ...> bright white bags contain 1 shiny gold bag.
      ...> muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      ...> shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      ...> dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      ...> vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      ...> faded blue bags contain no other bags.
      ...> dotted black bags contain no other bags.
      ...> \"\"\")
      4
  """
  def count_containing_colors(input \\ file_input()) do
    rules = input
    |> process_input
    |> Enum.map(&parse_rule/1)

    rules
    |> could_contain(["shiny gold"])
  end

  def could_contain(rules, colors) do
    rules
    |> Enum.filter(fn {color, inner} ->
      inner
      |> Enum.any?(fn {_, color} ->
        Enum.member?(colors, color)
      end)
    end)
    |> Enum.map(fn {color, _} -> color end)
  end

  def parse_rule(text) do
    [outer, inner] = text
    |> String.split(" bags contain ")

    inner = inner
    |> String.trim_trailing(".")
    |> String.split(", ")
    |> Enum.map(fn "no other bags" -> nil
      bag ->
        %{"count" => count, "color" => color} = ~r/(?<count>\d+) (?<color>[\w ]+) bags?/
        |> Regex.named_captures(bag)
        {count, color}
    end)
    |> Enum.filter(&(&1))

    {outer, inner}
  end


  defp process_input(text) do
    text
    |> String.trim
    |> String.split("\n")
  end

  defp file_input, do: File.read!(@input_file)
end
