defmodule Lume.Components.Separator do
  @moduledoc """
  A simple separator line component.
  """

  use Phoenix.Component

  @doc """
  Renders a separator line.

  ## Attributes

    * `class` - Additional CSS classes to apply to the separator
  """
  attr :class, :string, default: nil

  def separator(assigns) do
    ~H"""
    <hr class={[
      "my-2 bg-gray-200 dark:bg-zinc-700 border-0 h-px",
      @class
    ]} />
    """
  end
end
