defmodule WebAppWeb.PageLive do
  use WebAppWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    case Enum.random([0, 1, 2]) do
      1 ->
        Process.sleep(250)

      2 ->
        Process.sleep(500)

      val ->
        Process.sleep(1_000 / val)
    end

    {:ok, assign(socket, query: "", results: %{})}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    case Enum.random([0, 1, 2]) do
      1 ->
        Process.sleep(250)

      2 ->
        Process.sleep(500)

      val ->
        Process.sleep(1_000 / val)
    end

    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not WebAppWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end
