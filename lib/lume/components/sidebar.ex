defmodule Lume.Components.Sidebar do
  @moduledoc """
  A responsive sidebar component for application navigation.

  ## Features
    * Responsive design with mobile and desktop layouts
    * Smooth mobile transitions with backdrop
    * Customizable content through slots
    * Support for logo and title
    * Dark mode support

  ## Examples

      # Basic sidebar with branding and navigation
      <.sidebar>
        <.brand title="My App" logo="/images/logo.svg" />
        <.nav_items
          items={[
            %{icon: "hero-home", label: "Dashboard", path: "/", nav_item: :dashboard},
            %{icon: "hero-users", label: "Users", path: "/users", nav_item: :users},
            %{separator: true},
            %{icon: "hero-cog", label: "Settings", path: "/settings", nav_item: :settings}
          ]}
          current_item={:dashboard}
        />
      </.sidebar>

      # Sidebar with custom content
      <.sidebar id="admin-sidebar">
        <.brand title="MyApp Admin Panel" />
        <.separator />
        <div class="p-4">
          <h2 class="text-lg font-semibold">Custom Content</h2>
          <p>Add any content here!</p>
        </div>
      </.sidebar>

      # Sidebar with bottom content
      <.sidebar id="admin-sidebar">
        <.brand title="MyApp Admin Panel" />
        <.separator />
        <div class="p-4">
          <h2 class="text-lg font-semibold">Custom Content</h2>
          <p>Add any content here!</p>
        </div>
        <.separator />
        <.bottom_content>
          <p>Custom bottom content</p>
        </.bottom_content>
      </.sidebar>
  """
  use Phoenix.Component
  import Lume.Components.Separator
  import Lume.Components.Icon
  alias Phoenix.LiveView.JS

  @doc """
  Renders the main sidebar component.

  ## Attributes

    * `id` - Optional unique identifier for the sidebar, defaults to "sidebar"
    * `desktop_hidden` - Optional boolean to hide the sidebar on desktop view while keeping mobile functionality, defaults to false

  ## Slots

    * `inner_block` - The content to be displayed in the sidebar
    * `bottom_content` - Content to be displayed at the bottom of the sidebar
  """
  attr :id, :string, default: "sidebar"
  attr :desktop_hidden, :boolean, default: false, doc: "Optional boolean to hide the sidebar on desktop view while keeping mobile functionality"
  slot :inner_block, required: true
  slot :bottom_content, doc: "Content to be displayed at the bottom of the sidebar"

  def sidebar(assigns) do
    ~H"""
    <div>
      <%!-- Desktop sidebar --%>
      <div class={"#{if @desktop_hidden, do: "hidden", else: "hidden lg:fixed lg:inset-y-0 lg:z-50 lg:flex lg:w-72 lg:flex-col"}"}>
        <div class="flex grow flex-col gap-y-5 overflow-y-auto bg-white px-6 pb-4 ring-1 ring-black/10 dark:bg-zinc-900 dark:ring-white/10">
          <.sidebar_content {assigns} />
        </div>
      </div>

      <%!-- Mobile sidebar --%>
      <div id={@id} class="fixed inset-0 z-50 hidden h-full" aria-modal="true">
        <%!-- Backdrop --%>
        <div
          id={"#{@id}-backdrop"}
          class="fixed inset-0 bg-gray-900/80 hidden h-full opacity-0 transition-opacity duration-300 ease-in-out"
          aria-hidden="true"
          phx-click={hide_mobile_sidebar(@id)}
        />

        <%!-- Sliding sidebar --%>
        <div class="fixed inset-0 flex h-full">
          <div
            id={"#{@id}-container"}
            class="relative flex w-full max-w-xs flex-1 h-full -translate-x-full transition-transform duration-300 ease-in-out"
          >
            <%!-- Close button --%>
            <div class="absolute left-full top-0 flex w-16 justify-center pt-5">
              <button type="button" class="-m-2.5 p-2.5" phx-click={hide_mobile_sidebar(@id)}>
                <span class="sr-only">Close sidebar</span>
                <.icon name="hero-x-mark" class="h-6 w-6 text-white" />
              </button>
            </div>

            <%!-- Sidebar content --%>
            <div class="h-screen flex grow flex-col gap-y-5 overflow-y-auto bg-white px-6 pb-4 ring-1 ring-white/10 dark:bg-zinc-900">
              <.sidebar_content {assigns} />
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp sidebar_content(assigns) do
    ~H"""
    <div class="flex flex-col h-full justify-between">
      <div class="flex-grow overflow-y-auto">
        {render_slot(@inner_block)}
      </div>
      <div :if={@bottom_content != []} class="mt-auto pt-4">
        {render_slot(@bottom_content)}
      </div>
    </div>
    """
  end

  defp hide_mobile_sidebar(id) do
    # First trigger the transitions
    JS.add_class("opacity-0", to: "##{id}-backdrop")
    |> JS.add_class("-translate-x-full", to: "##{id}-container")
    # Then hide elements after transitions complete
    |> JS.hide(to: "##{id}", transition: {"duration-300", "", ""})
    |> JS.hide(to: "##{id}-backdrop", transition: {"duration-300", "", ""})
    |> JS.hide(to: "##{id}-container", transition: {"duration-300", "", ""})
  end

  @doc """
  Renders the branding section of the sidebar.

  ## Attributes

    * `title` - Optional title text to display at the top
    * `logo` - Optional path to logo image
    * `class` - Additional CSS classes to apply to the branding section


  ## Slots

    * `inner_block` - The content to be displayed below the title
  """
  attr :title, :string, default: nil
  attr :logo, :string, default: nil
  attr :class, :string, default: nil

  slot :inner_block

  def brand(assigns) do
    ~H"""
    <div :if={@title || @logo}
      class={[
        "flex h-16 shrink-0 items-center",
        @class
      ]}>
      <div :if={@title || @logo} class="flex shrink-0 items-center gap-2">
        <img :if={@logo} src={@logo} alt={@title || "Logo"} class="h-6 w-auto" />
        <h1 :if={@title} class="text-xl font-extrabold text-zinc-800 dark:text-white">
          {@title}
        </h1>
      </div>
    </div>
    {render_slot(@inner_block)}
    """
  end

  @doc """
  Navigation items component for the sidebar.

  ## Attributes

    * `items` - List of navigation item maps with the following structure:
        * `icon` - Icon name (for heroicons, use "hero-*")
        * `label` - Display text
        * `path` - Navigation path
        * `method` - HTTP method for the navigation link (e.g., "get", "post")
        * `nav_item` - Atom identifier
        * `separator` - Boolean to render a separator instead of a nav item
    * `current_item` - Atom identifying the current navigation item
  """
  attr :items, :list, required: true
  attr :current_item, :atom, required: true

  def nav_items(assigns) do
    ~H"""
    <nav class="flex flex-1 flex-col" aria-label="Sidebar">
      <ul role="list" class="-mx-2 space-y-1">
        <%= for item <- @items do %>
          <%= if Map.get(item, :separator) do %>
            <.separator />
          <% else %>
            <li class="w-full px-2">
              <.link
                navigate={Map.get(item, :navigate)}
                href={Map.get(item, :href)}
                method={Map.get(item, :method, "get")}
                class={[
                  "group flex gap-x-3 rounded-md text-sm leading-6 w-full py-2",
                  if(@current_item == item.nav_item,
                    do: "bg-gray-50 text-indigo-600 dark:bg-zinc-800/90 dark:text-indigo-400",
                    else:
                      "text-gray-700 hover:text-indigo-600 hover:bg-gray-50 dark:text-gray-300 dark:hover:bg-zinc-800/90 dark:hover:text-indigo-400"
                  )
                ]}
                aria-current={if @current_item == item.nav_item, do: "page", else: nil}
              >
                <span class="flex h-6 w-6 items-center justify-center rounded-lg">
                  <.icon
                    name={item.icon}
                    class={[
                      "h-5 w-5",
                      if(@current_item == item.nav_item,
                        do: "text-indigo-600 dark:text-indigo-400",
                        else:
                          "text-gray-400 group-hover:text-indigo-600 dark:text-gray-400 dark:group-hover:text-indigo-400"
                      )
                    ]}
                  />
                </span>
                <span class="truncate">{item.label}</span>
              </.link>
            </li>
          <% end %>
        <% end %>
      </ul>
    </nav>
    """
  end
end
