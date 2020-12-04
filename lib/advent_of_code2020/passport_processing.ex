defmodule AdventOfCode2020.PassportProcessing do
  @input_file Application.app_dir(:advent_of_code_2020, "priv/day4.txt")

  @part1 "In your batch file, how many passports are valid?"
  @part2 "In your batch file, how many passports are valid?"
  def part1, do: {@part1, &count_valid/0}
  def part2, do: {@part2, &count_valid_values/0}

  @fields ~w"byr iyr eyr hgt hcl ecl pid"

  @doc """
  Examples:
      iex> AdventOfCode2020.PassportProcessing.count_valid(\"\"\"
      ...> ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
      ...> byr:1937 iyr:2017 cid:147 hgt:183cm
      ...>
      ...> iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
      ...> hcl:#cfa07d byr:1929
      ...> 
      ...> hcl:#ae17e1 iyr:2013
      ...> eyr:2024
      ...> ecl:brn pid:760753108 byr:1931
      ...> hgt:179cm
      ...>
      ...> hcl:#cfa07d eyr:2025 pid:166559648
      ...> iyr:2011 ecl:brn hgt:59in
      ...> \"\"\")
      2
  """
  def count_valid(input \\ file_input()) do
    input
    |> process_input
    |> with_required_fields
    |> Enum.count
  end

  def with_required_fields(passports) do
    passports
    |> Enum.filter(fn passport ->
      fields = Enum.map(passport, fn {f,_v} -> f end)
      Enum.empty?(@fields -- fields)
    end)
  end

  @doc """
  Examples:
      iex> AdventOfCode2020.PassportProcessing.count_valid_values(\"\"\"
      ...> eyr:1972 cid:100
      ...> hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926
      ...> 
      ...> iyr:2019
      ...> hcl:#602927 eyr:1967 hgt:170cm
      ...> ecl:grn pid:012533040 byr:1946
      ...> 
      ...> hcl:dab227 iyr:2012
      ...> ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277
      ...> 
      ...> hgt:59cm ecl:zzz
      ...> eyr:2038 hcl:74454a iyr:2023
      ...> pid:3556412378 byr:2007
      ...> 
      ...> pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
      ...> hcl:#623a2f
      ...> 
      ...> eyr:2029 ecl:blu cid:129 byr:1989
      ...> iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm
      ...> 
      ...> hcl:#888785
      ...> hgt:164cm byr:2001 iyr:2015 cid:88
      ...> pid:545766238 ecl:hzl
      ...> eyr:2022
      ...> 
      ...> iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
      ...> \"\"\")
      4
  """
  def count_valid_values(input \\ file_input()) do
    input
    |> process_input
    |> with_required_fields
    |> Enum.filter(fn passport ->
      Enum.all?(passport, fn {f,v} -> valid_field?(f,v) end)
    end)
    |> Enum.count
  end

  # byr (Birth Year) - four digits; at least 1920 and at most 2002.
  # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  # hgt (Height) - a number followed by either cm or in:
  # If cm, the number must be at least 150 and at most 193.
  # If in, the number must be at least 59 and at most 76.
  # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  # pid (Passport ID) - a nine-digit number, including leading zeroes.
  # cid (Country ID) - ignored, missing or not.
  

  def valid_field?("byr", value) do
    value = String.to_integer(value)
    value >= 1920 && value <= 2002
  end

  def valid_field?("iyr", value) do
    value = String.to_integer(value)
    value >= 2010 && value <= 2020
  end

  def valid_field?("eyr", value) do
    value = String.to_integer(value)
    value >= 2020 && value <= 2030
  end

  def valid_field?("hgt", value) do
    case Regex.named_captures(~r/(?<value>\d+)(?<unit>cm|in)/, value) do
      %{"value" => value, "unit" => unit} ->
        value = String.to_integer(value)
        case unit do
          "in" ->
            value >= 59 && value <= 76
          "cm" ->
            value >= 150 && value <= 193
          _ ->
            false
        end
      _ -> false
    end
  end

  def valid_field?("hcl", value) do
    Regex.match?(~r/^#[0-9a-f]{6}$/, value)
  end

  def valid_field?("ecl", value) do
    ~w(amb blu brn gry grn hzl oth)
    |> Enum.member?(value)
  end

  def valid_field?("pid", value) do
    Regex.match?(~r/^\d{9}$/, value)
  end

  def valid_field?(_, _), do: true

  defp process_input(text) do
    text
    |> String.trim
    |> String.split("\n\n")
    |> Enum.map(fn passport ->
      ~r/(?<field>[a-z]{3}):(?<value>\S+)/
      |> Regex.scan(passport, capture: :all_names)
      |> Enum.map(fn [f,v] -> {f,v} end)
    end)
  end

  defp file_input, do: File.read!(@input_file)
end
