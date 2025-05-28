defmodule AnomaApps do
  @moduledoc """
  I am the root module of the Anoma Apps repository.

  I do nothing besides defining shared types to be used across all applications.
  """
  defmacro __using__(_opts) do
    quote do
      @typedoc """
      A jammed noun is a binary that is the result of jamming a Nock term.

      E.g., Noun.Jam.jam(some_value)
      """
      @type jammed_noun :: binary()

      @typedoc """
      Nockma is a binary that represents the contents of a compiled Juvix file.
      """
      @type nockma :: binary()
    end
  end
end
