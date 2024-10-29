defmodule TimemanagerWeb.ClocksJSON do
  alias Timemanager.Clock.Clocks

  @doc """
  Renders a list of clocks.
  """
  def index(%{clocks: clocks}) do
    %{data: for(clocks <- clocks, do: data(clocks))}
  end

  @doc """
  Renders a single clocks.
  """
  def show(%{clocks: clocks}) do
    %{data: data(clocks)}
  end

  # Allow to render several clock
  def showAll(%{clocks: clocks}) do
    %{data: Enum.map(clocks, &data/1)}
  end

  defp data(%Clocks{} = clocks) do
    %{
      time: clocks.time,
      status: clocks.status,
      user_id: clocks.user_id,
    }
  end
end
