# Lume UI

Lume is a simple UI component library for Phoenix LiveView applications. It provides a set of ready-to-use components for your Phoenix LiveView applications.

I got fed-up of reinventing the wheel every time I started a new project, and I don't want to always rely on paid UI libraries, so I decided to extract some of the components that I have created from my previous projects into a library.

I also wanted to fit into 'Vanilla LiveView', and use the existing CoreComponents interface. So one of the primary goals of Lume is to be lightweight, easy to use, customize, and extend.

It is still in the early stages of development and currently only provides a handful of components, but I hope to add many more over time.

Please take a look at [lume_example](https://github.com/abradburne/lume_example) for an example how to use the components to create an application using a sidebar navigation menu.

## Features

- Modern, clean design with dark mode support
- Built for Phoenix LiveView
- Simple navigation layout
- Responsive layouts
- Customizable with Tailwind CSS

## Components

### Avatar
A component for displaying user avatars, including fallback options for when an image is not available.

### Breadcrumbs
A component for displaying navigation breadcrumbs with customizable separators and sizes. Ideal for showing the user's current location in hierarchical navigation structures.

### Badge
A component for displaying small notifications or status indicators, often used for alerts or counts.

### DropdownMenu
A flexible dropdown menu component that supports various triggers and menu items, including icons and variants.

### Navbar
A navigation bar component that can include links and other interactive elements for site navigation.

### Separator
A component used to visually separate content, typically used in lists or menus.

### Sidebar
A component for creating a sidebar navigation menu, which can contain links and other interactive elements.

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

Lume has its' own CoreComponents module, adding dark mode support and other tweaks to fit in with the Lume design and functionality. We will keep CoreComponents up to date with any changes made in Phoenix's CoreComponents module.

Delete the existing `CoreComponents` module in your app, `lib/my_app/core_components.ex` and replace it with the Lume components in the html_helpers setup as shown below, along with the Lume components module:

```elixir
defmodule MyAppWeb do
  # ...

  defp html_helpers do
    quote do
      use Lume  # This imports all Lume components

      # Replace existing Core UI components with Lume equivalents
      import Lume.CoreComponents

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

- `<.avatar>` - A versatile avatar component with image support and fallback initials
- `<.badge>` - A flexible badge component for status indicators and labels
- `<.dropdown_menu>` - A flexible dropdown menu component
- `<.navbar>` - A top navigation bar
- `<.separator>` - A simple separator component
- `<.sidebar>` - A responsive sidebar with navigation
- More components coming soon...

## Examples

### Sidebar Component

The sidebar component is a responsive sidebar navigation menu that supports custom branding and navigation items:

```heex
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

### Dropdown Menu

The DropdownMenu component allows you to create flexible dropdown menus with various triggers and menu items.

#### Basic Usage

```elixir
<.dropdown_menu id="user-menu">
  <:trigger>
    <button type="button" class="text-sm">Options</button>
  </:trigger>
  <.menu_item>
    <.link navigate={~p"/profile"} class="w-full">Profile</.link>
  </.menu_item>
  <.menu_item>
    <.link patch={~p"/settings"} class="w-full">Settings</.link>
  </.menu_item>
  <.menu_item variant={:error}>
    <button type="button" class="w-full" phx-click="logout">Sign out</button>
  </.menu_item>
</.dropdown_menu>
```

#### With Icons

You can also add icons to your menu items:

```elixir
<.dropdown_menu id="icon-menu">
  <:trigger>
    <button type="button" class="text-sm">Menu</button>
  </:trigger>

  <.menu_item icon="hero-user">
    <.link navigate={~p"/profile"} class="w-full">Profile</.link>
  </.menu_item>

  <.menu_item icon="hero-cog-6-tooth">
    <.link navigate={~p"/settings"} class="w-full">Settings</.link>
  </.menu_item>

  <.separator />

  <.menu_item variant={:error} icon="hero-arrow-right-on-rectangle">
    <button type="button" class="w-full text-left" href={~p"/users/log_out"} method="delete">Sign out</button>
  </.menu_item>
</.dropdown_menu>
```

#### Custom Alignment

You can customize the alignment of the dropdown menu:

```elixir
<.dropdown_menu id="right-aligned-menu" align={:right}>
  <:trigger>
    <button type="button" class="text-sm">Menu</button>
  </:trigger>
  <.menu_item>
    Profile
  </.menu_item>
</.dropdown_menu>
```

#### Size Variants

The DropdownMenu supports different size variants:

```elixir
<.dropdown_menu id="large-menu" size={:lg}>
  <:trigger>
    <button type="button" class="text-sm">Large Menu</button>
  </:trigger>
  <.menu_item>
    Item 1
  </.menu_item>
</.dropdown_menu>
```

#### Disabled Menu Items

You can disable menu items as well:

```elixir
<.dropdown_menu id="disabled-item-menu">
  <:trigger>
    <button type="button" class="text-sm">Menu</button>
  </:trigger>
  <.menu_item disabled={true}>
    Disabled Item
  </.menu_item>
</.dropdown_menu>
```

### Breadcrumb Component

The breadcrumb component is a flexible breadcrumb navigation component that supports custom paths and labels:

```elixir
<.breadcrumbs id="navigation">
  <:crumb navigate={~p"/"}>
    <.icon name="hero-home-mini" class="w-4 h-4 mr-1" /> Home
  </:crumb>
  <:crumb navigate={~p"/items"}>Items</:crumb>
  <:crumb current={true}>Current Item</:crumb>
</.breadcrumbs>
```

The breadcrumbs component is designed to be highly customizable while maintaining accessibility and consistent styling. Each crumb can be a link or plain text, and you can include icons or other content within crumbs.

#### Component Properties

- `id`: Required string identifier for the breadcrumbs component
- `class`: Optional CSS classes to apply to the container
- `separator_icon`: Optional icon name for the separator (default: "hero-chevron-right-mini")
- `size`: Optional size variant ("xs", "sm", "md", "lg", default: "sm")

#### Crumb Slots

Each crumb is defined using the `:crumb` slot and supports:
- `navigate`: Optional path for making the crumb a clickable link
- `current`: Optional boolean to mark the current/active crumb (adds appropriate styling and aria-current)

#### Size Variants

The breadcrumbs component supports four size variants that affect both text and separator icons:
```elixir
<.breadcrumbs id="xs-example" size="xs">
  <:crumb navigate={~p"/"}>Home</:crumb>
  <:crumb>Items</:crumb>
</.breadcrumbs>

<.breadcrumbs id="lg-example" size="lg">
  <:crumb navigate={~p"/"}>Home</:crumb>
  <:crumb>Items</:crumb>
</.breadcrumbs>
```

#### Custom Separators

You can customize the separator icon using any icon from the Hero Icons set:
```elixir
<.breadcrumbs id="custom" separator_icon="hero-chevron-double-right-mini">
  <:crumb navigate={~p"/"}>Home</:crumb>
  <:crumb>Items</:crumb>
</.breadcrumbs>
```

## Copyright and License

Copyright (c) 2025 Alan Bradburne

This library is released under the MIT License.
