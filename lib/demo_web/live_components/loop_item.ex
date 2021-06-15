defmodule DemoWeb.LiveComponents.LoopItem do
  use Phoenix.LiveComponent
  use Phoenix.HTML

  def render(assigns) do
    ~L"""
      <%= form_obj = form_for(assigns.changeset, "#", phx_change: "validate") %>
        <%= hidden_input(form_obj, :id) %>
        <label>Item <%= assigns.item.id %><%= text_input(form_obj, :value, phx_debounce: 500)%></label>
      </form>
    """
  end
end
