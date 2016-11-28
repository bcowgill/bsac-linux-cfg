defmodule SpaceAge do
  @type planet :: :mercury | :venus | :earth | :mars | :jupiter
                | :saturn | :uranus | :neptune

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet'.
  """
  @spec age_on(planet, pos_integer) :: float
  def age_on(planet, seconds) do
    years_for_seconds(seconds, planet)
  end

  def years_for_seconds(seconds, :earth) do
    secs_per_earth_year = 31557600
    seconds / secs_per_earth_year
  end

  def years_for_seconds(seconds, planet) do
    years_to_orbit = %{
      earth: 365.25, # Earth days
      mercury: 0.2408467, # Earth years
      venus: 0.61519726,
      mars: 1.8808158,
      jupiter: 11.862615,
      saturn: 29.447498,
      uranus: 84.016846,
      neptune: 164.79132
    }
    years_for_seconds(seconds, :earth) / years_to_orbit[planet]
  end

end
