defmodule Lume.Components.UtilComponents do
  @moduledoc """
  Utility components for Lume components. These are used internally by other Lume components.
  Some of these are copied from the default CoreComponents module.
  """
  use Phoenix.Component

  @doc """
  This is copied from the default CoreComponents.icon/1 but enhanced to handle both string and list classes
  """
  attr :name, :string, required: true
  attr :class, :any, default: nil

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={build_class([@name, @class])} />
    """
  end

  # Builds a class string from a list of classes
  defp build_class(list) when is_list(list) do
    list
    |> List.flatten()
    |> Enum.filter(& &1)
    |> Enum.join(" ")
  end

  defp build_class(class), do: class
end
