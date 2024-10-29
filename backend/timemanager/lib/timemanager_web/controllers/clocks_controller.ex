defmodule TimemanagerWeb.ClocksController do
  use TimemanagerWeb, :controller

  alias Timemanager.Clock
  alias Timemanager.Clock.Clocks

  action_fallback TimemanagerWeb.FallbackController

  # GET clocks/:userID -- GET clock by the id which links it to a user
  def showByUserId(conn, %{"userID" => user_id}) do
    # Call the function get_clocks_by_id_user
    case Clock.get_clocks_by_id_user(user_id) do
      #If empty or null value
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
        # Create a json message
        |> json(%{error: "Clock not found"})

      clock ->
        render(conn, :showAll, clocks: clock)
    end
  end

  # POST clocks/:userID -- Create clock
  def create(conn, %{"userID" => user_id, "clocks" => clocks_params}) do
    # Get the values of body request
    status = clocks_params["status"]
    time = clocks_params["time"]

    # Call the function create_clocks
    case Clock.create_clocks(status, time, user_id) do
      {:ok , %Clocks{} = clock } ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/clocks/#{clock}")
        |> render(:show, clocks: clock)

      # If errors
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
