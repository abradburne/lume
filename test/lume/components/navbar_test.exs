defmodule Lume.Components.NavbarTest do
  use ExUnit.Case, async: true
  use Phoenix.Component
  import Phoenix.LiveViewTest

  import Lume.Components.Navbar

  describe "navbar/1" do
    test "renders basic navbar with heading" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.navbar>
            Dashboard
          </.navbar>
          """
        end, %{})

      assert html =~ "Dashboard"
      # sr-only text
      assert html =~ "Open sidebar"
      # mobile menu icon
      assert html =~ ~s{class="hero-bars-3 h-6 w-6"}
    end

    test "renders with custom sidebar_id" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.navbar sidebar_id="custom-sidebar">
            Dashboard
          </.navbar>
          """
        end, %{})

      assert html =~ "custom-sidebar"
      assert html =~ "Dashboard"
    end

    test "renders right content slot" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.navbar>
            Dashboard
            <:right_content>
              <div class="test-button">Notifications</div>
            </:right_content>
          </.navbar>
          """
        end, %{})

      assert html =~ ~s{class="test-button"}
      assert html =~ "Notifications"
    end

    test "renders without heading" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.navbar>
          </.navbar>
          """
        end, %{})

      # Should still render the structure but with empty heading
      assert html =~ ~s{class="text-lg font-semibold text-black dark:text-white"}
      assert html =~ ~r/<span[^>]*class="text-lg font-semibold text-black dark:text-white"[^>]*>\s*<\/span>/
    end

    test "includes proper responsive classes" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.navbar>
            Dashboard
          </.navbar>
          """
        end, %{})

      # Mobile classes & menu button
      assert html =~ ~s{-m-2.5 p-2.5 text-gray-700 dark:text-gray-200 lg:hidden}
      assert html =~ "sm:gap-x-6"
      assert html =~ "sm:px-6"

      # Desktop classes
      assert html =~ "lg:px-8"
      assert html =~ "lg:gap-x-6"
    end

    test "includes dark mode classes" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.navbar>
            Dashboard
          </.navbar>
          """
        end, %{})

      assert html =~
               ~s{class="sticky top-0 z-40 flex h-16 shrink-0 items-center gap-x-4 border-b border-gray-200 bg-white px-4 shadow-sm dark:bg-zinc-900 dark:border-white/10 sm:gap-x-6 sm:px-6 lg:px-8"}
    end

    test "renders multiple right content items" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.navbar>
            Dashboard
            <:right_content>
              <div class="flex gap-2">
                <div class="btn-1">Button 1</div>
                <div class="btn-2">Button 2</div>
              </div>
            </:right_content>
          </.navbar>
          """
        end, %{})

      assert html =~ "btn-1"
      assert html =~ "Button 1"
      assert html =~ "btn-2"
      assert html =~ "Button 2"
    end
  end
end
