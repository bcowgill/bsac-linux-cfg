defmodule Retry do
  import :timer, only: [ sleep: 1 ]

  # Retry calling a function until return is non-nil
  # fnTry :: (num_try, num_tries) -> nil || any
  def until(fnTry, retry_delay_ms \\ 500, num_tries \\ :infinite) do
    do_until(fnTry, retry_delay_ms, 1, num_tries)
  end

  defp do_until(fnTry, retry_delay_ms, num_try, num_tries) do
    result = fnTry.(num_try, num_tries)
    final_result =
      case result do
        nil ->
          case do_should_retry(retry_delay_ms, num_tries) do
            :stop -> nil
            {^retry_delay_ms, new_num_tries} ->
              sleep(retry_delay_ms)
              do_until(fnTry, retry_delay_ms, num_try + 1, new_num_tries)
          end
        _ -> result
      end
    final_result
  end

  defp do_should_retry(retry_delay_ms, num_tries) do
    cond do
      num_tries <= 1 -> :stop
      num_tries == :infinite -> { retry_delay_ms, :infinite }
      :otherwise -> { retry_delay_ms, num_tries - 1 }
    end
  end

end
