defmodule TimemanagerWeb.UsersController do
  use TimemanagerWeb, :controller
  alias Timemanager.User
  alias Timemanager.User.Users
  action_fallback TimemanagerWeb.FallbackController

  def tokenGeneration(users) do
    token_csrf = Plug.CSRFProtection.get_csrf_token()

    upload = %{
      "id": users.id,
      "exp": DateTime.utc_now()
             |> DateTime.add(5 * 24 * 3600, :second)
             |> DateTime.to_unix(),
      "csrf": token_csrf
    }

    token = Timemanager.Token.generate_and_sign!(upload)

    [token, token_csrf]
  end

  # Fonction pour assainir les données utilisateur
  defp sanitize_user_data(users) do
    %{
      id: users.id,
      username: Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape(users.username)),
      email: Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape(users.email)),
      status: Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape(users.status))
    }
  end

  # GET /allUsers  --  Get all users
  def showAll(conn, _params) do
    users = User.list_users()
    sanitized_users = Enum.map(users, &sanitize_user_data/1)
    render(conn, :index, users: sanitized_users)
  end

  # GET /users/:userID  --  Get user by ID
  def showById(conn, %{"userID" => id}) do
    # Call the function to find the user
    case User.get_users(id) do
      nil ->
      conn
          # Make a 404 status
          |> put_status(:not_found)
          # Create a json message
          |> json(%{error: "User not found"})

      users ->
          sanitized_data = sanitize_user_data(users)
          render(conn, :show, users: sanitized_data)
     end
  end

  # GET /users?email=...&username=... -- Get user by email & username
  def showByEmailAndUsername(conn, %{"email" => email, "username" => username}) do
    # Call the function to find the user
    case User.get_user_by_email_and_username(email, username) do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
        # Create a json message
        |> json(%{error: "User not found"})

      users ->
        sanitized_data = sanitize_user_data(users)
        render(conn, :show, users: sanitized_data)
    end
  end

  # GET /users/:teamID-- Get user by his team
  def showByTeam(conn, %{"team" => team}) do
    # Call the function to find the user
    case User.findUserByTeam(team) do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
        # Create a json message
        |> json(%{error: "User not found"})

      users ->
        sanitized_users = Enum.map(users, &sanitize_user_data/1)
        render(conn, :index, users: sanitized_users)
    end
  end

  # GET -- Connect user by email and mdp
  def showByEmailAndMdp(conn, %{"users" => %{"email" => email, "mdp" => mdp}}) do
    mobile = get_req_header(conn, "y-custom-header")

    # Call the function to find the user
    case User.findUserByEmail(email) do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "User not found"})

      users ->
        mdp_check = users.mdp

        if Bcrypt.verify_pass(mdp, mdp_check) do
          tokenAuth = tokenGeneration(users)
          jwt = Enum.at(tokenAuth, 0)
          csrf = Enum.at(tokenAuth, 1)

          if mobile === ["true"] do
            conn
            |> put_status(:ok)
            |> render(:showJwtToken, users: sanitize_user_data(users), token: csrf, jwt_token: jwt)
          else
            conn
            |> put_resp_cookie("jwt", jwt, http_only: true, same_site: "Lax")
            |> put_status(:ok)
            |> render(:showJwt, users: sanitize_user_data(users), token: csrf)

          end
        else
          conn
          # Make a 401 status
          |> put_status(:unauthorized)
            # Create a json message
          |> json(%{error: "invalid password"})
        end
    end
  end

  def logout(conn, _params) do
    IO.inspect("logout")
    conn
      |> delete_resp_cookie("jwt")
      |> put_status(:ok)
      |> json(%{ok: "logout"})
  end

  # POST /users -- Create users
  def create(conn, %{"users" => users_params}) do
    # Call the function create_users
    username = users_params["username"]
    email = users_params["email"]
    status = users_params["status"]
    mdp = users_params["mdp"]

    if mdp != nil and String.trim(mdp) != "" do
      hash_mdp = Bcrypt.hash_pwd_salt(mdp)
      case User.create_users(username, email, status, hash_mdp) do
        {:ok , %Users{} = users } ->
          conn
            |> put_status(:created)
            |> put_resp_header("location", ~p"/api/users/#{users.id}")
            |> render(:show, users: sanitize_user_data(users))

        {:error, changeset} ->
          # Retrieves changeset error messages and map format
          errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)

          conn
            # Make a 400 status
            |> put_status(:bad_request)
            # Create a json message
            |> json(%{error: errors})
      end
    else
      conn
      # Make a 400 status
      |> put_status(:bad_request)
        # Create a json message
      |> json(%{error: "password empty"})
    end
  end

  # PUT /users/:userID -- Modify users
  def update(conn, %{"userID" => id, "users" => users_params}) do
    # Call the function to find the user
    case User.get_users(id) do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
        # Create a json message
        |> json(%{error: "User not found"})

      users ->
        # Call the function update_users
        mdp = Map.get(users_params, "mdp")

        if mdp do
          if mdp != nil and String.trim(mdp) != "" do
            hash_mdp = Bcrypt.hash_pwd_salt(mdp)
            params = Map.put(users_params, "mdp", hash_mdp)

            case User.update_users(users, params) do
              {:ok , %Users{} = users } ->
                conn
                |> put_resp_header("location", ~p"/api/users/#{users.id}")
                |> json(sanitize_user_data(users))
                send_resp(conn, :ok, "Modify successfully")


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
          else
            conn
            # Make a 400 status
            |> put_status(:bad_request)
            # Create a json message
            |> json(%{error: "password empty"})
          end
        else
          case User.update_users(users, users_params) do
            {:ok , %Users{} = users } ->
              conn
              |> put_resp_header("location", ~p"/api/users/#{users.id}")
              |> json(sanitize_user_data(users))
              send_resp(conn, :ok, "Modify successfully")

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
  end

  # DELETE /users/:userID -- DELETE users
  def delete(conn, %{"userID" => id}) do
    # Call the function to find the user
    case User.get_users(id) do
      #If empty or null value
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
        # Create a json message
        |> json(%{error: "User not found"})
      #Else
      users ->
        # Call the function delete_users
        with {:ok, %Users{}} <- User.delete_users(users) do
          send_resp(conn, :ok, "Delete successfully")
        end
    end
  end
end
