defmodule Decocare.History.Battery do
  defdelegate decode(body, pump_options), to: Decocare.History.StandardEvent
end
