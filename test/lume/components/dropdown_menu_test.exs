defmodule Lume.Components.DropdownMenuTest do
  use ExUnit.Case, async: true
  use Phoenix.Component
  import Phoenix.LiveViewTest

  import Lume.Components.DropdownMenu

  describe "dropdown_menu/1" do
    test "renders dropdown menu with trigger and items" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.dropdown_menu id="user-menu">
            <:trigger>
              <button type="button" class="text-sm">Options</button>
            </:trigger>
            <.menu_item>
              Profile
            </.menu_item>
            <.menu_item>
              Settings
            </.menu_item>
          </.dropdown_menu>
          """
        end, %{})

      assert html =~ "Options"
      assert html =~ "Profile"
      assert html =~ "Settings"
      assert html =~ ~s{id="user-menu-trigger"}
      assert html =~ ~s{id="user-menu-content"}
      assert html =~ ~s{phx-click-away=}
      assert html =~ ~s{phx-key="escape"}
    end

    test "renders with custom attributes" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.dropdown_menu id="custom-menu" class="custom-class">
            <:trigger>
              <button type="button" class="text-sm">Custom Options</button>
            </:trigger>
            <.menu_item>Item</.menu_item>
          </.dropdown_menu>
          """
        end, %{})

      assert html =~ "custom-menu"
      assert html =~ "Custom Options"
      assert html =~ "custom-class"
    end

    test "renders with label instead of trigger" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.dropdown_menu id="label-menu" label="Menu Label">
            <.menu_item>Item</.menu_item>
          </.dropdown_menu>
          """
        end, %{})

      assert html =~ "Menu Label"
    end

    test "renders with different alignments" do
      left_html =
        render_component(fn assigns ->
          ~H"""
          <.dropdown_menu id="left-menu" align={:left}>
            <:trigger>Menu</:trigger>
            <.menu_item>Item</.menu_item>
          </.dropdown_menu>
          """
        end, %{})

      right_html =
        render_component(fn assigns ->
          ~H"""
          <.dropdown_menu id="right-menu" align={:right}>
            <:trigger>Menu</:trigger>
            <.menu_item>Item</.menu_item>
          </.dropdown_menu>
          """
        end, %{})

      assert left_html =~ "origin-top-left"
      assert right_html =~ "origin-top-right"
    end

    test "renders with different sizes" do
      for size <- [:sm, :md, :lg] do
        html =
          render_component(fn assigns ->
            assigns = assign(assigns, :size, size)
            ~H"""
            <.dropdown_menu id={"#{@size}-menu"} menu_size={@size}>
              <:trigger>Menu</:trigger>
              <.menu_item>Item</.menu_item>
            </.dropdown_menu>
            """
          end, %{})

        size_class = case size do
          :sm -> "min-w-48"
          :md -> "min-w-64"
          :lg -> "min-w-80"
        end

        assert html =~ size_class
      end
    end
  end

  describe "menu_item/1" do
    test "renders menu_items with icon" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.dropdown_menu id="user-menu" label="Menu">
            <.menu_item icon="hero-home">
              Dashboard
            </.menu_item>
            <.menu_item icon="hero-users">
              Users
            </.menu_item>
          </.dropdown_menu>
          """
        end, %{})

      assert html =~ ~r{<span.*hero-home.*</span>}
      assert html =~ ~r{<span.*hero-users.*</span>}
    end

    test "renders menu items with different variants" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.dropdown_menu id="variant-menu">
            <:trigger>Menu</:trigger>
            <.menu_item variant={:default}>
              Default Item
            </.menu_item>
            <.menu_item variant={:warning}>
              Warning Item
            </.menu_item>
            <.menu_item variant={:danger}>
              Danger Item
            </.menu_item>
          </.dropdown_menu>
          """
        end, %{})

      assert html =~ "Default Item"
      assert html =~ "text-gray-700" # Default variant class
      assert html =~ "Warning Item"
      assert html =~ "text-yellow-600" # Default variant class
      assert html =~ "Danger Item"
      assert html =~ "text-red-600" # Error variant class
    end

    test "renders disabled menu items" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.dropdown_menu id="disabled-menu">
            <:trigger>Menu</:trigger>
            <.menu_item disabled={true}>
              Disabled Item
            </.menu_item>
          </.dropdown_menu>
          """
        end, %{})

      assert html =~ "Disabled Item"
      assert html =~ "opacity-50"
      assert html =~ "cursor-not-allowed"
    end

    test "renders menu items with custom classes" do
      html =
        render_component(fn assigns ->
          ~H"""
          <.dropdown_menu id="custom-item-menu">
            <:trigger>Menu</:trigger>
            <.menu_item class="custom-item-class">
              Custom Item
            </.menu_item>
          </.dropdown_menu>
          """
        end, %{})

      assert html =~ "custom-item-class"
      assert html =~ "Custom Item"
    end
  end
end
