defmodule Demo.ReportServer do
  use GenServer

  def init(_init_arg) do
    Process.send_after(self(), :execute, 10_000)
    {:ok, %{results: nil}}
  end

  def handle_info(:execute, state) do
    # Include some complex report logic here
    results = Enum.map(0..50, fn n -> "Record #{n}: #{:rand.uniform(1000)}" end)

    Phoenix.PubSub.broadcast(:demo_pubsub, "report_results", {:report_results, results})

    # Refresh later
    Process.send_after(self(), :execute, 120_000)

    {:noreply, %{state | results: results}}
  end
end
