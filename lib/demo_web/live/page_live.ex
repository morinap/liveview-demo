defmodule DemoWeb.PageLive do
  use DemoWeb, :live_view

  def authorized?(user_id, _params, _session),
    do: Demo.Users.has_user_permission?(user_id, "show_stuff")

  @impl true
  def mount(_params, _session, socket) do
    items =
      0..1_000
      |> Enum.map(fn n ->
        item = %Demo.Item{id: n, value: "This is an item name"}
        changeset = Demo.Item.changeset(item)

        {item, changeset}
      end)

    {:ok, assign(socket, items: items)}
  end

  @impl true
  def handle_event("validate", %{"item" => %{"id" => id} = form_values}, socket) do
    id = String.to_integer(id)
    {item, _} = Enum.at(socket.assigns.items, id)
    changeset = Demo.Item.changeset(item, form_values)

    {:noreply,
     assign(socket, items: List.replace_at(socket.assigns.items, id, {item, changeset}))}
  end
end
