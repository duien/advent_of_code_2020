defmodule AdventOfCode2020 do
  @days %{
   1 => AdventOfCode2020.ReportRepair,
   2 => AdventOfCode2020.PasswordPhilosophy,
   3 => AdventOfCode2020.TobogganTrajectory,
   4 => AdventOfCode2020.PassportProcessing,
   5 => AdventOfCode2020.BinaryBoarding
  }

  def day(n) do
    Map.get(@days, n)
  end

  def days do
    @days
    |> Map.values
  end
end
