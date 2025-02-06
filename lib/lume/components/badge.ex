defmodule Lume.Components.Badge do
  @moduledoc """
  A simple badge component for status indicators, labels, and counts.

  ## Features
    * Multiple color variants (default, primary, success, warning, error)
    * Three sizes (small, medium, large)
    * Shape options (pill or flat)
    * Optional border styling
    * Optional leading dot indicator
    * Optional icon
    * Dark mode support

  ## Examples

      # Basic badge
      <.badge>Default</.badge>

      # Primary badge with icon
      <.badge variant={:primary} icon="hero-star">
        Featured
      </.badge>

      # Success badge with dot indicator
      <.badge variant={:success} show_dot>
        Online
      </.badge>

      # Warning badge with flat shape and border
      <.badge
        variant={:warning}
        shape={:flat}
        bordered
      >
        Beta
      </.badge>

      # Large error badge with icon
      <.badge
        variant={:error}
        size={:lg}
        icon="hero-exclamation-circle"
      >
        Critical
      </.badge>
  """
  use Phoenix.Component
  import Lume.Components.Icon

  @variants [:default, :primary, :success, :warning, :error]
  @sizes [:sm, :md, :lg]
  @shapes [:pill, :flat]

  @size_classes %{
    sm: "px-2 py-0.5 text-xs",
    md: "px-2.5 py-0.5 text-sm",
    lg: "px-3 py-1 text-base"
  }

  @dot_sizes %{
    sm: "h-1.5 w-1.5",
    md: "h-2 w-2",
    lg: "h-3 w-3"
  }

  @icon_sizes %{
    sm: "h-3 w-3",
    md: "h-4 w-4",
    lg: "h-5 w-5"
  }

  @variant_styles %{
    default: %{
      bg: "bg-gray-100 text-gray-700 dark:bg-zinc-800 dark:text-zinc-300",
      border: "border border-gray-400 dark:border-zinc-400",
      dot: "bg-gray-400 dark:bg-zinc-400",
      icon: "text-gray-400 dark:text-zinc-400"
    },
    primary: %{
      bg: "bg-indigo-100 text-indigo-700 dark:bg-indigo-900/50 dark:text-indigo-400",
      border: "border border-indigo-400 dark:border-indigo-400",
      dot: "bg-indigo-400 dark:bg-indigo-400",
      icon: "text-indigo-400 dark:text-indigo-400"
    },
    success: %{
      bg: "bg-green-100 text-green-700 dark:bg-green-900/50 dark:text-green-400",
      border: "border border-green-400 dark:border-green-400",
      dot: "bg-green-400 dark:bg-green-400",
      icon: "text-green-400 dark:text-green-400"
    },
    warning: %{
      bg: "bg-yellow-100 text-yellow-700 dark:bg-yellow-900/50 dark:text-yellow-400",
      border: "border border-yellow-400 dark:border-yellow-400",
      dot: "bg-yellow-400 dark:bg-yellow-400",
      icon: "text-yellow-400 dark:text-yellow-400"
    },
    error: %{
      bg: "bg-red-100 text-red-700 dark:bg-red-900/50 dark:text-red-400",
      border: "border border-red-400 dark:border-red-400",
      dot: "bg-red-400 dark:bg-red-400",
      icon: "text-red-400 dark:text-red-400"
    }
  }

  @doc """
  Renders a badge component.

  ## Attributes

    * `variant` - Color variant (`:default`, `:primary`, `:success`, `:warning`, `:error`), defaults to `:default`
    * `size` - Size variant (`:sm`, `:md`, `:lg`), defaults to `:md`
    * `shape` - Shape variant (`:pill`, `:flat`), defaults to `:pill`
    * `bordered` - Whether to show a border matching the text color, defaults to `false`
    * `show_dot` - Whether to show a leading dot indicator, defaults to `false`
    * `icon` - Optional icon name (from heroicons)
    * `class` - Additional CSS classes to apply to the badge

  ## Slots

    * `inner_block` - Required. The content to display inside the badge
  """
  attr :variant, :atom, default: :default, values: @variants
  attr :size, :atom, default: :md, values: @sizes
  attr :shape, :atom, default: :pill, values: @shapes
  attr :bordered, :boolean, default: false
  attr :icon, :string, default: nil
  attr :show_dot, :boolean, default: false
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def badge(assigns) do
    ~H"""
    <span class={
      [
        # Base styles
        "inline-flex items-center gap-x-1.5 font-medium",
        # Shape variants
        shape_classes(@shape),
        # Size variants
        size_classes(@size),
        # Color variants with border support
        variant_classes(@variant, @bordered),
        # Custom classes
        @class
      ]
    }>
      <span :if={@show_dot} class={["rounded-full", dot_classes(@size, @variant)]} />
      <.icon :if={@icon} name={@icon} class={icon_classes(@size, @variant)} />
      {render_slot(@inner_block)}
    </span>
    """
  end

  defp shape_classes(:pill), do: "rounded-full"
  defp shape_classes(:flat), do: "rounded-md"

  defp size_classes(size), do: Map.fetch!(@size_classes, size)

  defp variant_classes(variant, bordered) do
    styles = Map.fetch!(@variant_styles, variant)

    [
      if(bordered, do: styles.border, else: ""),
      styles.bg
    ]
  end

  defp dot_classes(size, variant) do
    [
      Map.fetch!(@dot_sizes, size),
      Map.fetch!(@variant_styles, variant).dot
    ]
  end

  defp icon_classes(size, variant) do
    [
      Map.fetch!(@icon_sizes, size),
      Map.fetch!(@variant_styles, variant).icon
    ]
  end
end
