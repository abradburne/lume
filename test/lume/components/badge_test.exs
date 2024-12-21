defmodule Lume.Components.BadgeTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest
  import Phoenix.Component, only: [sigil_H: 2]

  alias Lume.Components.Badge

  describe "badge/1" do
    test "renders basic badge with default styling" do
      assigns = %{}

      html =
        render_component(&Badge.badge/1,
          inner_block: [
            %{
              inner_block: fn _assigns, _context ->
                ~H"""
                <span>Default</span>
                """
              end
            }
          ]
        )

      assert html =~ "bg-gray-100"
      assert html =~ "text-gray-700"
      assert html =~ "Default"
    end

    test "applies variant styles correctly" do
      variants = [:default, :primary, :success, :warning, :error]

      variant_classes = %{
        default: "bg-gray-100 text-gray-700",
        primary: "bg-indigo-100 text-indigo-700",
        success: "bg-green-100 text-green-700",
        warning: "bg-yellow-100 text-yellow-700",
        error: "bg-red-100 text-red-700"
      }

      for variant <- variants do
        assigns = %{}

        html =
          render_component(&Badge.badge/1,
            variant: variant,
            inner_block: [
              %{
                inner_block: fn _assigns, _context ->
                  ~H"""
                  <span>Badge</span>
                  """
                end
              }
            ]
          )

        assert html =~ variant_classes[variant]
      end
    end

    test "applies size classes correctly" do
      assigns = %{}

      size_classes = %{
        sm: "px-2 py-0.5 text-xs",
        md: "px-2.5 py-0.5 text-sm",
        lg: "px-3 py-1 text-base"
      }

      for {size, classes} <- size_classes do
        html =
          render_component(&Badge.badge/1,
            size: size,
            inner_block: [
              %{
                inner_block: fn _assigns, _context ->
                  ~H"""
                  <span>Badge</span>
                  """
                end
              }
            ]
          )

        assert html =~ classes
      end
    end

    test "applies shape variants correctly" do
      assigns = %{}

      pill_html =
        render_component(&Badge.badge/1,
          shape: :pill,
          inner_block: [
            %{
              inner_block: fn _assigns, _context ->
                ~H"""
                <span>Badge</span>
                """
              end
            }
          ]
        )

      flat_html =
        render_component(&Badge.badge/1,
          shape: :flat,
          inner_block: [
            %{
              inner_block: fn _assigns, _context ->
                ~H"""
                <span>Badge</span>
                """
              end
            }
          ]
        )

      assert pill_html =~ "rounded-full"
      assert flat_html =~ "rounded"
    end

    test "renders with border when bordered is true" do
      assigns = %{}

      html =
        render_component(&Badge.badge/1,
          bordered: true,
          variant: :primary,
          inner_block: [
            %{
              inner_block: fn _assigns, _context ->
                ~H"""
                <span>Badge</span>
                """
              end
            }
          ]
        )

      assert html =~ "border border-indigo-400"
    end

    test "renders dot indicator when show_dot is true" do
      assigns = %{}

      html =
        render_component(&Badge.badge/1,
          show_dot: true,
          variant: :success,
          inner_block: [
            %{
              inner_block: fn _assigns, _context ->
                ~H"""
                <span>Badge</span>
                """
              end
            }
          ]
        )

      assert html =~ "bg-green-400"
      assert html =~ "rounded-full"
    end

    test "renders icon when provided" do
      assigns = %{}

      html =
        render_component(&Badge.badge/1,
          icon: "hero-star",
          variant: :primary,
          inner_block: [
            %{
              inner_block: fn _assigns, _context ->
                ~H"""
                <span>Badge</span>
                """
              end
            }
          ]
        )

      assert html =~ "hero-star"
      assert html =~ "text-indigo-400"
    end

    test "applies dark mode classes" do
      assigns = %{}

      html =
        render_component(&Badge.badge/1,
          variant: :default,
          inner_block: [
            %{
              inner_block: fn _assigns, _context ->
                ~H"""
                <span>Badge</span>
                """
              end
            }
          ]
        )

      assert html =~ "dark:bg-zinc-800"
      assert html =~ "dark:text-zinc-300"
    end

    test "applies custom classes via class attribute" do
      assigns = %{}

      html =
        render_component(&Badge.badge/1,
          class: "custom-class",
          inner_block: [
            %{
              inner_block: fn _assigns, _context ->
                ~H"""
                <span>Badge</span>
                """
              end
            }
          ]
        )

      assert html =~ "custom-class"
    end
  end
end
