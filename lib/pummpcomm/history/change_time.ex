defmodule Pummpcomm.History.ChangeTime do
  defdelegate decode(body, pump_options), to: Pummpcomm.History.StandardEvent
end
