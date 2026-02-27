defmodule LastCrusader.Micropub.Backend do
  @moduledoc """
  Behaviour for git backends used to persist Hugo post files.
  """
  @callback new_file(filename :: String.t(), content :: String.t()) ::
              {:ok, :content_created} | {:ko, atom(), any()}

  @callback update_file(filename :: String.t(), content :: String.t()) ::
              {:ok, :content_updated} | {:ko, atom(), any()}

  @callback get_file(filename :: String.t()) ::
              {:ok, String.t()} | {:ko, atom(), any()}
end
