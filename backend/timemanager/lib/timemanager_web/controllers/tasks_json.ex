defmodule TimemanagerWeb.TasksJSON do
  alias Timemanager.Task.Tasks

  @doc """
  Renders a list of tasks.
  """
  def index(%{tasks: tasks}) do
    %{data: for(tasks <- tasks, do: data(tasks))}
  end

  @doc """
  Renders a single tasks.
  """
  def show(%{tasks: tasks}) do
    %{data: data(tasks)}
  end

  defp data(%Tasks{} = tasks) do
    %{
      id: tasks.id,
      title: tasks.title,
      start: tasks.start,
      end: tasks.end,
      category_id: tasks.category_id,
      user_id: tasks.user_id
    }
  end

  # Ajout d'une clause pour gérer les maps
  defp data(%{id: id, title: title, start: start, end: end_time, category_id: category_id, user_id: user_id}) do
    %{
      id: id,
      title: title,
      start: start,
      end: end_time,
      category_id: category_id,
      user_id: user_id
    }
  end
end
