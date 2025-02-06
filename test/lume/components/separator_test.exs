defmodule Lume.Components.SeparatorTest do
  use ExUnit.Case, async: true
  use Phoenix.Component
  import Phoenix.LiveViewTest

  import Lume.Components.Separator

  describe "separator/1" do
    test "renders a separator line" do
      html =
        render_component(
          fn assigns ->
            ~H"""
            <.separator />
            """
          end,
          %{}
        )

      assert html =~ ~r"<hr[^>]*>"
    end
  end
end
