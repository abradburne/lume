defmodule Lume.Gettext do
  @moduledoc """
  Default Gettext module for Lume.
  
  Applications using Lume can override this by setting their own Gettext backend
  in their config:

      config :lume,
        gettext_backend: MyApp.Gettext
  """
  use Gettext.Backend, otp_app: :lume
end
