# Changelog

All notable changes to this project will be documented in this file.

## Unreleased

## 0.3.0 - 2025-03-01

### Added
- Added `bottom_content` slot to sidebar component for content that should appear at the bottom of the sidebar
- Added `class` attribute to sidebar's brand component for additional styling flexibility
- Added support for `navigate`, `href`, and `method` attributes in sidebar navigation items
- Added `hidden` type to input component in core_components
- Moved button component from core_components to its own module with enhanced features

### Changed
- Updated sidebar component to use self-closing brand tags
- Improved sidebar layout with better flex structure for bottom content positioning
- Removed `path` attribute from sidebar navigation items - use `navigate` or `href` instead
- Fixed some documentation issues

## 0.2.2 - 2025-02-07

- Fix GetText issues
- Added ComponentBase for any shared functions
- Added `desktop_hidden` to sidebar to allow for mobile-only sidebar

## 0.2.1 - 2025-02-06

- Fix Sidebar transition on mobile

## 0.2.0 - 2025-02-06

- Dropdown menu component
- Breadcrumb component
- Move CoreComponents to Lume (with dark mode support)

## 0.1.0 - 2024-12-21

- Initial release
- Basic sidebar, navbar, avatar, and badge components
