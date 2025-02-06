defmodule Lume do
  @moduledoc """
  Lume is a simple, modern UI component library for Phoenix LiveView.
  """

  defmacro __using__(_opts) do
    quote do
      import Phoenix.Component
      import Phoenix.LiveView

      import Lume.Components.Avatar
      import Lume.Components.Badge
      import Lume.Components.Breadcrumbs
      import Lume.Components.DropdownMenu
      import Lume.Components.Icon
      import Lume.Components.Navbar
      import Lume.Components.Separator
      import Lume.Components.Sidebar

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
    end
  end
end
