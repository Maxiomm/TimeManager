defmodule TimemanagerWeb.Router do
  use TimemanagerWeb, :router

  pipeline :browser do
    plug :fetch_session
    plug :fetch_live_flash
    plug :fetch_flash
    plug :put_root_layout, html: {TimemanagerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  @allow
  ["http://localhost:8080", "http://gotham", "app://gotham", "https://94dd-2001-861-3641-fa00-359f-54df-9136-e7bd.ngrok-free.app"]

  pipeline :api do
    plug :accepts, ["json"]
    plug Corsica, origins:  @allow, allow_headers: ["content-type", "authorization", "y-custom-header", "x-custom-header"]

  end

  pipeline :authenticated do
    plug :accepts, ["json"]
    plug Corsica, origins:  @allow, allow_headers: ["content-type", "authorization", "y-custom-header", "x-custom-header"]
    plug TimemanagerWeb.Plugs.AuthPlug
  end

  pipeline :dg do
    plug :accepts, ["json"]
    plug Corsica, origins:  @allow,allow_headers: ["content-type", "authorization", "y-custom-header", "x-custom-header"]
    plug TimemanagerWeb.Plugs.RolePlug, status: "general manager"
  end

  pipeline :manager do
    plug :accepts, ["json"]
    plug Corsica, origins:  @allow,allow_headers: ["content-type", "authorization", "y-custom-header", "x-custom-header"]
    plug TimemanagerWeb.Plugs.RolePlug, status: "manager"
  end

  pipeline :employee do
    plug :accepts, ["json"]
    plug Corsica, origins:  @allow,allow_headers: ["content-type", "authorization", "y-custom-header", "x-custom-header"]
    plug TimemanagerWeb.Plugs.RolePlug, status: "employee"
  end

  scope "/", TimemanagerWeb do
    pipe_through :browser
    get "/", PageController, :home
  end


  # Other scopes may use custom stacks.
  scope "/api", TimemanagerWeb do
    pipe_through :api

    post "/user/auth", UsersController, :showByEmailAndMdp # get user by his email and his username
    post "/users", UsersController, :create # Create user
    get "/logout", UsersController, :logout

  end


  scope "/api", TimemanagerWeb do
    pipe_through [:api, :authenticated, :employee]
    # Route API for users
    get "/users/:userID", UsersController, :showById  # get user by his ID
    get "/users/logout", UsersController, :logout # delete http only : JWT
    get "/users/:teamID", UsersController, :showByTeam # get user by his team
    put "/users/:userID", UsersController, :update # update user
    delete "/users/:userID", UsersController, :delete # delete user

    # Route API for Working Time
    get "/workingtime/working/:userID", WorkingTimeController, :showByEnd # get workingtime in progress
    get "/workingtime/:userID", WorkingTimeController, :showByStartAndEnd # get all workingtime by the id which links it to a user, its start field and its end field
    get "/workingtime/:userID/:id", WorkingTimeController, :showByIDAndIdUser # get one workingtime by his id and the id which link to a user
    get "/workingtimes/:userID", WorkingTimeController, :showByIdUser # get all workingtimes by their id which link to a user
    post "/workingtime/:userID", WorkingTimeController, :create # create a workingtime with in the url, the id which links it to a user
    put "/workingtime/:userID/:id", WorkingTimeController, :update # update a workingtime
    delete "/workingtime/:userID/:id", WorkingTimeController, :delete # delete a workingtime


    # Route API for categories
    get "/categories/:id", CategoriesController, :showById  # get one categorie by his id
    get "/categories", CategoriesController, :showAll  # get all categories
    post "/categories", CategoriesController, :create # create a categories
    put "/categories/:id", CategoriesController, :update # update a categorie
    delete "/categories/:id", CategoriesController, :delete # delete categorie

    # Route API for clocks
    get "/clocks/:userID", ClocksController, :showByUserId  # get one clock by his id and the id which link to a user
    post "/clocks/:userID", ClocksController, :create # create a clock with in the url, the id which links it to a user

    # Route API for tasks
    get "/tasks", TasksController, :showAll  # get all tasks
    get "/task/:id", TasksController, :showById  # get one task by his id
    get "/tasks/:userID", TasksController, :showTaskByUserID  # get one task by the id which link to a user
    get "/tasks/cat/:categorieID", TasksController, :showTaskByCategoriesID  # get one task by the id which link to a workingtime
    get "/tasks/cat/:userID/:categorieID", TasksController, :showTaskByUserIDAndCategoryID  # get one task by the id which link to a user and to a categorie
    post "/tasks", TasksController, :create # create a task
    put "/tasks/:id", TasksController, :update # update a task
    delete "/tasks/:id", TasksController, :delete # delete task

    get "/team/admin/:admin", TeamsController, :showByAdmin  # get one team by his id
    get "/teamlink/user/:userID", TeamLinkController, :showByUserID  # get all team link by their user id


    pipe_through [:manager]

    # Route API for users
    get "/users", UsersController, :showByEmailAndUsername # get user by his email and his username

    # Route API for teams
    get "/team/:id", TeamsController, :show  # get one team by his id
    get "/team/admin/:admin", TeamsController, :showByAdmin  # get one team by his id
    post "/team", TeamsController, :create # create a team
    put "/team/:id", TeamsController, :update # update a team
    delete "/team/:id", TeamsController, :delete # delete team


    # Route API for teamlink
    get "/teamlinks", TeamLinkController, :index  # get all teams link
    get "/teamlink/:id", TeamLinkController, :show  # get one team link by his id
    get "/teamlink/team/:teamID", TeamLinkController, :showByTeamId # get all team link by their team id
    post "/teamlink", TeamLinkController, :create # create a team
    put "/teamlink/:id", TeamLinkController, :update # update a team link
    delete "/teamlink/:id", TeamLinkController, :delete # delete team link


    # Route API for users
    get "/allUsers",  UsersController, :showAll #get all users

    pipe_through [:dg]
    # Route API for teams
    get "/teams", TeamsController, :index  # get all teams

  end


  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:timemanager, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TimemanagerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
