defmodule Lume.Components.AvatarTest do
  use ExUnit.Case, async: true
  import Phoenix.LiveViewTest

  alias Lume.Components.Avatar

  describe "avatar/1" do
    test "renders image avatar when image_url is provided" do
      html =
        render_component(&Avatar.avatar/1,
          image_url: "path/to/image.jpg",
          alt: "John Doe",
          fallback: "JD"
        )

      assert html =~ ~s(src="path/to/image.jpg")
      assert html =~ ~s(alt="John Doe")
    end

    test "renders fallback initials when image_url is nil" do
      html =
        render_component(&Avatar.avatar/1,
          image_url: nil,
          alt: "John Doe",
          fallback: "JD"
        )

      assert html =~ "JD"
    end

    test "applies correct size classes" do
      for size <- [:sm, :md, :lg] do
        html =
          render_component(&Avatar.avatar/1,
            alt: "User",
            fallback: "U",
            size: size
          )

        case size do
          :sm -> assert html =~ "h-8 w-8"
          :md -> assert html =~ "h-10 w-10"
          :lg -> assert html =~ "h-12 w-12"
        end
      end
    end

    test "applies shape variants correctly" do
      square_html =
        render_component(&Avatar.avatar/1,
          alt: "User",
          fallback: "U",
          shape: :square
        )

      circle_html =
        render_component(&Avatar.avatar/1,
          alt: "User",
          fallback: "U",
          shape: :circle
        )

      assert square_html =~ "rounded"
      assert circle_html =~ "rounded-full"
    end

    test "renders status dot when show_dot is true" do
      html =
        render_component(&Avatar.avatar/1,
          alt: "User",
          fallback: "U",
          show_dot: true,
          dot_variant: :success
        )

      assert html =~ "absolute"
      assert html =~ "bg-green"
    end

    test "applies custom fallback classes" do
      html =
        render_component(&Avatar.avatar/1,
          alt: "User",
          fallback: "U",
          fallback_class: "bg-indigo-100 text-indigo-600"
        )

      assert html =~ "bg-indigo-100"
      assert html =~ "text-indigo-600"
    end

    test "applies additional classes via class attribute" do
      html =
        render_component(&Avatar.avatar/1,
          alt: "User",
          fallback: "U",
          class: "custom-class"
        )

      assert html =~ "custom-class"
    end
  end
end
