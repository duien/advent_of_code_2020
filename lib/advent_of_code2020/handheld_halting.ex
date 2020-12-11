defmodule AdventOfCode2020.HandheldHalting do
  @input_file Application.app_dir(:advent_of_code_2020, "priv/day8.txt")
  @part1 "Immediately before any instruction is executed a second time, what value is in the accumulator?"
  # @part2 "How many individual bags are required inside your single shiny gold bag?"
  def part1, do: { @part1, &last_before_loop/0 }
  # def part2, do: { @part2, &count_inner_containers/0 }

  defmodule Console do
    use Agent

    def start_link do
      Agent.start_link(fn -> %{acc: 0, line: 0} end, name: __MODULE__)
    end

    def line do
      Agent.get(__MODULE__, fn %{line: line} -> line end)
    end

    def accumulator do
      Agent.get(__MODULE__, fn %{acc: acc} -> acc end)
    end

    def execute("acc", arg) do
      Agent.get_and_update(__MODULE__, fn %{acc: acc, line: line} = state ->
        {:ok, %{state | acc: acc + arg, line: line + 1}}
      end)
    end

    def execute("jmp", arg) do
      Agent.get_and_update(__MODULE__, fn %{acc: acc, line: line} = state ->
        {:ok, %{state | line: line + arg}}
      end)
    end
    def execute("nop", _) do
      Agent.get_and_update(__MODULE__, fn %{acc: acc, line: line} = state ->
        {:ok, %{state | line: line + 1}}
      end)
    end
  end

  @doc """
  Examples:
      iex> AdventOfCode2020.HandheldHalting.last_before_loop(\"\"\"
      ...> nop +0
      ...> acc +1
      ...> jmp +4
      ...> acc +3
      ...> jmp -3
      ...> acc -99
      ...> acc +1
      ...> jmp -4
      ...> acc +6
      ...> \"\"\")
      5
  """
  def last_before_loop(input \\ file_input()) do
    program = input
    |> process_input
    |> Enum.map(&parse_instructions(&1))

    Console.start_link
    Stream.unfold(MapSet.new, fn set ->
      line = Console.line
      if MapSet.member?(set, line) do
        nil
      else
        {inst, arg} = Enum.at(program, line)
        Console.execute(inst, arg)
        {Console.accumulator, MapSet.put(set, line)}
      end
    end)
    |> Enum.to_list
    |> List.last
  end

  defp process_input(text) do
    text
    |> String.trim
    |> String.split("\n")
  end

  defp parse_instructions(text) do
    %{"inst" => inst, "value" => value} = ~r/(?<inst>\w{3}) (?<value>[-+]\d+)/
    |> Regex.named_captures(text)

    {inst, String.to_integer(value)}
  end

  defp file_input, do: File.read!(@input_file)
end
