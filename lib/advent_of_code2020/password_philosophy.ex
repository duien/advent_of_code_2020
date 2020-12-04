defmodule AdventOfCode2020.PasswordPhilosophy do
  @input_file Application.app_dir(:advent_of_code_2020, "priv/day2.txt")

  @part1 "How many passwords are valid according to their policies?"
  @part2 "How many passwords are valid according to the new interpretation of the policies?"
  def part1, do: {@part1, &count_valid_passwords/0}
  def part2, do: {@part2, &recount_valid_passwords/0}

  defmodule PassPolicy do
    defstruct [:char, :min, :max]

    def matches?(policy, password) do
      match_count = ~r/#{policy.char}/
      |> Regex.scan(password)
      |> Enum.count

      match_count >= policy.min && match_count <= policy.max
    end
  end

  defmodule NewPassPolicy do
    defstruct [:char, :p1, :p2]

    def matches?(policy, password) do
      match1 = String.at(password, policy.p1 - 1) == policy.char
      match2 = String.at(password, policy.p2 - 1) == policy.char

      (match1 || match2) && !(match1 && match2)
    end
  end

  @doc """
  Examples:
      iex> AdventOfCode2020.PasswordPhilosophy.count_valid_passwords(\"\"\"
      ...> 1-3 a: abcde
      ...> 1-3 b: cdefg
      ...> 2-9 c: ccccccccc
      ...> \"\"\")
      2
  """
  def count_valid_passwords(input \\ file_input()) do
    input
    |> process_input
    |> Enum.count(fn {password, policy} ->
      PassPolicy.matches?(policy, password)
    end)
  end

    @doc """
  Examples:
      iex> AdventOfCode2020.PasswordPhilosophy.recount_valid_passwords(\"\"\"
      ...> 1-3 a: abcde
      ...> 1-3 b: cdefg
      ...> 2-9 c: ccccccccc
      ...> \"\"\")
      1
  """
  def recount_valid_passwords(input \\ file_input()) do
    input
    |> reprocess_input
    |> Enum.count(fn {password, policy} ->
      NewPassPolicy.matches?(policy, password)
    end)
  end

  defp process_input(text) do
    text
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn line ->
      [policy, password] = String.split(line, ": ")
      
      %{"char" => char, "max" => max, "min" => min} = ~r/^(?<min>\d+)-(?<max>\d+) (?<char>.)$/
      |> Regex.named_captures(policy)

      policy = %PassPolicy{char: char, max: String.to_integer(max), min: String.to_integer(min)}

      {password, policy}
    end)
  end

  defp reprocess_input(text) do
    text
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn line ->
      [policy, password] = String.split(line, ": ")
      
      %{"char" => char, "p1" => max, "p2" => min} = ~r/^(?<p1>\d+)-(?<p2>\d+) (?<char>.)$/
      |> Regex.named_captures(policy)

      policy = %NewPassPolicy{char: char, p1: String.to_integer(max), p2: String.to_integer(min)}

      {password, policy}
    end)
  end

  defp file_input, do: File.read!(@input_file)
end


