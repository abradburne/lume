defmodule Lume.Components.DropdownMenu do
  @moduledoc """
  A flexible dropdown menu component with smooth transitions.

  ## Features
    * Flexible trigger content (button, text, avatar, etc.)
    * Menu items with optional icons and variants
    * Smooth transitions using Phoenix.LiveView.JS
    * Dark mode support
    * Configurable alignment (left, right)
    * Multiple size variants
    * Click outside or escape key to close
    * Keyboard navigation support
    * Support for right-aligned content in menu items

  ## Basic Usage

  The dropdown menu can be used with a built-in trigger (icon + label) or with a custom trigger:

  ```heex
  # With icon and label (disclosure indicator is shown by default)
  <.dropdown_menu id="user-menu" icon="hero-user" label="User Menu">
    <.menu_item>Profile</.menu_item>
    <.menu_item>Settings</.menu_item>
  </.dropdown_menu>

  # Without disclosure indicator
  <.dropdown_menu id="menu" icon="hero-cog-6-tooth" label="Settings" disclosure={false}>
    <.menu_item>General</.menu_item>
    <.menu_item>Advanced</.menu_item>
  </.dropdown_menu>

  # Or with a custom trigger
  <.dropdown_menu id="custom-trigger">
    <:trigger>
      <button type="button" class="text-sm">Custom Trigger</button>
    </:trigger>
    <.menu_item>Profile</.menu_item>
  </.dropdown_menu>
  ```

  ## Menu Items

  Menu items support several features:

  ### Icons and Variants

  ```heex
  <.dropdown_menu id="menu-with-variants">
    <.menu_item icon="hero-user">
      Profile
    </.menu_item>
    <.menu_item icon="hero-cog-6-tooth" variant={:warning}>
      Settings
    </.menu_item>
    <.menu_item icon="hero-arrow-right-on-rectangle" variant={:danger}>
      Sign out
    </.menu_item>
  </.dropdown_menu>
  ```

  ### Right-aligned Content

  Perfect for displaying keyboard shortcuts or additional information:

  ```heex
  <.dropdown_menu id="menu-with-shortcuts">
    <.menu_item icon="hero-magnifying-glass">
      Search
      <:right_content>
        <kbd class="text-xs">⌘K</kbd>
      </:right_content>
    </.menu_item>
    <.menu_item icon="hero-trash" variant={:danger}>
      Delete
      <:right_content>
        <kbd class="text-xs">⌘⌫</kbd>
      </:right_content>
    </.menu_item>
  </.dropdown_menu>
  ```

  ### Disabled Items

  ```heex
  <.dropdown_menu id="menu-with-disabled">
    <.menu_item>Enabled Item</.menu_item>
    <.menu_item disabled={true}>Disabled Item</.menu_item>
  </.dropdown_menu>
  ```

  ### Using Separators

  Use the separator component to group related items:

  ```heex
  <.dropdown_menu id="menu-with-separator">
    <.menu_item icon="hero-user">Profile</.menu_item>
    <.menu_item icon="hero-cog-6-tooth">Settings</.menu_item>
    <.separator />
    <.menu_item icon="hero-arrow-right-on-rectangle" variant={:danger}>
      Sign out
    </.menu_item>
  </.dropdown_menu>
  ```

  ## Customization

  ### Size Variants

  Both the trigger and menu items can be sized independently:

  ```heex
  <.dropdown_menu id="large-menu" size={:lg} menu_size={:lg}>
    <.menu_item size={:lg}>Large Item</.menu_item>
  </.dropdown_menu>
  ```

  Available sizes:
  - `:sm` - Compact size
  - `:md` - Default size
  - `:lg` - Large size

  ### Menu Alignment

  Control which side the menu appears on:

  ```heex
  <.dropdown_menu id="right-menu" align={:right}>
    <.menu_item>Right-aligned Menu</.menu_item>
  </.dropdown_menu>
  ```

  ## Accessibility

  The dropdown menu implements several accessibility features:
  - Keyboard navigation (Tab, Enter, Space, Escape)
  - ARIA roles and attributes
  - Focus management
  - Screen reader support
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  import Lume.Components.UtilComponents

  @alignments [:left, :right]
  @variants [:default, :danger, :warning]
  @sizes [:sm, :md, :lg]

  @label_sizes %{
    sm: "text-sm",
    md: "text-sm",
    lg: "text-base"
  }

  @menu_sizes %{
    sm: "min-w-48",
    md: "min-w-64",
    lg: "min-w-80"
  }

  # @menu_items_classes %{
  #   sm: "px-2 py-1 space-y-2 gap-x-1.5 text-sm",
  #   md: "px-2 py-1.5 space-y-2 gap-x-2 text-sm",
  #   lg: "px-3 py-2.5 space-y-2 gap-x-2.5 text-base"
  # }

  @icon_sizes %{
    sm: "h-4 w-4",
    md: "h-5 w-5",
    lg: "h-6 w-6"
  }

  @variant_classes %{
    default: "text-gray-700 hover:bg-gray-100 hover:text-gray-900 focus:bg-gray-100 focus:text-gray-900 dark:text-gray-300 dark:hover:bg-zinc-700/50 dark:hover:text-white dark:focus:bg-zinc-700/50 dark:focus:text-white",
    danger: "text-red-600 hover:bg-red-50 hover:text-red-700 focus:bg-red-50 focus:text-red-700 dark:text-red-400 dark:hover:bg-red-900/20 dark:hover:text-red-300 dark:focus:bg-red-900/20 dark:focus:text-red-300",
    warning: "text-yellow-600 hover:bg-yellow-50 hover:text-yellow-700 focus:bg-yellow-50 focus:text-yellow-700 dark:text-yellow-400 dark:hover:bg-yellow-900/20 dark:hover:text-yellow-300 dark:focus:bg-yellow-900/20 dark:focus:text-yellow-300"
  }

  @menu_item_sizes %{
    sm: "gap-x-2 px-3 py-1.5 text-sm",
    md: "gap-x-2.5 px-4 py-2 text-sm",
    lg: "gap-x-3 px-4 py-2.5 text-base"
  }

  @menu_item_icon_sizes %{
    sm: "h-4 w-4",
    md: "h-5 w-5",
    lg: "h-5 w-5"
  }

  @doc """
  Renders a dropdown menu component.

  ## Attributes

    * `id` - Required unique identifier for the dropdown
    * `label` - Optional text label for the trigger (replaces the trigger slot)
    * `icon` - Optional icon name to display (replaces the trigger slot)
    * `disclosure` - Whether to show a disclosure indicator in the trigger, defaults to true
    * `align` - Alignment of the menu (`:left` or `:right`), defaults to `:left`
    * `size` - Size variant for the trigger label and icons (`:sm`, `:md`, `:lg`), defaults to `:md`
    * `menu_size` - Size variant for the menu width (`:sm`, `:md`, `:lg`), defaults to `:md`
    * `class` - Additional CSS classes to apply to the trigger container
    * `menu_class` - Additional CSS classes to apply to the menu container

  ## Slots

    * `trigger` - The content that triggers the dropdown menu (overrides label and icon)
    * `inner_block` - The content of the dropdown menu (typically menu_item components)

  ## Examples

      <.dropdown_menu
        id="user-menu"
        icon="hero-user"
        label="User Menu"
        menu_size={:lg}
      >
        <.menu_item>
          <.link navigate={~p"/profile"} class="w-full">Profile</.link>
        </.menu_item>
        <.menu_item>
          <.link patch={~p"/settings"} class="w-full">Settings</.link>
        </.menu_item>
        <.menu_item variant={:danger}>
          <button type="button" class="w-full" phx-click="logout">Sign out</button>
        </.menu_item>
      </.dropdown_menu>
  """
  attr :id, :string, required: true
  attr :label, :string, default: nil
  attr :icon, :string, default: nil
  attr :disclosure, :boolean, default: true
  attr :align, :atom, default: :left, values: @alignments
  attr :size, :atom, default: :md, values: @sizes
  attr :menu_size, :atom, default: :md, values: @sizes
  attr :class, :string, default: nil
  attr :menu_class, :string, default: nil

  slot :trigger
  slot :inner_block, required: true

  def dropdown_menu(assigns) do
    ~H"""
    <div class={["relative inline-block text-left", @class]}>
      <button
        type="button"
        id={"#{@id}-trigger"}
        aria-haspopup="true"
        aria-expanded="false"
        phx-click={toggle_menu(@id)}
        class="cursor-pointer"
      >
        <span
          :if={@label || @icon}
          class={[
            "flex items-center gap-x-2 hover:bg-zinc-100 dark:hover:bg-zinc-700 rounded-md px-4 py-3",
            trigger_label_classes(@size)
          ]}
        >
          <.icon
            :if={@icon}
            name={@icon}
            class={trigger_icon_classes(@size)}
          />
          {@label}
          <.icon
            :if={@disclosure}
            name="hero-chevron-down"
            class={chevron_classes(@size)}
          />
        </span>
        <%= render_slot(@trigger) %>
      </button>

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
            menu_size_classes(@menu_size),
            @menu_class
          ]}
          aria-labelledby={"#{@id}-trigger"}
        >
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders a menu item within a dropdown menu.

  ## Attributes

    * `variant` - Optional color variant (`:default`, `:danger`, or `:warning`)
    * `disabled` - Optional boolean to disable the item
    * `icon` - Optional icon name to display
    * `class` - Additional CSS classes for the menu item
    * `rest` - Any additional HTML attributes

  ## Slots

    * `right_content` - Content to display on the right side of the menu item
    * `inner_block` - The content of the menu item

  ## Examples

      <.menu_item variant={:danger} icon="hero-trash">
        Delete
        <:right_content>
          <kbd class="text-xs">⌘D</kbd>
        </:right_content>
      </.menu_item>
  """
  attr :variant, :atom, default: :default, values: @variants
  attr :disabled, :boolean, default: false
  attr :icon, :string
  attr :size, :atom, default: :md, values: @sizes
  attr :class, :string, default: nil
  attr :rest, :global

  slot :inner_block, required: true
  slot :right_content

  def menu_item(assigns) do
    ~H"""
    <div
      role="menuitem"
      tabindex={if(@disabled, do: "-1", else: "0")}
      class={[
        "flex min-w-0 w-full items-center justify-between",
        menu_item_sizes(@size),
        menu_item_variant_classes(@variant),
        if(@disabled, do: "opacity-50 cursor-not-allowed", else: "cursor-pointer"),
        @class
      ]}
      {@rest}
    >
      <div class="flex min-w-0 items-center gap-x-2">
        <.icon :if={@icon} name={@icon} class={["flex-shrink-0", menu_item_icon_sizes(@size)]} />
        <span class="truncate"><%= render_slot(@inner_block) %></span>
      </div>
      <%= if @right_content do %>
        <div class="flex-shrink-0 ml-2">
          <%= render_slot(@right_content) %>
        </div>
      <% end %>
    </div>
    """
  end

  defp menu_alignment_classes(:left), do: "left-0 origin-top-left"
  defp menu_alignment_classes(:right), do: "right-0 origin-top-right"

  defp trigger_label_classes(size), do: Map.fetch!(@label_sizes, size)

  defp trigger_icon_classes(size), do: Map.fetch!(@icon_sizes, size)

  defp chevron_classes(:sm), do: "h-3 w-3"
  defp chevron_classes(:md), do: "h-4 w-4"
  defp chevron_classes(:lg), do: "h-5 w-5"

  defp menu_size_classes(size), do: Map.fetch!(@menu_sizes, size)

  # defp menu_items_classes(size), do: Map.fetch!(@menu_items_classes, size)

  defp menu_item_sizes(size), do: Map.fetch!(@menu_item_sizes, size)

  defp menu_item_icon_sizes(size), do: Map.fetch!(@menu_item_icon_sizes, size)

  defp menu_item_variant_classes(variant), do: Map.fetch!(@variant_classes, variant)

  @doc """
  Toggles the visibility of the dropdown menu.
  """
  def toggle_menu(id) do
    JS.toggle(
      to: "##{id}-content",
      in: {
        "duration-100",
        "opacity-0 scale-95",
        "opacity-100 scale-100"
      },
      out: {
        "duration-100",
        "opacity-100 scale-100",
        "opacity-0 scale-95"
      }
    )
  end

  @doc """
  Shows the dropdown menu.
  """
  def show_menu(id) do
    JS.show(
      to: "##{id}-content",
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
