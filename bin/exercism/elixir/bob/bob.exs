defmodule Bob do
  @silence ~r{\A\s*\z}u
  @question ~r{[ \? ¿ ; ՞ ؟ ፧ ᥅   ⁇   ⁈  ⁉ ❓ ❔ ⳺  ⳻  ⸮ ㉄ ꘏  ꛷  ︖ 𑅃    ]\s*$}ux
  @letters ~r[\p{L}]ui

  def hey(input) do
    cond do
        Regex.run(@silence, input) -> "Fine. Be that way!"
        Regex.run(@question, input) -> "Sure."
        Regex.run(@letters, input)
          && input === String.upcase(input) -> "Whoa, chill out!"

        :otherwise -> "Whatever."
    end
  end
end
