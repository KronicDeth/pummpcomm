defmodule Decocare.History.ChangeTimeDisplay do
  defdelegate decode(body, pump_options), to: Decocare.History.StandardEvent
end
