defmodule Lume.Components.Breadcrumbs do
  use Phoenix.Component
  import Lume.Components.Icon

  @doc """
  A breadcrumbs component

  ## Examples

      <.breadcrumbs id="item">
        <:crumb navigate={~p"/"}>
          <.icon name="hero-home-mini" class="w-4 h-4 mr-1" /> Home
        </:crumb>
        <:crumb navigate={~p"/items"}>Items</:crumb>
        <:crumb current={true}>Current Item</:crumb>
      </.breadcrumbs>

      <.breadcrumbs id="custom-separator" separator_icon="hero-chevron-right-mini">
        <:crumb navigate={~p"/"}>Home</:crumb>
        <:crumb navigate={~p"/items"}>Items</:crumb>
        <:crumb>Item</:crumb>
      </.breadcrumbs>
  """
  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :separator_icon, :string, default: "hero-chevron-right-mini"
  attr :size, :string, default: "sm", values: ~w(xs sm md lg)

  slot :crumb, required: true do
    attr :navigate, :string
    attr :current, :boolean
  end

  def breadcrumbs(assigns) do
    ~H"""
    <nav
      id={@id}
      class={[
        "text-gray-500 dark:text-gray-400",
        @class
      ]}
      aria-label="Breadcrumb"
    >
      <ol role="list" class="flex items-center">
        <li :for={{crumb, index} <- Enum.with_index(@crumb)} class="flex items-center">
          <.icon
            :if={index > 0}
            name={@separator_icon}
            class={[
              "flex-shrink-0 mx-2",
              icon_size_class(@size)
            ]}
          />
          <.link
            :if={Map.get(crumb, :navigate) && !Map.get(crumb, :current, false)}
            patch={crumb[:navigate]}
            class={[
              "flex items-center",
              text_size_class(@size),
              "font-medium hover:text-gray-700 dark:hover:text-gray-300"
            ]}
          >
            {render_slot(crumb)}
          </.link>
          <span
            :if={!Map.get(crumb, :navigate) || Map.get(crumb, :current, false)}
            class={[
              "flex items-center",
              text_size_class(@size),
              if(Map.get(crumb, :current, false),
                do: "font-semibold text-gray-900 dark:text-white"
              )
            ]}
            aria-current={if Map.get(crumb, :current, false), do: "page"}
          >
            {render_slot(crumb)}
          </span>
        </li>
      </ol>
    </nav>
    """
  end

  defp icon_size_class(size) do
    case size do
      "xs" -> "h-3 w-3"
      "sm" -> "h-4 w-4"
      "md" -> "h-5 w-5"
      "lg" -> "h-6 w-6"
      _ -> "h-4 w-4"
    end
  end

  defp text_size_class(size) do
    case size do
      "xs" -> "text-xs"
      "sm" -> "text-sm"
      "md" -> "text-base"
      "lg" -> "text-lg"
      _ -> "text-base"
    end
  end
end
