defmodule Sync.Sessions.Slug do
  @moduledoc """
  Operations on slugs.
  """

  @alphabet "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
  @alphabet_regex ~r/^([a-zA-Z-_]+)$/

  @doc """
  Generates a slug using the @alphabet module
  attribute.
  """
  def generate do
    @alphabet
    |> String.split("")
    |> Enum.take_random(6)
    |> Enum.join("")
  end

  @doc """
  Ensures that a slug only uses letters in the alphabet.

  Returns the slug on success and nil on failure
  """
  def validate(slug) when is_nil(slug), do: nil
  def validate(slug) do
    if String.match?(slug, @alphabet_regex) do
      slug
    else
      nil
    end
  end
end
