defmodule AnomaApps.MetaMask.Helpers do
  @moduledoc """
  I define a few helper functions for shared behavior between the functions.
  """
  use AnomaApps

  alias AnomaApps.Client

  @doc """
  I return the proved resource logic jammed noun.
  """
  @spec resource_logic :: {:ok, jammed_noun()} | {:error, :failed_to_prove}
  def resource_logic do
    nockma = File.read!("#{:code.priv_dir(:anoma_apps)}/juvix/.compiled/SpacebucksMetaMask/Logic.nockma")

    case Client.prove(nockma, [], []) do
      {:ok, compiled_logic, _hints} ->
        {:ok, Base.decode64!(compiled_logic)}

      _ ->
        {:error, :failed_to_prove}
    end
  end
end
