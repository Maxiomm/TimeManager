defmodule TimemanagerWeb.CorsController do
  use TimemanagerWeb, :controller

  def options(conn, _params) do
    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> put_resp_header("access-control-allow-methods", "GET, POST, OPTIONS, PUT, DELETE")
    |> put_resp_header("access-control-allow-headers", "Authorization, Content-Type")
    |> send_resp(204, "")
  end
end