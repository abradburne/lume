defmodule Lume.Components.Button do
  @moduledoc """
  A versatile button component with multiple variants, sizes, and styling options.

  ## Features
    * Multiple variants (primary, secondary, outline, minimal)
    * Various sizes (xs, sm, md, lg, xl)
    * Optional icon support
    * Content justification options
    * Border toggle for outline variant
    * Focus and hover states

  ## Examples

      # Basic button
      <.button>Send!</.button>

      # Button with Phoenix event
      <.button phx-click="go" class="ml-2">Send!</.button>

      # Button with leading icon
      <.button icon="hero-user-group">Teams</.button>

      # Outline button without border
      <.button variant="outline" border={false}>Borderless</.button>

      # Left-aligned full-width button
      <.button justify="start" class="w-full">Left aligned</.button>

      # Large secondary button
      <.button variant="secondary" size="lg">Large Button</.button>
  """
  use Phoenix.Component
  import Lume.Components.Icon

  @variants ~w(primary secondary outline minimal)
  @sizes ~w(xs sm md lg xl)
  @justify_options ~w(start center end)

  @size_classes %{
    "xs" => "text-xs px-2 py-1",
    "sm" => "text-sm px-2.5 py-1.5",
    "md" => "text-base px-3 py-2",
    "lg" => "text-lg px-4 py-2",
    "xl" => "text-xl px-6 py-3"
  }

  @variant_styles %{
    "primary" => "bg-gray-600 text-white hover:bg-gray-700 focus:ring-gray-500",
    "secondary" => "bg-secondary/60 text-white hover:bg-secondary/70 focus:ring-secondary/50",
    "outline" => %{
      with_border: "bg-transparent text-gray-700 hover:bg-gray-50 focus:ring-gray-500 border border-gray-300",
      without_border: "bg-transparent text-gray-700 hover:bg-gray-50 focus:ring-gray-500"
    },
    "minimal" => "bg-transparent text-gray-600 hover:text-gray-900 hover:bg-gray-100 focus:ring-gray-500"
  }

  @justify_classes %{
    "start" => "justify-start",
    "center" => "justify-center",
    "end" => "justify-end"
  }

  @doc """
  Renders a button component.

  ## Attributes

    * `type` - HTML button type attribute, defaults to "button"
    * `class` - Additional CSS classes to apply to the button
    * `variant` - Button style variant ("primary", "secondary", "outline", "minimal"), defaults to "primary"
    * `size` - Size variant ("xs", "sm", "md", "lg", "xl"), defaults to "md"
    * `icon` - Optional icon name (from heroicons)
    * `justify` - Content alignment ("start", "center", "end"), defaults to "center"
    * `border` - Whether to show a border (only applies to outline variant), defaults to true

  ## Slots

    * `inner_block` - Required. The content to display inside the button
  """
  attr :type, :string, default: "button"
  attr :class, :string, default: nil
  attr :variant, :string, default: "primary", values: @variants
  attr :size, :string, default: "md", values: @sizes
  attr :icon, :string, default: nil, doc: "the name of the icon to display"

  attr :justify, :string,
    default: "center",
    values: @justify_options,
    doc: "content alignment (start=left, center, end=right)"

  attr :border, :boolean,
    default: true,
    doc: "whether to show a border (applies to outline variant)"

  attr :rest, :global
  slot :inner_block, required: true

  def button(assigns) do
    ~H"""
    <button type={@type} class={[
      # Base classes
      "phx-submit-loading:opacity-75",
      "rounded-lg font-semibold inline-flex items-center",
      justify_classes(@justify),
      size_classes(@size),
      variant_classes(@variant, @border),
      # Common classes for all variants
      "focus:outline-none focus:ring-2 focus:ring-offset-2 transition-colors",
      # Custom class from assigns
      @class
    ]} {@rest}>
      <.icon :if={@icon} name={@icon} class="mr-2 h-5 w-5" />
      {render_slot(@inner_block)}
    </button>
    """
  end

  defp justify_classes(justify) do
    Map.fetch!(@justify_classes, justify)
  end

  defp size_classes(size) do
    Map.fetch!(@size_classes, size)
  end

  defp variant_classes("outline", border) do
    if border do
      Map.fetch!(@variant_styles["outline"], :with_border)
    else
      Map.fetch!(@variant_styles["outline"], :without_border)
    end
  end

  defp variant_classes(variant, _border) do
    Map.fetch!(@variant_styles, variant)
  end
end


  # @doc """
  # Renders a button.

  # ## Examples

  #     <.button>Send!</.button>
  #     <.button phx-click="go" class="ml-2">Send!</.button>
  # """
  # attr :type, :string, default: nil
  # attr :class, :string, default: nil
  # attr :icon, :string, default: nil
  # attr :rest, :global, include: ~w(disabled form name value)

  # slot :inner_block, required: true

  # def button(assigns) do
  #   ~H"""
  #   <button
  #     type={@type}
  #     class={[
  #       "phx-submit-loading:opacity-75 rounded-lg bg-zinc-900 hover:bg-zinc-700 dark:bg-zinc-800 dark:hover:bg-zinc-600 py-2 px-3",
  #       "text-sm font-semibold leading-6 text-white active:text-white/80",
  #       @class
  #     ]}
  #     {@rest}
  #   >
  #     <.icon name={@icon} :if={@icon} class="h-4 w-4" />
  #     {render_slot(@inner_block)}
  #   </button>
  #   """
  # end
