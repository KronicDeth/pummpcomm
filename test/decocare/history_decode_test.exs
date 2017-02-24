defmodule Decocare.HistoryTest do
  use ExUnit.Case

  doctest Decocare.History

    # 011D1D000785340D110B65DD218E34AD1133360C9A144D110016010C9A144D115B002FA2140D110F5006234B001900000000195A5C11742204C8E004701214022614363014011919002FA2340D11336003AC144D1100160103AC144D11333600AD144D1100160100AD144D1133362E84154D110016012E84154D110B65C0378F35AD1133360996154D110016010996154D113320329C154D11001601329C154D11330A2FA0154D110016012FA0154D11330019A8154D1100160119A8154D1133001D85164D110016011D85164D113348269D164D11001601269D164D1133701CA5164D110016011CA5164D1133700A85174D110016010A85174D1133343096174D110016013096174D1133623BA9174D110016013BA9174D1107000007782D116D2D110500AF85D9020000077803E434039430008203943002F05200A41200000009070200005074324C1D02332C3684004E110016013684004E11330C138D004E11001601138D004E11333419A2004E1100160119A2004E11332C37B0004E1100160137B0004E110A6B2B82210E115B6B3082010E1100500D234B040000000000045A5C08641014742E14010404003082210E11333E1685014E110016011685014E11332C0386014E110016010386014E11334C158E014E11001601158E014E11336C0195014E110016010195014E11332C13A1014E1100160113A1014E11330018AE014E1100160118AE014E1133000CBA014E110016010CBA014E11332C378C024E11001601378C024E113310368D024E11001601368D024E11332C17AA024E1100160117AA024E113322148A034E11001601148A034E1133001A9A034E110016011A9A034E1133002AB0034E110016012AB0034E1133001386044E110016011386044E110A731D8B246E113F0E1D8B646E118595515B73268B040E1100500D234B070000000100065A5C0810BF0464CD1401060600268B240E113388078D044E11001601078D044E1133003A91044E110016013A91044E11335E2A9A044E110016012A9A044E11332203A5044E1100160103A5044E11330638B4044E1100160138B4044E1133221DB5044E110016011DB5044E11332C3283054E110016013283054E1133082588054E110016012588054E113300138D054E11001601138D054E1133001299054E110016011299054E11333814B5054E1100160114B5054E11332C35B5054E1100160135B5054E1133101088064E110016011088064E11332C0A92064E110016010A92064E11332C37A5064E1100160137A5064E1133000BBA064E110016010BBA064E113300318B074E11001601318B074E110000000000B4CD

  test "Cal BG For PH" do
    {:ok, history_page} = Base.decode16("0AD90183346D91")
    decoded_events = Decocare.History.decode_page(history_page, false)
    assert {:cal_bg_for_ph, %{amount: 473, timestamp: ~N[2017-02-13 20:03:01], raw: ^history_page}} = Enum.at(decoded_events, 0)

    {:ok, history_page} = Base.decode16("0AD90183B46D11")
    decoded_events = Decocare.History.decode_page(history_page, false)
    assert {:cal_bg_for_ph, %{amount: 729, timestamp: ~N[2017-02-13 20:03:01], raw: ^history_page}} = Enum.at(decoded_events, 0)

    {:ok, history_page} = Base.decode16("0AD90183346D11")
    decoded_events = Decocare.History.decode_page(history_page, false)
    assert {:cal_bg_for_ph, %{amount: 217, timestamp: ~N[2017-02-13 20:03:01], raw: ^history_page}} = Enum.at(decoded_events, 0)
  end

  test "Alarm Sensor" do
    {:ok, history_page} = Base.decode16("0B6800008034AD11")
    decoded_events = Decocare.History.decode_page(history_page, false)
    assert {:alarm_sensor, %{alarm_type: "Meter BG Now", timestamp: ~N[2017-02-13 20:00:00], raw: ^history_page}} = Enum.at(decoded_events, 0)
  end

  test "BG Received" do
    {:ok, history_page} = Base.decode16("3F1B0183346D11856250")
    decoded_events = Decocare.History.decode_page(history_page, false)
    assert {:bg_received, %{amount: 217, meter_link_id: "856250", timestamp: ~N[2017-02-13 20:03:01], raw: ^history_page}} = Enum.at(decoded_events, 0)

    {:ok, history_page} = Base.decode16("3F1B0183D46D11856250")
    decoded_events = Decocare.History.decode_page(history_page, false)
    assert {:bg_received, %{amount: 222, meter_link_id: "856250", timestamp: ~N[2017-02-13 20:03:01], raw: ^history_page}} = Enum.at(decoded_events, 0)
  end

  test "Bolus Wizard Estimate" do
    {:ok, history_page} = Base.decode16("5BD90685140D11005006234B2400000007001D5A")
    decoded_events = Decocare.History.decode_page(history_page, false)
    expected_event_info = %{
      bg: 217,
      bg_target_high: 90,
      bg_target_low: 75,
      bolus_estimate: 2.9,
      carbohydrates: 0,
      carb_ratio: 6,
      correction_estimate: 3.6,
      food_estimate: 0.0,
      insulin_sensitivity: 35,
      unabsorbed_insulin_total: 0.7,
      raw: history_page,
      timestamp: ~N[2017-02-13 20:05:06]
    }
    assert {:bolus_wizard_estimate, ^expected_event_info} = Enum.at(decoded_events, 0)
  end

  test "Unabsorbed Insulin" do
    {:ok, history_page} = Base.decode16("5C11C8C30470F50402091436131470DB14")
    decoded_events = Decocare.History.decode_page(history_page, false)
    expected_event_info = %{
      data: [
        %{ age: 195, amount: 5.00 },
        %{ age: 245, amount: 2.80 },
        %{ age: 265, amount: 0.05 },
        %{ age: 275, amount: 1.35 },
        %{ age: 475, amount: 2.80 }
      ],
      raw: history_page
    }
    assert {:unabsorbed_insulin, ^expected_event_info} = Enum.at(decoded_events, 0)
  end
end
