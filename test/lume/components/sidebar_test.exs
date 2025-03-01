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

  @sample_nav_items_with_methods [
    %{icon: "hero-home", label: "Dashboard", path: "/dashboard", nav_item: :dashboard},
    %{icon: "hero-users", label: "Users", path: "/users", nav_item: :users, method: "post"},
    %{icon: "hero-trash", label: "Delete", href: "/delete", nav_item: :delete, method: "delete"},
    %{icon: "hero-cog", label: "Settings", navigate: "/settings", nav_item: :settings}
  ]

  describe "sidebar/1" do
    test "renders basic sidebar with title and logo" do
      assigns = %{sample_nav_items: @sample_nav_items, current_item: :dashboard}

      html =
        render_component(
          fn assigns ->
            ~H"""
            <.sidebar id="test-sidebar">
              <.brand title="Test App" logo="/images/logo.svg" />
              <.nav_items items={@sample_nav_items} current_item={nil} />
            </.sidebar>
            """
          end,
          assigns
        )

      parsed_html = Floki.parse_document!(html)

      # Check for both desktop and mobile containers
      desktop_container = Floki.find(parsed_html, ".lg\\:fixed.lg\\:inset-y-0")

      assert length(desktop_container) == 1,
             "Expected 1 desktop container, but found #{length(desktop_container)}."

      mobile_container = Floki.find(parsed_html, "#test-sidebar")

      assert length(mobile_container) == 1,
             "Expected 1 mobile container, but found #{length(mobile_container)}."

      # Check for title in the sidebar
      title_elements = Floki.find(parsed_html, "h1")

      assert length(title_elements) == 2,
             "Expected exactly 2 <h1> tags (desktop and mobile), but found #{length(title_elements)}."

      assert Floki.text(title_elements) =~ "Test App",
             "Expected <h1> to contain the text 'Test App', but found: #{Floki.text(title_elements)}."

      # Check for logo in the sidebar
      logo_elements = Floki.find(parsed_html, "img[src='/images/logo.svg']")

      assert length(logo_elements) == 2,
             "Expected exactly 2 logo images (desktop and mobile), but found #{length(logo_elements)}."

      assert Floki.attribute(logo_elements, "alt") == ["Test App", "Test App"],
             "Expected logo image to have alt text 'Test App', but found: #{inspect(Floki.attribute(logo_elements, "alt"))}."
    end

    test "renders navigation items correctly" do
      assigns = %{sample_nav_items: @sample_nav_items, current_item: :dashboard}

      html =
        render_component(
          fn assigns ->
            ~H"""
            <.sidebar id="test-sidebar">
              <.nav_items items={@sample_nav_items} current_item={@current_item} />
            </.sidebar>
            """
          end,
          assigns
        )

      parsed_html = Floki.parse_document!(html)

      # Check that we have navigation items
      nav_items = Floki.find(parsed_html, "li")
      assert length(nav_items) > 0, "Expected navigation items to be rendered"
      
      # Check for specific items by text
      assert html =~ "Dashboard"
      assert html =~ "Users"
      assert html =~ "Settings"
      
      # Check for active state on Dashboard
      active_items = Floki.find(parsed_html, "[aria-current='page']")
      assert length(active_items) > 0, "Expected at least one active item"
      assert Floki.text(active_items) =~ "Dashboard"
    end

    test "handles active navigation item" do
      assigns = %{sample_nav_items: @sample_nav_items, current_item: :users}

      html =
        render_component(
          fn assigns ->
            ~H"""
            <.sidebar id="test-sidebar">
              <.nav_items items={@sample_nav_items} current_item={@current_item} />
            </.sidebar>
            """
          end,
          assigns
        )

      parsed_html = Floki.parse_document!(html)

      # Find the active navigation item
      active_item = Floki.find(parsed_html, "[aria-current='page']")

      assert length(active_item) > 0,
             "Expected at least one active navigation item but found none."

      assert Floki.text(active_item) =~ "Users"

      # Check that other items are not marked as active
      non_active_items = Floki.find(parsed_html, "a:not([aria-current='page'])")

      for item <- non_active_items do
        refute Floki.text(item) =~ "Users", "Found unexpected active item"
      end
    end

    test "renders separator correctly" do
      assigns = %{sample_nav_items: @sample_nav_items}

      html =
        render_component(
          fn assigns ->
            ~H"""
            <.sidebar id="test-sidebar">
              <.nav_items items={@sample_nav_items} current_item={nil} />
            </.sidebar>
            """
          end,
          assigns
        )

      parsed_html = Floki.parse_document!(html)

      separators = Floki.find(parsed_html, "hr")
      assert length(separators) > 0, "Expected at least one separator"
      assert html =~ "my-2 bg-gray-200 dark:bg-zinc-700 border-0 h-px"
    end

    test "handles missing optional attributes" do
      assigns = %{sample_nav_items: @sample_nav_items}

      html =
        render_component(
          fn assigns ->
            ~H"""
            <.sidebar id="test-sidebar">
              <.nav_items items={@sample_nav_items} current_item={nil} />
            </.sidebar>
            """
          end,
          assigns
        )

      # No logo
      refute html =~ "<img"
      # No title
      refute html =~ ~s{font-extrabold}
      # Default nav item
      assert html =~ "Dashboard"
    end

    test "renders bottom_content slot when provided" do
      assigns = %{}

      html =
        render_component(
          fn assigns ->
            ~H"""
            <.sidebar id="test-sidebar">
              <.brand title="Test App" />
              <:bottom_content>
                <div class="bottom-test">Bottom content</div>
              </:bottom_content>
            </.sidebar>
            """
          end,
          assigns
        )

      parsed_html = Floki.parse_document!(html)
      
      # Check for bottom content
      bottom_content = Floki.find(parsed_html, ".bottom-test")
      assert length(bottom_content) == 2, "Expected bottom content in both desktop and mobile views"
      assert Floki.text(bottom_content) =~ "Bottom content"
      
      # Check that it's in the correct container
      bottom_containers = Floki.find(parsed_html, "div.mt-auto.pt-4")
      assert length(bottom_containers) == 2, "Expected bottom content container in both views"
    end
    
    test "doesn't render bottom_content container when slot is not provided" do
      assigns = %{}

      html =
        render_component(
          fn assigns ->
            ~H"""
            <.sidebar id="test-sidebar">
              <.brand title="Test App" />
            </.sidebar>
            """
          end,
          assigns
        )

      parsed_html = Floki.parse_document!(html)
      
      # Check that bottom content container is not present
      bottom_containers = Floki.find(parsed_html, "div.mt-auto.pt-4")
      assert length(bottom_containers) == 0, "Expected no bottom content container when slot is not provided"
    end
  end

  describe "brand/1" do
    test "renders with custom class" do
      assigns = %{}

      html =
        render_component(
          fn assigns ->
            ~H"""
            <.brand title="Test App" class="custom-class" />
            """
          end,
          assigns
        )

      parsed_html = Floki.parse_document!(html)
      
      # Check for custom class
      brand_container = Floki.find(parsed_html, "div")
      assert Floki.attribute(brand_container, "class") |> List.first() =~ "custom-class"
    end
  end

  describe "nav_items/1" do
    test "handles different link types and methods" do
      assigns = %{items: @sample_nav_items_with_methods, current_item: :dashboard}

      html =
        render_component(
          fn assigns ->
            ~H"""
            <.nav_items items={@items} current_item={@current_item} />
            """
          end,
          assigns
        )
      
      # Check that all items are rendered
      assert html =~ "Dashboard"
      assert html =~ "Users"
      assert html =~ "Delete"
      assert html =~ "Settings"
      
      # Check that items with different methods are rendered
      assert html =~ ~s{data-method="delete"}
      
      # Check for navigate link
      assert html =~ ~s{data-phx-link="redirect"}
    end
  end
end
