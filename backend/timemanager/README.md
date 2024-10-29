# Timemanager

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

# database configuration
* Go to timemanager/config/dev.exs and set the following parameters with data from your postgres and the name you want given to your database


    * username
    * password
    * hostname
    * database

* Run `mix ecto.create`
* Run `mix ecto.migrate` with the following file "[20241008090058_apply_conf_sql_bdd.exs](priv/repo/migrations/20241008090058_apply_conf_sql_bdd.exs)"


# API endpoints


### USER
    GET /api/allUser

    GET /api/users?email=XXX&username=YYY 

    GET /api/users/:userID

    POST /api/users

    PUT /api/users/:userID

    DELETE /api/users/:userID

For the working time and clocks endpoint, the userID corresponds to the id of the user to which they are linked

For the endpoint GET /api/workingtime/:userID?start=XXX&end=YYY
the date must be in the following format in the url : 
 
YYYY-MM-DDTHH:mm:ss+02
### WORKING TIME
    GET /api/workingtime/working/:userID

    GET /api/workingtime/:userID?start=XXX&end=YYY 

    GET /api/workingtime/:userID/:id

    GET /api/workingtimes/:userID

    POST /api/workingtime/:userID

    PUT /api/workingtime/:id

    DELETE /api/workingtime/:id 

### CLOCKS
    GET /api/clocks/:userID 

    POST /api/clocks/:userID

### CATEGORIES
    GET /api/categories/:id

    GET /api/categories

    POST /api/categories

    POST /api/categories

    PUT /api/categories/:id

    DELETE api/categories/:id


### TASKS
    GET /api/tasks

    GET /api/task/:id

    GET /api/tasks/:userID

    GET /api/tasks/work/:workingtimeID

    GET /api/tasks/cat/:categorieID

    GET /api/tasks/work/:userID/:workingtimeID

    GET /api/tasks/cat/:userID/:categorieID

    GET /api/tasks/:userID/:workingtimeID/:categorieID

    POST /api/tasks

    PUT /api/tasks/:id

    DELETE api/tasks/:id

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
