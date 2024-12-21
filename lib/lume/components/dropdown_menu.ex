defmodule Lume.Components.DropdownMenu do
  @moduledoc """
  A flexible dropdown menu component with smooth transitions.

  ## Features
    * Flexible trigger content through slots (button, text, avatar, etc.)
    * Menu items with optional icons and variants
    * Smooth transitions using Phoenix.LiveView.JS
    * Dark mode support
    * Configurable alignment (left, right)
    * Multiple size variants
    * Click outside to close

  ## Examples

      # Basic dropdown with regular navigation
      <.dropdown_menu id="user-menu">
        <:trigger>
          <button type="button" class="text-sm">Options</button>
        </:trigger>
        <:item>
          <.link navigate={~p"/profile"} class="w-full">
            <.icon name="hero-user" />
            Profile
          </.link>
        </:item>
        <:item>
          <.link patch={~p"/settings"} class="w-full">
            <.icon name="hero-cog-6-tooth" />
            Settings
          </.link>
        </:item>
        <:item variant={:error}>
          <button type="button" class="w-full" phx-click="logout">
            <.icon name="hero-arrow-right-on-rectangle" />
            Sign out
          </button>
        </:item>
      </.dropdown_menu>

      # With avatar trigger and right alignment
      <.dropdown_menu id="profile-menu" align={:right} size={:sm}>
        <:trigger>
          <.avatar
            alt="John Doe"
            fallback="JD"
            image_url="/images/avatar.jpg"
          />
        </:trigger>
        <:item>
          <.link navigate={~p"/profile"} class="w-full">Your Profile</.link>
        </:item>
        <:item>
          <button type="button" class="w-full" phx-click="show_settings">Settings</button>
        </:item>
        <:item variant={:error}>
          <button type="button" class="w-full" phx-click="logout">Sign out</button>
        </:item>
      </.dropdown_menu>
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  @alignments [:left, :right]
  @variants [:default, :error]
  @sizes [:sm, :md, :lg]

  @menu_sizes %{
    sm: "w-48",
    md: "w-56",
    lg: "w-64"
  }

  @item_sizes %{
    sm: "px-3 py-1 text-sm gap-x-1.5",
    md: "px-4 py-1.5 text-base gap-x-2",
    lg: "px-4 py-2.5 text-lg gap-x-3"
  }

  @doc """
  Renders a dropdown menu component.

  ## Attributes

    * `id` - Required unique identifier for the dropdown
    * `align` - Alignment of the menu (`:left` or `:right`), defaults to `:left`
    * `size` - Size variant (`:sm`, `:md`, `:lg`), defaults to `:md`
    * `class` - Additional CSS classes to apply to the menu container

  ## Slots

    * `trigger` - Required. The content that triggers the dropdown
    * `item` - Required. One or more menu items to display
      * `variant` - Optional color variant (`:default` or `:error`)
      * `disabled` - Optional boolean to disable the item

  """
  attr :id, :string, required: true
  attr :align, :atom, default: :left, values: @alignments
  attr :size, :atom, default: :md, values: @sizes
  attr :class, :string, default: nil

  slot :trigger, required: true

  slot :item, required: true do
    attr :variant, :atom, values: @variants
    attr :disabled, :boolean
  end

  def dropdown_menu(assigns) do
    ~H"""
    <div class={["relative inline-block text-left", @class]}>
      <div id={"#{@id}-trigger"} phx-click={toggle_menu(@id)} class="cursor-pointer">
        {render_slot(@trigger)}
      </div>

      <div
        id={"#{@id}-content"}
        class="hidden"
        phx-click-away={hide_menu(@id)}
        phx-key="escape"
        phx-window-keydown={hide_menu(@id)}
      >
        <div
          class={[
            "absolute z-50 mt-2 rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none dark:bg-zinc-800 dark:ring-white/10",
            menu_alignment_classes(@align),
            menu_size_classes(@size)
          ]}
          role="menu"
          aria-orientation="vertical"
          aria-labelledby={"#{@id}-trigger"}
          tabindex="-1"
        >
          <%= for {item, index} <- Enum.with_index(@item) do %>
            <div
              id={"#{@id}-item-#{index}"}
              class={menu_item_classes(item, @size)}
              role="menuitem"
              tabindex={if index == 0, do: "0", else: "-1"}
            >
              {render_slot(item)}
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  defp menu_alignment_classes(:left), do: "left-0 origin-top-left"
  defp menu_alignment_classes(:right), do: "right-0 origin-top-right"

  defp menu_size_classes(size), do: Map.fetch!(@menu_sizes, size)

  defp menu_item_classes(item, size) do
    base_classes = [
      "group flex w-full items-center outline-none",
      Map.fetch!(@item_sizes, size)
    ]

    variant = Map.get(item, :variant, :default)
    disabled = Map.get(item, :disabled, false)

    variant_classes =
      case variant do
        :default ->
          "text-gray-700 hover:bg-gray-100 hover:text-gray-900 focus:bg-gray-100 focus:text-gray-900 dark:text-gray-300 dark:hover:bg-zinc-700/50 dark:hover:text-white dark:focus:bg-zinc-700/50 dark:focus:text-white"

        :error ->
          "text-red-700 hover:bg-red-50 focus:bg-red-50 dark:text-red-400 dark:hover:bg-red-900/50 dark:focus:bg-red-900/50"
      end

    disabled_classes =
      if disabled do
        "cursor-not-allowed opacity-50"
      else
        "cursor-pointer"
      end

    [base_classes, variant_classes, disabled_classes]
  end

  @doc """
  Toggles the visibility of the dropdown menu.
  """
  def toggle_menu(id) do
    JS.toggle(
      to: "##{id}-content",
      display: "block",
      transition: {
        "duration-100",
        "opacity-0 scale-95",
        "opacity-100 scale-100"
      }
    )
  end

  @doc """
  Hides the dropdown menu.
  """
  def hide_menu(id) do
    JS.hide(
      to: "##{id}-content",
      transition: {
        "duration-100",
        "opacity-100 scale-100",
        "opacity-0 scale-95"
      }
    )
  end
end
