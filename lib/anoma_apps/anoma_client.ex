defmodule AnomaApps.Client do
  @moduledoc """
  I define an interface to communicate with an Anoma controller.
  """
  use AnomaApps

  @doc """
  I fetch the latest root from the Anoma controller.
  """
  @spec latest_root() :: jammed_noun()
  def latest_root do
    Req.get!("#{controller_path()}/indexer/root")
    |> Map.get(:body)
    |> Map.get("root")
    |> Base.decode64!()
  end

  @doc """
  I submit a transaction to the controller.
  """
  @spec submit_transaction(nockma()) :: {:ok, :added} | {:error, term()}
  def submit_transaction(transaction) do
    payload = %{transaction: transaction, transaction_type: "transparent_resource", wrap: false}

    case Req.post!("#{controller_path()}/mempool/add", json: payload) do
      %{body: %{"message" => "transaction added"}} ->
        {:ok, :added}

      %{body: body} ->
        {:error, body}
    end
  end

  @doc """
  I run a nockma program with the given inputs on the controller and return the
  result.
  """
  @type input :: %{raw: binary()} | %{noun: jammed_noun()}
  @spec prove(nockma(), [input()], [input()], Keyword.t()) ::
          {:ok, jammed_noun, [String.t()]} | {:error, :failed_to_prove, [String.t()]}
  def prove(nockma, public_inputs, private_inputs \\ [], opts \\ []) do
    payload = %{
      program: Base.encode64(nockma),
      public_inputs: public_inputs,
      private_inputs: private_inputs
    }

    print_hints? = Keyword.get(opts, :hints, false)

    case Req.post!("#{controller_path()}/nock/prove", json: payload) do
      %{body: %{"io" => hints, "result" => "error"}} ->
        if print_hints?, do: Enum.each(hints, &IO.puts("hint: #{&1}"))
        {:error, :failed_to_prove, hints}

      %{body: %{"io" => hints, "result" => proved}} ->
        if print_hints?, do: Enum.each(hints, &IO.puts("hint: #{&1}"))
        {:ok, proved, hints}
    end
  end

  @doc """
  I list all the unspent resources on the controller.
  """
  @spec list_resources :: [jammed_noun()]
  def list_resources do
    Req.get!("#{controller_path()}/indexer/unspent-resources")
    |> Map.get(:body)
    |> Map.get("unspent_resources")
    |> Enum.map(&Base.decode64!/1)
  end

  @doc """
  I wait for the next block to be minted.
  """
  @spec latest_block :: map()
  def latest_block do
    Req.get!("#{controller_path()}/indexer/latest-block")
    |> Map.get(:body)
    |> Map.get("block")
  end

  @doc """
  I naively wait for the next block to be minted.
  """
  @spec wait_for_next_block() :: number()
  @spec wait_for_next_block(number()) :: number()
  def wait_for_next_block do
    %{"height" => height} = latest_block()
    wait_for_next_block(height)
  end

  defp wait_for_next_block(current) do
    %{"height" => height} = latest_block()

    if height == current do
      Process.sleep(1000)
      wait_for_next_block(current)
    else
      height
    end
  end

  ############################################################
  #                           Helpers                        #
  ############################################################

  # I return the endpoint for the anoma controller
  @spec controller_path :: String.t()
  defp controller_path do
    Application.get_env(:anoma_apps, :host)
  end
end
