defmodule SimpleGenServerTimeout do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  # Callbacks

  @impl true
  def init(_) do
    ref = Process.send_after(self(), :timeout, 10_000)
    {:ok, %{ref: ref}}
  end

  @impl true
  def handle_info(:timeout, state) do
    IO.puts("Timeout called #{DateTime.utc_now()}")
    ref = Process.send_after(self(), :timeout, 10_000)
    new_state = Map.put(state, :ref, ref)
    {:noreply, new_state}
  end
end
