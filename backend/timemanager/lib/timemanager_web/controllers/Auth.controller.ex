defmodule TimemanagerWeb.Plugs.AuthPlug do
    import Plug.Conn
    import Phoenix.Controller

    use Plug.Builder

    @spec init(any) :: any
    def init(default), do: default


    @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
    def call(conn, _opts) do
      mobile = get_req_header(conn, "y-custom-header")
      tokenList = get_req_header(conn, "authorization")
      token = List.first(tokenList)

      if mobile != [] do
        jwt = get_req_header(conn, "x-custom-header")
        jwt_value = List.first(jwt)

        case jwt_value do
          nil ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "JWT missing or invalid"})
            |> halt()

          _ ->
            checkjwt(conn, jwt_value, token)
            conn
        end
      else
        jwt = conn.cookies["jwt"]
        case jwt do
          nil ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "JWT missing or invalid"})
            |> halt()

          _ ->
            checkjwt(conn, jwt, token)
            conn
          end
      end
    end

#    defp checkjwt(conn, jwt, crsf) do
    defp checkjwt(conn, jwt, crsf) do
      IO.inspect("check jwt")
      IO.inspect(jwt)
      case jwt do
        nil ->
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "JWT missing or invalid"})
          |> halt()

        _ ->
          case Timemanager.Token.verify_and_validate(jwt) do
            {:ok, jwtInfo} ->
              jwt_csrf = Map.get(jwtInfo, "csrf")
              case jwt_csrf do
                ^crsf ->
                  exp = Map.get(jwtInfo, "exp")
                  with {:ok, expirateDate} <- DateTime.from_unix(exp) do
                    {:ok, now} = DateTime.now("Etc/UTC")
                    case DateTime.compare(now, expirateDate) do
                      :gt -> # Token expired
                        conn
                        |> put_status(:unauthorized)
                        |> json(%{error: "Token expired, please reconnect"})
                        |> halt()
                      _ -> # Token valid
                        conn
                    end
                  end
                _ ->
                  conn
                  |> put_status(:unauthorized)
                  |> json(%{error: "Jwt and token don't match"})
                  |> halt()
              end
            {:error, _reason} ->
              conn
              |> put_status(:unauthorized)
              |> json(%{error: "JWT verification failed"})
              |> halt()
          end
      end
    end
end