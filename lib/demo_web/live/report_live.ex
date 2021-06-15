defmodule DemoWeb.ReportLive do
  use DemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(:demo_pubsub, "report_results")

    {:ok, _pid} = GenServer.start_link(Demo.ReportServer, nil)

    {:ok, assign(socket, :results, nil)}
  end

  @impl true
  def handle_info({:report_results, results}, socket) do
    {:noreply, assign(socket, :results, results)}
  end
end
