defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "HORSE" => "1H1O1R1S1E"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "1H1O1R1S1E" => "HORSE"
  """

  @run_of_same ~r/(.)\1*/
  @num_repeats ~r/(\d+)(.)/

  @spec encode(String.t) :: String.t
  def encode(string) do
    parts = Regex.scan(@run_of_same, string)
    encoded = for [run, letter] <- parts, do: do_encode(String.length(run), letter)
    to_string(encoded)
  end

  defp do_encode(repeats, letter), do: to_string(repeats) <> letter

  @spec decode(String.t) :: String.t
  def decode(string) do
    parts = Regex.scan(@num_repeats, string)
    decoded = for [_, repeats, letter] <- parts, do: do_decode(String.to_integer(repeats), letter)
    to_string(decoded)
  end

  defp do_decode(repeats, letter), do: String.duplicate(letter, repeats)
end
