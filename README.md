# Lume UI

Lume is a simple UI component library for Phoenix LiveView applications. It provides a set of ready-to-use components for your Phoenix LiveView applications.

I got fed-up of reinventing the wheel every time I started a new project, and I don't want to always rely on paid UI libraries, so I decided to extract some of the components that I have created from my previous projects into a library.

I also wanted to fit into 'Vanilla LiveView', and keep the existing CoreComponents that it provides. So one of the primary
goals of Lume is to be lightweight, easy to use, customize, and extend.

It is still in the early stages of development and currently only provides a handful of components, but I hope to add many more over time.

Please take a look at [lume_example](https://github.com/abradburne/lume_example) for an example how to use the components to create an application using a sidebar navigation menu.

## Features

- Modern, clean design with dark mode support
- Built for Phoenix LiveView
- Simple navigation layout
- Responsive layouts
- Customizable with Tailwind CSS

## Installation

1. Add Lume to your mix.exs dependencies:

```elixir
def deps do
  [
    {:lume, "~> 0.1.0"}
  ]
end
```

2. Run mix deps.get to install:

```bash
mix deps.get
```

## Setup

### 1. Configure Tailwind

Lume components use Tailwind CSS for styling. You need to configure your application's `tailwind.config.js` to include Lume's component paths so they don't get purged by Tailwind:

```javascript
// assets/tailwind.config.js
module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web/**/*.*ex",
    "../lib/*_web/**/*.heex",
    "../deps/lume/**/*.*ex"  // Add this line to include Lume components
  ],
  // ... rest of your config
}
```

### 2. Setup Components

To use Lume components in your Phoenix application, add it to your `html_helpers` function in your web module:

```elixir
defmodule MyAppWeb do
  # ...

  defp html_helpers do
    quote do
      use Lume  # This imports all Lume components

      # ... rest of your html_helpers setup
    end
  end
end
```

### 3. Customizing Sidebar Navigation

Lume provides a simple sidebar navigation system that you can customize by providing your own navigation module. Here's how to set it up:

1. Create a navigation module in your application:

```elixir
defmodule MyAppWeb.Navigation do
  @default_items [
    # Basic navigation item
    %{icon: "hero-home", label: "Dashboard", nav_item: :dashboard, path: "/"},

    # Add a separator between groups
    %{separator: true},

    # Another navigation group
    %{icon: "hero-users", label: "Users", nav_item: :users, path: "/users"},
    %{icon: "hero-cog", label: "Settings", nav_item: :settings, path: "/settings"}
  ]

  def default_items do
    @default_items
  end
end
```

2. In your LiveViews, set the current navigation item:

```elixir
defmodule MyAppWeb.UsersLive do
  use MyAppWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :current_item, :users)
    {:ok, socket}
  end
end
```

You can then pass the navigation items and the current item into the sidebar's `nav_items` component to display the navigation list.

3. Customize the sidebar appearance:

You can use the `brand` and `nav_items` components to add a header and navigation items to the sidebar, for example:

```heex
# Basic sidebar with navigation
<.sidebar>
  <.brand title="My App" logo="/images/logo.svg">
  <.nav_items
    items={MyAppWeb.Navigation.default_items()}
    current_item={@current_item}
  />
</.sidebar>
```

You can also just use the `inner_block` slot to add custom content to the sidebar, for example:
```heex
# Sidebar with custom content
<.sidebar id="admin-sidebar" title="Admin Panel">
  <div class="p-4">
    <h2 class="text-lg font-semibold">Custom Content</h2>
    <p>Add any content here!</p>
  </div>
</.sidebar>
```

The sidebar component supports:
- `id`: Optional unique identifier for the sidebar, defaults to "sidebar"

The `brand` component supports:
- `title`: Optional text to display at the top of the sidebar
- `logo`: Optional path to your logo image

The `nav_items` component supports:
- `current_item`: Atom representing the current navigation item
- `items`: List of navigation items, where each item can be:
  - Regular item: `%{icon: "hero-*", label: "Label", nav_item: :atom, path: "/path"}`
  - Separator: `%{separator: true}` to add a visual divider between groups

By default, the sidebar is 72px wide on desktop. To accommodate it, set the left padding of your main content container to 72px.

## Usage

Lume provides several components out of the box:

- `<.sidebar>` - A responsive sidebar with navigation
- `<.navbar>` - A top navigation bar
- `<.avatar>` - A versatile avatar component with image support and fallback initials
- `<.badge>` - A flexible badge component for status indicators and labels
- More components coming soon...

Example usage in a Phoenix LiveView `app.html.heex` layout template:

```heex
<.sidebar>
  <.brand title="My App" logo="/images/logo.svg" />
  <.nav_items
    items={MyAppWeb.Navigation.default_items()}
    current_item={:dashboard}
  />
</.sidebar>
<main class="flex flex-1 flex-col lg:min-w-0 lg:pl-72">
  <.navbar>
    Dashboard
    <:right_content>
      <.avatar
        alt="John Doe"
        fallback="JD"
        image_url="/images/john.jpg"
      />
    </:right_content>
  </.navbar>
</main>
```

### Navbar Component

The navbar component is a flexible top navigation bar that supports responsive design and custom right-side content:

```heex
# Basic navbar with heading
<.navbar>
  Dashboard
  <:right_content>
    <button type="button" class="text-gray-400 hover:text-gray-500">
      <.icon name="hero-bell" class="h-6 w-6" />
    </button>
  </:right_content>
</.navbar>
```

By default, the navbar will show a mobile menu toggle (aka 'hamburger menu') on mobile (or when the screen is too narrow),
but you can disable it by setting `menu_toggle` to `false`:

```heex
<.navbar menu_toggle={false}>
  Dashboard
  <:right_content>
    <button type="button" class="text-gray-400 hover:text-gray-500">
      <.icon name="hero-bell" class="h-6 w-6" />
    </button>
  </:right_content>
</.navbar>
```

### Avatar Component

The avatar component supports images with fallback initials, multiple sizes, and status indicators:

```heex
# Basic avatar with image
<.avatar
  alt="John Doe"
  fallback="JD"
  image_url="/images/john.jpg"
/>

# Avatar with status indicator
<.avatar
  alt="Alan B"
  fallback="AB"
  show_dot
  dot_variant={:success}
/>

# Custom size and shape
<.avatar
  alt="User"
  fallback="U"
  size={:lg}
  shape={:square}
/>
```

### Badge Component

The badge component is perfect for status indicators, labels, and counts:

```heex
# Basic badge
<.badge>Default</.badge>

# Status badge with icon
<.badge variant={:success} icon="hero-check-circle">
  Active
</.badge>

# Warning badge with dot
<.badge variant={:warning} show_dot>
  Pending
</.badge>

# Custom styled badge
<.badge
  variant={:primary}
  size={:lg}
  shape={:flat}
  bordered
>
  Featured
</.badge>
```


## Copyright and License

Copyright (c) 2024 Alan Bradburne

This library is released under the MIT License. See the
[LICENSE.md](./LICENSE.md) file.
