defmodule Lume.Components.Icon do
  @moduledoc """
  Renders a [Heroicon](https://heroicons.com).

  Originally from https://github.com/phoenixframework/phoenix

  Heroicons come in three styles – outline, solid, and mini.
  By default, the outline style is used, but solid and mini may
  be applied by using the `-solid` and `-mini` suffix.

  You can customize the size and colors of the icons by setting
  width, height, and background color classes.

  Icons are extracted from the `deps/heroicons` directory and bundled within
  your compiled app.css by the plugin in your `assets/tailwind.config.js`.

  ## Examples

      <.icon name="hero-x-mark-solid" />
      <.icon name="hero-arrow-path" class="ml-1 w-3 h-3 motion-safe:animate-spin" />
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

  # Would like to add support for:
  # - https://boxicons.com/
  # - https://feathericons.com
  # - https://lucide.dev
  # - https://phosphoricons.com
  # - https://www.radix-ui.com/icons
  # - https://tabler.io/icons
end
