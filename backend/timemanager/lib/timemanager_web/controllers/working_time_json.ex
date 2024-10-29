defmodule TimemanagerWeb.WorkingTimeJSON do
  alias Timemanager.Workingtime.WorkingTime

  @doc """
  Renders a list of workingtime.
  """
  def index(%{working_time: working_time}) do
    %{data: for(working_time <- working_time, do: data(working_time))}
  end

  @doc """
  Renders a single working_time.
  """
  def show(%{working_time: working_time}) do
    %{data: data(working_time)}
  end


  defp data(%WorkingTime{} = working_time) do
    %{
      id: working_time.id,
      start: working_time.start,
      end: working_time.end,
      isworking: working_time.isworking,
      user_id: working_time.user_id
    }
  end

  # Ajout d'une clause pour gérer les maps
  defp data(%{id: id, user_id: user_id, start: start, end: end_time}) do
    %{
      id: id,
      user_id: user_id,
      start: start,
      end: end_time
    }
  end
end
