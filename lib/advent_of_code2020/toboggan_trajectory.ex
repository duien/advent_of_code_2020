defmodule AdventOfCode2020.TobogganTrajectory do
  @input_file Application.app_dir(:advent_of_code_2020, "priv/day3.txt")

  @part1 "Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?"
  @part2 "What do you get if you multiply together the number of trees encountered on each of the listed slopes?"
  def part1, do: {@part1, &check_trajectory/0}
  def part2, do: {@part2, &product_of_trajectories/0}

  @doc """
  Examples:
      iex> AdventOfCode2020.TobogganTrajectory.check_trajectory(\"\"\"
      ...> ..##.......
      ...> #...#...#..
      ...> .#....#..#.
      ...> ..#.#...#.#
      ...> .#...##..#.
      ...> ..#.##.....
      ...> .#.#.#....#
      ...> .#........#
      ...> #.##...#...
      ...> #...##....#
      ...> .#..#...#.#
      ...> \"\"\", {3,1})
      7
  """
  def check_trajectory(input \\ file_input(), {right,down} \\ {3,1}) do
    tree_map = input |> process_input
    Stream.iterate({0,0}, fn {x,y} -> {x + right, y + down} end)
    |> Enum.take_while(fn {_x,y} -> y < Enum.count(tree_map) end)
    |> Enum.count(fn pos -> tree?(tree_map, pos) end)
  end

  @doc """
  Examples:
      iex> AdventOfCode2020.TobogganTrajectory.product_of_trajectories(\"\"\"
      ...> ..##.......
      ...> #...#...#..
      ...> .#....#..#.
      ...> ..#.#...#.#
      ...> .#...##..#.
      ...> ..#.##.....
      ...> .#.#.#....#
      ...> .#........#
      ...> #.##...#...
      ...> #...##....#
      ...> .#..#...#.#
      ...> \"\"\")
      336
  """
  def product_of_trajectories(input \\ file_input()) do
    [{1,1}, {3,1}, {5,1}, {7,1}, {1,2}]
    |> Enum.map(fn trajectory -> check_trajectory(input, trajectory) end)
    |> Enum.reduce(&(&1 * &2))
  end

  @doc """
  Examples:
      iex> tree_map = [
      ...> "..##.......",
      ...> "#...#...#..",
      ...> ".#....#..#.",
      ...> "..#.#...#.#",
      ...> ".#...##..#.",
      ...> "..#.##.....",
      ...> ".#.#.#....#",
      ...> ".#........#",
      ...> "#.##...#...",
      ...> "#...##....#",
      ...> ".#..#...#.#"
      ...> ]
      iex> AdventOfCode2020.TobogganTrajectory.tree?(tree_map, {0,0})
      false
      iex> AdventOfCode2020.TobogganTrajectory.tree?(tree_map, {13,5})
      true
  """
  def tree?(map, {x,y}) do
    width = Enum.at(map, 0) |> String.length
    char = map
    |> Enum.at(y)
    |> String.at(Integer.mod(x,width))
    char == "#"
  end

  defp process_input(text) do
    text
    |> String.trim
    |> String.split("\n")
  end

  defp file_input, do: File.read!(@input_file)
end
