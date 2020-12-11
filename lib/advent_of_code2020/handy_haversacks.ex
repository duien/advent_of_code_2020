defmodule AdventOfCode2020.HandyHaversacks do
  @input_file Application.app_dir(:advent_of_code_2020, "priv/day7.txt")
  @part1 "How many bag colors can eventually contain at least one shiny gold bag?"
  @part2 "How many individual bags are required inside your single shiny gold bag?"
  def part1, do: { @part1, &count_containing_colors/0 }
  def part2, do: { @part2, &count_inner_containers/0 }


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

    container = rules
    |> could_contain(["shiny gold"])

    old_container = container
    container = rules
    |> could_contain(container)
    |> Enum.concat(old_container)
    |> Enum.uniq

    old_container = container
    container = rules
    |> could_contain(container)
    |> Enum.concat(old_container)
    |> Enum.uniq

    old_container = container
    container = rules
    |> could_contain(container)
    |> Enum.concat(old_container)
    |> Enum.uniq

    old_container = container
    container = rules
    |> could_contain(container)
    |> Enum.concat(old_container)
    |> Enum.uniq

    old_container = container
    container = rules
    |> could_contain(container)
    |> Enum.concat(old_container)
    |> Enum.uniq

    old_container = container
    container = rules
    |> could_contain(container)
    |> Enum.concat(old_container)
    |> Enum.uniq

    old_container = container
    container = rules
    |> could_contain(container)
    |> Enum.concat(old_container)
    |> Enum.uniq

    old_container = container
    rules
    |> could_contain(container)
    |> Enum.concat(old_container)
    |> Enum.uniq
    |> Enum.count
  end

  @doc """
  Examples:
      iex> AdventOfCode2020.HandyHaversacks.count_inner_containers(\"\"\"
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
      32

      iex> AdventOfCode2020.HandyHaversacks.count_inner_containers(\"\"\"
      ...> shiny gold bags contain 2 dark red bags.
      ...> dark red bags contain 2 dark orange bags.
      ...> dark orange bags contain 2 dark yellow bags.
      ...> dark yellow bags contain 2 dark green bags.
      ...> dark green bags contain 2 dark blue bags.
      ...> dark blue bags contain 2 dark violet bags.
      ...> dark violet bags contain no other bags.
      ...> \"\"\")
      126
  """
  def count_inner_containers(input \\ file_input()) do
    input
    |> process_input
    |> Enum.map(&parse_rule/1)
    |> inner_containers("shiny gold")
  end

  def inner_containers(rules, outer_color) do
    relevant_rule = rules
    |> Enum.find(fn {c, _} -> c == outer_color end)
    
    {_, inner} = relevant_rule
    inner
    |> Enum.map(fn {count, color} -> (count * inner_containers(rules, color)) + count end)
    |> Enum.sum
  end

  def could_contain(rules, colors) do
    rules
    |> Enum.filter(fn {_, inner} ->
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
        {String.to_integer(count), color}
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
