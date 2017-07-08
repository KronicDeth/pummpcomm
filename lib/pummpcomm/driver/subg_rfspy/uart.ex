defmodule Pummpcomm.Driver.SubgRfspy.UART do
  use GenServer
  alias Pummpcomm.Driver.SerialFraming

  def start_link do
    device = System.get_env("SUBG_RFSPY_DEVICE") || Keyword.get(Application.get_env(:pummpcomm, Pummpcomm.Driver.SubgRfspy.UART), :device)
    {:ok, serial_pid} = Nerves.UART.start_link
    :ok = Nerves.UART.open(serial_pid, device, speed: 19200, active: false)
    :ok = Nerves.UART.configure(serial_pid, framing: {SerialFraming, separator: <<0x00>>})
    :ok = Nerves.UART.flush(serial_pid)

    result = GenServer.start_link(__MODULE__, serial_pid, name: __MODULE__)
  end

  def write(data, timeout_ms) do
    GenServer.call(__MODULE__, {:write, data, timeout_ms}, genserver_timeout(timeout_ms))
  end

  def read(timeout_ms) do
    GenServer.call(__MODULE__, {:read, timeout_ms}, genserver_timeout(timeout_ms))
  end

  def handle_call({:write, data, timeout_ms}, _from, serial_pid) do
    {:reply, write_fully(data, timeout_ms, serial_pid), serial_pid}
  end

  def handle_call({:read, timeout_ms}, _from, serial_pid) do
    {:reply, Nerves.UART.read(serial_pid, timeout_ms + 1000), serial_pid}
  end

  defp write_fully(data, timeout_ms, serial_pid) do
    case Nerves.UART.write(serial_pid, data, timeout_ms) do
      :ok -> Nerves.UART.flush(serial_pid, :receive)
      err -> err
    end
  end

  defp genserver_timeout(timeout_ms) do
    timeout_ms + 2000
  end
end