defmodule Lume.Components.Navbar do
  @moduledoc """
  A flexible navigation bar component for application headers.

  ## Features
    * Responsive design with mobile menu toggle
    * Customizable heading
    * Flexible right-side content through slots
    * Mobile-friendly with sidebar integration
    * Dark mode support

  ## Examples

      # Basic navbar with heading
      <.navbar>
        Dashboard
      </.navbar>

      # With notifications icon and user profile
      <.navbar>
        Settings
        <:right_content>
          <div class="flex items-center gap-x-4">
            <.icon_button icon="hero-bell" />
            <.user_profile user={@current_user} />
          </div>
        </:right_content>
      </.navbar>

      # Simple navbar with custom content
      <.navbar>
        Projects
        <:right_content>
          <.button>New Project</.button>
        </:right_content>
      </.navbar>
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS
  import Lume.Components.Icon

  @doc """
  Renders a navigation bar component.

  ## Attributes

    * `sidebar_id` - ID of the sidebar to toggle on mobile, defaults to "sidebar"
    * `menu_toggle` - Whether to show the menu toggle button, defaults to true

  ## Slots

    * `inner_block` - The content to be displayed in the main section of the navbar
    * `right_content` - Content to display on the right side of the navbar
  """
  attr :sidebar_id, :string, default: "sidebar"
  attr :menu_toggle, :boolean, default: true

  slot :inner_block, required: true
  slot :right_content

  def navbar(assigns) do
    ~H"""
    <nav class="sticky top-0 z-40 flex h-16 shrink-0 items-center gap-x-4 border-b border-gray-200 bg-white px-4 shadow-sm dark:bg-zinc-900 dark:border-white/10 sm:gap-x-6 sm:px-6 lg:px-8">
      <button
        :if={@menu_toggle}
        type="button"
        class="-m-2.5 p-2.5 text-gray-700 dark:text-gray-200 lg:hidden"
        phx-click={show_mobile_sidebar(@sidebar_id)}
      >
        <span class="sr-only">Open sidebar</span>
        <.icon name="hero-bars-3" class="h-6 w-6" />
      </button>

      <div class="flex flex-1 gap-x-4 self-stretch lg:gap-x-6">
        <div class="flex items-center gap-x-4 lg:gap-x-6">
          <span class="text-lg font-semibold text-black dark:text-white">
            {render_slot(@inner_block)}
          </span>
        </div>
        <div class="flex flex-1 items-center justify-end gap-x-4 lg:gap-x-6">
          {render_slot(@right_content)}
        </div>
      </div>
    </nav>
    """
  end

  defp show_mobile_sidebar(id) do
    # Show all elements immediately, then trigger transitions
    JS.show(to: "##{id}")
    |> JS.show(to: "##{id}-backdrop")
    |> JS.show(to: "##{id}-container")
    |> JS.remove_class("opacity-0", to: "##{id}-backdrop")
    |> JS.remove_class("-translate-x-full", to: "##{id}-container")
  end
end
