defmodule TimemanagerWeb.CategoriesController do
  use TimemanagerWeb, :controller

  alias Timemanager.Categorie
  alias Timemanager.Categorie.Categories

  action_fallback TimemanagerWeb.FallbackController

  # Fonction pour assainir les données de `categories`
  defp sanitize_category_data(category) do
    %{
      id: category.id,
      title: Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape(category.title)),
      color: Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape(category.color))
    }
  end

  # GET /categories -- GET all categories
  def showAll(conn, _params) do
    categories = Categorie.list_categories()
    sanitized_categories = Enum.map(categories, &sanitize_category_data/1)
    render(conn, :index, categories: sanitized_categories)
  end

  # GET /categories/:id -- GET a category by his id
  def showById(conn, %{"id" => id}) do
    case Categorie.get_categories(id) do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "Category not found"})

      category ->
        sanitized_data = sanitize_category_data(category)
        render(conn, :show, categories: sanitized_data)
    end
  end

  # POST /categories -- Create a category
  def create(conn, %{"categories" => categories_params}) do
    case Categorie.create_categories(categories_params) do
      {:ok , %Categories{} = categories } ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/categories/#{categories}")
        |> render(:show, categories: sanitize_category_data(categories))

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

  # PUT /categories/:id -- Update a category
  def update(conn, %{"id" => id, "categories" => categories_params}) do
    case Categorie.get_categories(id) do
      #If empty or null value
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "Categorie not found"})
      #Else
      categories ->
        # Call the function delete_users
        with {:ok, %Categories{} = categories} <- Categorie.update_categories(categories, categories_params) do
          render(conn, :show, categories: sanitize_category_data(categories))
        end
    end
  end

  # DELETE /categories/:id -- Delete a category
  def delete(conn, %{"id" => id}) do
    case Categorie.get_categories(id) do
      #If empty or null value
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "Categorie not found"})
      #Else
      categories ->
        # Call the function delete_users
        with {:ok, %Categories{}} <- Categorie.delete_categories(categories) do
          send_resp(conn, :ok, "Delete successfully")
        end
    end
  end
end
