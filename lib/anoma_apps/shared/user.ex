defmodule AnomaApps.Shared.User do
  @moduledoc """
  I represent a Spacebucks user.
  """

  alias AnomaApps.Shared.User

  use TypedStruct

  typedstruct do
    field(:public_key, <<_::32>>)
    field(:private_key, <<_::32>>)
    field(:signing_key, <<_::64>>)
  end

  @doc """
  I create a new `User` struct.
  """
  @spec new :: User.t()
  def new do
    private_key = Eddy.generate_key(encoding: :raw)
    public_key = Eddy.get_pubkey(private_key, encoding: :raw)
    signing_key = private_key <> public_key

    %User{public_key: public_key, private_key: private_key, signing_key: signing_key}
  end
end
