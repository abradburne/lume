defmodule Lume.Components.SidebarTest do
  use ExUnit.Case, async: true
  use Phoenix.Component
  import Phoenix.LiveViewTest

  import Lume.Components.Sidebar

  @sample_nav_items [
    %{icon: "hero-home", label: "Dashboard", path: "/dashboard", nav_item: :dashboard},
    %{icon: "hero-users", label: "Users", path: "/users", nav_item: :users},
    %{separator: true},
    %{icon: "hero-cog", label: "Settings", path: "/settings", nav_item: :settings}
  ]

  describe "sidebar/1" do
    test "renders basic sidebar with title and logo" do
      assigns = %{sample_nav_items: @sample_nav_items, current_item: :dashboard}

      html =
        render_component(fn assigns ->
          ~H"""
          <.sidebar id="test-sidebar">
            <h1 class="text-xl font-extrabold text-zinc-800 dark:text-white">Test App</h1>
            <img src="/images/logo.svg" alt="Test App" class="h-6 w-auto" />
            <.nav_items items={@sample_nav_items} current_item={nil} />
          </.sidebar>
          """
        end, assigns)

      parsed_html = Floki.parse_document!(html)

      # Check for both desktop and mobile containers
      desktop_container = Floki.find(parsed_html, ".lg\\:fixed.lg\\:inset-y-0")

      assert length(desktop_container) == 1,
             "Expected 1 desktop container, but found #{length(desktop_container)}."

      mobile_container = Floki.find(parsed_html, ".fixed.inset-0.z-50.lg\\:hidden")

      assert length(mobile_container) == 1,
             "Expected 1 mobile container, but found #{length(mobile_container)}."

      # Check for title in both desktop and mobile containers
      for container <- [desktop_container, mobile_container] do
        title_elements = Floki.find(container, "h1")

        assert length(title_elements) == 1,
               "Expected exactly 1 <h1> tag in the container, but found #{length(title_elements)}."

        assert Floki.text(title_elements) =~ "Test App",
               "Expected <h1> to contain the text 'Test App', but found: #{Floki.text(title_elements)}."
      end

      # Check for logo in both desktop and mobile containers
      for container <- [desktop_container, mobile_container] do
        logo_elements = Floki.find(container, "img[src='/images/logo.svg']")

        assert length(logo_elements) == 1,
               "Expected exactly 1 logo image in the container, but found #{length(logo_elements)}."

        assert Floki.attribute(logo_elements, "alt") == ["Test App"],
               "Expected logo image to have alt text 'Test App', but found: #{inspect(Floki.attribute(logo_elements, "alt"))}."
      end
    end

    test "renders navigation items correctly" do
      assigns = %{sample_nav_items: @sample_nav_items, current_item: :dashboard}

      html =
        render_component(fn assigns ->
          ~H"""
          <.sidebar id="test-sidebar">
            <.nav_items items={@sample_nav_items} current_item={@current_item} />
          </.sidebar>
          """
        end, assigns)

      parsed_html = Floki.parse_document!(html)

      # Define expected items with attributes
      expected_items = [
        %{name: "Dashboard", href: "/dashboard", icon: "hero-home", active: true},
        %{name: "Users", href: "/users", icon: "hero-users", active: false},
        %{name: "Settings", href: "/settings", icon: "hero-cog", active: false}
      ]

      for item <- expected_items do
        # Find the nav item by its href
        elements = Floki.find(parsed_html, "a[href='#{item.href}']")

        assert length(elements) == 2, "Expected exactly two links for #{item.name} (desktop and mobile), but found #{length(elements)}."
        element = hd(elements)
        assert Floki.text(element) =~ item.name
        assert Floki.find(element, "[class*='#{item.icon}']") != [],
               "Expected icon #{item.icon} for #{item.name}."

        # Verify active/inactive state
        if item.active do
          assert Floki.attribute(element, "class")
                 |> Enum.any?(fn class -> class =~ "bg-gray-50 text-indigo-600" end),
                 "#{item.name} should be active but is not."
        else
          refute Floki.attribute(element, "class")
                 |> Enum.any?(fn class -> class =~ "bg-gray-50 text-indigo-600" end),
                 "#{item.name} should not be active but is."
        end
      end
    end

    test "handles active navigation item" do
      assigns = %{sample_nav_items: @sample_nav_items, current_item: :users}

      html =
        render_component(fn assigns ->
          ~H"""
          <.sidebar id="test-sidebar">
            <.nav_items items={@sample_nav_items} current_item={@current_item} />
          </.sidebar>
          """
        end, assigns)

      parsed_html = Floki.parse_document!(html)

      # Find the active navigation item
      active_item = Floki.find(parsed_html, "[aria-current='page']")
      assert length(active_item) == 2, "Expected exactly two active navigation items (desktop and mobile) but found #{length(active_item)}."
      assert Floki.text(active_item) =~ "Users"

      # Check that other items are not marked as active
      non_active_items = Floki.find(parsed_html, "a:not([aria-current='page'])")

      for item <- non_active_items do
        assert Floki.text(item) != "Users", "Found unexpected active item"
      end
    end

    test "renders separator correctly" do
      assigns = %{sample_nav_items: @sample_nav_items}

      html =
        render_component(fn assigns ->
          ~H"""
          <.sidebar id="test-sidebar">
            <.nav_items items={@sample_nav_items} current_item={nil} />
          </.sidebar>
          """
        end, assigns)

      parsed_html = Floki.parse_document!(html)

      separators = Floki.find(parsed_html, "hr")
      assert length(separators) == 2, "Expected exactly two separators (desktop and mobile)"
      assert html =~ "my-2 bg-gray-200 dark:bg-zinc-700 border-0 h-px"
    end

    test "handles missing optional attributes" do
      assigns = %{sample_nav_items: @sample_nav_items}

      html =
        render_component(fn assigns ->
          ~H"""
          <.sidebar id="test-sidebar">
            <.nav_items items={@sample_nav_items} current_item={nil} />
          </.sidebar>
          """
        end, assigns)

      refute html =~ "<img"                 # No logo
      refute html =~ ~s{font-extrabold}     # No title
      assert html =~ "Dashboard"            # Default nav item
    end
  end
end
