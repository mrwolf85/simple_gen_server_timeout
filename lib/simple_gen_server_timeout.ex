defmodule SimpleGenServerTimeout do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end
  
  def stop_timer() do
    GenServer.cast(__MODULE__, :stop_timer)
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

  @impl true
  def handle_cast(:stop_timer, state) do
    ref = Map.get(state, :ref)
    Process.cancel_timer(ref)
    IO.puts "The timer is canceled"
    new_state = Map.put(state, :ref, nil)
    {:noreply, new_state}
  end
end
