defmodule OtelExampleWeb.PageController do
  use OtelExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
