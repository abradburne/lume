defmodule Lume.Components.Avatar do
  @moduledoc """
  A simple avatar component that displays either an image or fallback initials.

  ## Features
    * Supports image avatars with fallback to initials
    * Multiple sizes (small, medium, large)
    * Shape variants (circle or rounded square)
    * Optional status indicator dot
    * Dark mode support
    * Automatic error handling for failed image loads
    * Customizable fallback colors

  ## Examples

      <.avatar
        alt="John Doe"
        fallback="JD"
        size={:md}
        image_url="path/to/image.jpg"
      />

      # With status indicator
      <.avatar
        alt="Alan B"
        fallback="AB"
        show_dot
        dot_variant={:success}
      />

      # Custom fallback colors
      <.avatar
        alt="User"
        fallback="U"
        fallback_class="bg-indigo-100 text-indigo-600"
      />

      # Square variant with custom size
      <.avatar
        alt="User"
        fallback="U"
        shape={:square}
        class="h-16 w-16"
      />
  """
  use Phoenix.Component

  @sizes [:sm, :md, :lg]
  @shapes [:circle, :square]
  @status_variants [:default, :primary, :success, :warning, :error]

  @default_fallback_class "bg-gray-200 text-gray-900"

  @size_dimensions %{
    sm: "h-8 w-8",
    md: "h-10 w-10",
    lg: "h-12 w-12"
  }

  @size_text %{
    sm: "text-xs",
    md: "text-sm",
    lg: "text-base"
  }

  @dot_sizes %{
    sm: %{size: "h-2 w-2", position: "-top-0.5 -right-0.5"},
    md: %{size: "h-2.5 w-2.5", position: "-top-1 -right-1"},
    lg: %{size: "h-3 w-3", position: "-top-1 -right-1"}
  }

  @doc """
  Renders an avatar component.

  ## Attributes

    * `image_url` - Optional URL to the avatar image
    * `alt` - Required alt text for the avatar
    * `fallback` - Required text to display when image is missing or loading fails
    * `fallback_class` - Custom classes for fallback background and text colors
    * `size` - Size variant (`:sm`, `:md`, `:lg`), defaults to `:md`
    * `shape` - Shape variant (`:circle`, `:square`), defaults to `:circle`
    * `show_dot` - Whether to show a status dot indicator
    * `dot_variant` - Status dot color variant, defaults to `:success`
    * `class` - Additional CSS classes to apply to the avatar
  """
  attr :image_url, :string, default: nil
  attr :alt, :string, required: true
  attr :fallback, :string, required: true
  attr :fallback_class, :string, default: @default_fallback_class
  attr :size, :atom, default: :md, values: @sizes
  attr :shape, :atom, default: :circle, values: @shapes
  attr :show_dot, :boolean, default: false
  attr :dot_variant, :atom, default: :success, values: @status_variants
  attr :class, :string, default: nil

  def avatar(assigns) do
    ~H"""
    <div class="relative inline-flex align-middle">
      <div class={[
        "relative inline-flex items-center justify-center overflow-hidden",
        shape_classes(@shape),
        size_classes(@size),
        @class
      ]}>
        <%= if @image_url do %>
          <img
            src={@image_url}
            alt={@alt}
            class="absolute inset-0 h-full w-full object-cover"
            loading="lazy"
            onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';"
          />
          <span
            class={[
              "absolute inset-0 hidden items-center justify-center font-medium",
              @fallback_class
            ]}
            aria-hidden="true"
          >
            {@fallback}
          </span>
        <% else %>
          <span
            class={["absolute inset-0 flex items-center justify-center font-medium", @fallback_class]}
            aria-hidden="false"
          >
            {@fallback}
          </span>
        <% end %>
      </div>

      <span
        :if={@show_dot}
        class={[
          "absolute block rounded-full ring-2 ring-white dark:ring-zinc-900",
          dot_classes(@size, @dot_variant)
        ]}
      />
    </div>
    """
  end

  defp shape_classes(:circle), do: "rounded-full"
  defp shape_classes(:square), do: "rounded-lg"

  defp size_classes(size) do
    [
      Map.fetch!(@size_dimensions, size),
      Map.fetch!(@size_text, size)
    ]
  end

  defp dot_classes(size, variant) do
    dot_config = Map.fetch!(@dot_sizes, size)

    [
      dot_config.size,
      dot_config.position,
      dot_color_classes(variant)
    ]
  end

  # Status dot colors
  defp dot_color_classes(:default), do: "bg-gray-400 dark:bg-zinc-400"
  defp dot_color_classes(:primary), do: "bg-indigo-400 dark:bg-indigo-400"
  defp dot_color_classes(:success), do: "bg-green-400 dark:bg-green-400"
  defp dot_color_classes(:warning), do: "bg-yellow-400 dark:bg-yellow-400"
  defp dot_color_classes(:error), do: "bg-red-400 dark:bg-red-400"
end
