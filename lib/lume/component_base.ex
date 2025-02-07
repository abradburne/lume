defmodule Lume.ComponentBase do
  @moduledoc """
  Base module for Lume components.

  Provides common configuration for Phoenix.Component and Gettext.
  """

  defmacro __using__(opts) do
    quote do
      use Phoenix.Component
      use Gettext, backend: unquote(opts[:gettext_backend] || Lume.Gettext)
    end
  end
end
