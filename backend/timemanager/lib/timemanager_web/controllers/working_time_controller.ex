defmodule TimemanagerWeb.WorkingTimeController do
  use TimemanagerWeb, :controller

  alias Timemanager.Workingtime
  alias Timemanager.Workingtime.WorkingTime

  # Fonction pour assainir les données de `working_time`
  defp sanitize_working_time_data(working_time) do
    %{
      id: working_time.id,
      user_id: working_time.user_id,
      start: Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape(working_time.start)),
      end: Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape(working_time.end)),
      isworking: working_time.isworking
    }
  end

  # GET /workingtime/:userID?start=XXX&end=YYY -- GET workingtime by the id which links it to a user, his start field and his end field
  def showByStartAndEnd(conn, %{"userID" => user_id, "start" => startWorktimer, "end" => endWorktimer}) do
    # Replace spaces in the "start" value with a “+” and the “T” with a space
    start_form = startWorktimer
    |> String.replace(" ", "+")
    |> String.replace("T", " ")

    # Replace spaces in the "end" value with a “+” and the “T” with a space
    end_from = endWorktimer
    |> String.replace(" ", "+")
    |> String.replace("T", " ")

    # Call the function get_workingtime_by_start_end
    case Workingtime.get_workingtime_by_start_end(user_id, start_form, end_from) do
      #If empty or null value
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
        # Create a json message
        |> json(%{error: "Workingtime not found"})

      #Else
      working_time ->
        sanitized_data = Enum.map(working_time, &sanitize_working_time_data/1)
        render(conn, :index, working_time: sanitized_data)
    end
  end

  # GET /workingtime/working/:userID -- GET workingtime by the id which links it to a user and a empty end field
  def showByEnd(conn, %{"userID" => user_id}) do
    # Call the function get_workingtime_by_start_end
    case Workingtime.get_workingtime_by_end(user_id) do
      #If empty or null value
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "Workingtime not found"})

      #Else
      working_time ->
        sanitized_data = sanitize_working_time_data(working_time)
        render(conn, :show, working_time: sanitized_data)
    end
  end

  # GET /workingtime/:userID/:id -- GET workingtime by the id which links it to a user and his id
  def showByIDAndIdUser(conn, %{"userID" => user_id, "id" => id}) do
    # Call the function get_workingtime_by_id_user
    case Workingtime.get_workingtime_by_id_user(user_id, id) do
      #If empty or null value
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
        # Create a json message
        |> json(%{error: "Workingtime not found"})

      #Else
      working_time ->
        sanitized_data = sanitize_working_time_data(working_time)
        render(conn, :show, working_time: sanitized_data)
    end
  end

  # GET /workingtime/:userID -- GET workingtime by the id which links it to a user and his id
  def showByIdUser(conn, %{"userID" => user_id}) do
    # Call the function get_workingtime_by_id_user
    case Workingtime.get_workingtime_by_user(user_id) do
      #If empty or null value
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "Workingtime not found"})

      #Else
      working_time ->
        sanitized_data = Enum.map(working_time, &sanitize_working_time_data/1)
        render(conn, :index, working_time: sanitized_data)
    end
  end

  # POST /workingtime/:userID -- Create a workingtime
  def create(conn, %{"userID" => user_id, "workingtime" => working_time_params}) do

    # Get the values of body request
    start_str = working_time_params["start"]
    end_str = working_time_params["end"]
    isworking = working_time_params["isworking"]

    # Call the function create_working_time
    case Workingtime.create_working_time(user_id, start_str, end_str, isworking) do
      {:ok , %WorkingTime{} = workingtime } ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/workingtime/#{workingtime}")
        |> render(:show, working_time: sanitize_working_time_data(workingtime))

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

  # PUT /workingtime/:userID/:id -- Modify a workingtime
  def update(conn, %{"userID" => userID, "id" => id, "workingtime" => working_time_params}) do
    # Call the function update_working_time
      case Workingtime.get_workingtime_by_id_user(userID,id) do
        #If empty or null value
        nil ->
          conn
          # Make a 404 status
          |> put_status(:not_found)
           # Create a json message
          |> json(%{error: "workingtime not found"})

        working_time ->
          # Call the function update_users
          case Workingtime.update_working_time(working_time, working_time_params) do
            {:ok , %WorkingTime{} = workingtime } ->
              conn
              |> put_resp_header("location", ~p"/api/workingtime/#{workingtime}")
              |> json(sanitize_working_time_data(workingtime))
              send_resp(conn, :ok, "Modify successfully")

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
  end

  # DELETE /workingtime/:userID/:id -- DELETE a workingtime
  def delete(conn, %{"userID" => userID, "id" => id}) do
    # Call the function delete_working_time
    case Workingtime.get_workingtime_by_id_user(userID, id) do
      #If empty or null value
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
         # Create a json message
        |> json(%{error: "workingtime not found"})

      working_time ->
        with {:ok, %WorkingTime{}} <- Workingtime.delete_working_time(working_time) do
          send_resp(conn, :ok, "Delete successfully")
        end
    end
  end
end
