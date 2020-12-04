defmodule AdventOfCode2020 do
  @days %{
   1 => AdventOfCode2020.ReportRepair,
  }

  def day(n) do
    Map.get(@days, n)
  end

  def days do
    @days
    |> Map.values
  end
end
