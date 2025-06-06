defmodule AnomaApps.MetaMask.Initialize do
  @moduledoc """
  I initialize a User with an arbitrary amount of Spacebucks.
  """

  alias AnomaApps.Client
  alias AnomaApps.Spacebucks.Helpers
  alias AnomaApps.Shared.User

  @doc """
  I initialize some Spacebucks for an arbitrary user.
  """
  @spec initialize :: :ok
  def initialize do
    user = User.new()

    {:ok, resource_logic} = Helpers.resource_logic()

    # read the Mint.nockma code
    {:ok, mint_nockma} = File.read("#{:code.priv_dir(:anoma_apps)}/juvix/.compiled/SpacebucksMetaMask/Mint.nockma")

    # Fetch the latest root from the Anoma controller.
    latest_root = Client.latest_root()

    # create the list of inputs for the Mint.juvix function.
    public_inputs = [
      %{noun: Base.encode64(resource_logic)},
      %{raw: Base.encode64(user.public_key)},
      %{raw: Base.encode64(user.signing_key)},
      %{raw: Base.encode64(latest_root)}
    ]

    {:ok, transaction, _hints} = Client.prove(mint_nockma, public_inputs, [], hints: true)

    # submit the transaction
    {:ok, :added} = Client.submit_transaction(transaction)

    # wait for the next block
    _height = Client.wait_for_next_block()

    resources = Client.list_resources()

    {user, resources}
  end
end
