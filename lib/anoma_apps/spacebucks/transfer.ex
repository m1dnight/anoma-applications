defmodule AnomaApps.Spacebucks.Transfer do
  @moduledoc """
  I transfer some Spacebucks from a user to another user.
  """

  alias AnomaApps.Client
  alias AnomaApps.Spacebucks.Helpers
  alias AnomaApps.Spacebucks.Initialize
  alias AnomaApps.Shared.User

  @doc """
  I transfer spacebucks from one user to another.
  """
  @spec transfer :: :ok
  def transfer do
    {sender, resources} = Initialize.initialize()
    receiver = User.new()

    Process.sleep(10_000)
    {:ok, resource_logic} = Helpers.resource_logic()

    # read the Transfer.nockma code
    {:ok, transfer_nockma} =
      File.read("#{:code.priv_dir(:anoma_apps)}/juvix/.compiled/Spacebucks/Transfer.nockma")

    # Fetch the latest root from the Anoma controller.
    latest_root = Client.latest_root()

    # create the list of inputs for the Mint.juvix function.
    public_inputs = [
      %{noun: Base.encode64(resource_logic)},
      %{raw: Base.encode64(sender.public_key)},
      %{raw: Base.encode64(sender.signing_key)},
      %{raw: Base.encode64(receiver.public_key)},
      %{noun: Base.encode64(hd(resources))},
      %{raw: Base.encode64(latest_root)}
    ]

    # create the transactio candidate
    {:ok, transaction, _hints} = Client.prove(transfer_nockma, public_inputs, [], hints: true)

    # submit the transaction candidate
    {:ok, :added} = Client.submit_transaction(transaction)

    # wait for the next block
    _height = Client.wait_for_next_block()

    new_resources = Client.list_resources()
    {sender, receiver, resources, new_resources}
  end

  @doc """
  I try to transfer spacebucks from somebody else, which should fail.
  """
  @spec steal :: :ok
  def steal do
    {sender, resources} = Initialize.initialize()

    Process.sleep(10_000)
    receiver = User.new()

    {:ok, resource_logic} = Helpers.resource_logic()

    # read the Transfer.nockma code
    {:ok, transfer_nockma} =
      File.read("#{:code.priv_dir(:anoma_apps)}/juvix/.compiled/Spacebucks/Transfer.nockma")

    # Fetch the latest root from the Anoma controller.
    latest_root = Client.latest_root()

    # create the list of inputs for the Mint.juvix function.
    public_inputs = [
      %{noun: Base.encode64(resource_logic)},
      %{raw: Base.encode64(receiver.public_key)},
      %{raw: Base.encode64(receiver.signing_key)},
      %{raw: Base.encode64(receiver.public_key)},
      %{noun: Base.encode64(hd(resources))},
      %{raw: Base.encode64(latest_root)}
    ]

    # create the transactio candidate
    {:ok, transaction, _hints} = Client.prove(transfer_nockma, public_inputs, [], hints: true)

    # submit the transaction candidate
    {:ok, :added} = Client.submit_transaction(transaction)

    # wait for the next block
    _height = Client.wait_for_next_block()

    new_resources = Client.list_resources()
    {sender, receiver, resources, new_resources}
  end
end
