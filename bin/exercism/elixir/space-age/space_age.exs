defmodule SpaceAge do
  @moduledoc """
  This module works out your planet age based on how many seconds you've lived.
  """

  @typedoc "The planets in the solar system."
  @type planet :: :mercury | :venus | :earth | :mars | :jupiter
                | :saturn | :uranus | :neptune

  @secs_per_earth_year 31557600
  @days_per_earth_year 365.25
  @years_to_orbit %{
    earth: 1.0,
    mercury: 0.2408467, # Earth years
    venus: 0.61519726,
    mars: 1.8808158,
    jupiter: 11.862615,
    saturn: 29.447498,
    uranus: 84.016846,
    neptune: 164.79132
  }

  @doc """
  Return the number of years a person that has lived for 'seconds' seconds is
  aged on 'planet'.
  """
  @spec age_on(planet, pos_integer) :: float
  def age_on(planet, seconds) do
    years_for_seconds(seconds, planet)
  end

  def years_for_seconds(seconds, planet \\ :earth)
  def years_for_seconds(seconds, :earth) do
    seconds / @secs_per_earth_year
  end

  def years_for_seconds(seconds, planet) do
    years_for_seconds(seconds, :earth) / @years_to_orbit[planet]
  end

  def secs_per_earth_year(), do: @secs_per_earth_year

  def orbital_period_earth_years(planet \\ :earth), do: @years_to_orbit[planet]

  def orbital_period_earth_days(planet \\ :earth) do
    @days_per_earth_year * @years_to_orbit[planet]
  end

end
