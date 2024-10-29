defmodule TimemanagerWeb.TasksController do
  use TimemanagerWeb, :controller

  alias Timemanager.Task
  alias Timemanager.Task.Tasks

  action_fallback TimemanagerWeb.FallbackController

  # Fonction pour assainir les données de `tasks`
  defp sanitize_task_data(task) do
    %{
      id: task.id,
      user_id: task.user_id,
      category_id: task.category_id,
      title: Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape(task.title)),
      start: task.start,
      end: task.end
    }
  end

  # GET /tasks -- GET all tasks
  def showAll(conn, _params) do
    tasks = Task.list_tasks()
    sanitized_tasks = Enum.map(tasks, &sanitize_task_data/1)
    render(conn, :index, tasks: sanitized_tasks)
  end

  # GET /tasks/:id -- GET a task by his id
  def showById(conn, %{"id" => id}) do
    case Task.get_tasks(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Task not found"})

      task ->
        sanitized_data = sanitize_task_data(task)
        render(conn, :show, tasks: sanitized_data)
    end
  end

  # GET /tasks/:userID -- GET a task by the id which links it to a user
  def showTaskByUserID(conn, %{"userID" => user_id}) do
    # Call the function to find the task
    case Task.findTaskByUserID(user_id) do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "Task not found"})

      tasks ->
        sanitized_tasks = Enum.map(tasks, &sanitize_task_data/1)
        render(conn, :index, tasks: sanitized_tasks)
    end
  end


  # GET /tasks/cat/:categorieID -- GET a task by the id which links it to a category
  def showTaskByCategoriesID(conn, %{"categorieID" => categories_id}) do
    # Call the function to find the task
    case Task.findTaskByCategorieID(categories_id) do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "Task not found"})

      tasks ->
        sanitized_tasks = Enum.map(tasks, &sanitize_task_data/1)
        render(conn, :index, tasks: sanitized_tasks)
    end
  end


  # GET /tasks/cat/:userID/:categorieID -- GET a task by the id which links it to a user, the id which links it to a category
  def showTaskByUserIDAndCategoryID(conn, %{"categorieID" => categories_id, "userID" => user_id}) do
    # Call the function to find the task
    case Task.findTaskByUserIDAndCategoriesID(user_id, categories_id) do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "Task not found"})

      tasks ->
        sanitized_tasks = Enum.map(tasks, &sanitize_task_data/1)
        render(conn, :index, tasks: sanitized_tasks)
    end
  end

  # POST /tasks -- Create a task
  def create(conn, %{"tasks" => tasks_params}) do
    case Task.create_tasks(tasks_params) do
      {:ok , %Tasks{} = tasks } ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/workingtime/#{tasks}")
        |> render(:show, tasks: sanitize_task_data(tasks))

      # If error
      {:error, changeset} ->
        # Retrieves changeset error messages and map format
        errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
        conn
        # Make a 400 status
        |> put_status(:bad_request)
          # Create a json message
        |> json(%{error: errors})
    end
  end

  # PUT /tasks/:id -- Update a task
  def update(conn, %{"id" => id, "tasks" => tasks_params}) do
    case Task.get_tasks(id) do
      #If empty or null value
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "Task not found"})
      #Else
      tasks ->
        case Task.update_tasks(tasks, tasks_params) do
          {:ok, %Tasks{} = updated_task} ->
            render(conn, :show, tasks: sanitize_task_data(updated_task))

          {:error, changeset} ->
            errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
            conn
            |> put_status(:bad_request)
            |> json(%{error: errors})
        end
    end
  end

  # DELETE /tasks/:id -- Delete a task
  def delete(conn, %{"id" => id}) do
    case Task.get_tasks(id) do
      #If empty or null value
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "Task not found"})
      #Else
      tasks ->
        # Call the function delete_users
        with {:ok, %Tasks{}} <- Task.delete_tasks(tasks) do
          send_resp(conn, :ok, "Delete successfully")
        end
    end
  end


end
