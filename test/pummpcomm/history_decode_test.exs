defmodule Pummpcomm.HistoryTest do
  use ExUnit.Case

  alias Pummpcomm.Crc.Crc16
  alias Pummpcomm.PumpModel

  doctest Pummpcomm.History

  test "It can reconstruct a binary page after decoding it - 1" do
    {:ok, history_page} = Base.decode16("0B6800008034AD110AD90183346D113F1B0183346D118562505BD90685140D11005006234B2400000007001D5A5C11C8C30470F50402091436131470DB14011D1D000785340D110B65DD218E34AD1133360C9A144D110016010C9A144D115B002FA2140D110F5006234B001900000000195A5C11742204C8E004701214022614363014011919002FA2340D11336003AC144D1100160103AC144D11333600AD144D1100160100AD144D1133362E84154D110016012E84154D110B65C0378F35AD1133360996154D110016010996154D113320329C154D11001601329C154D11330A2FA0154D110016012FA0154D11330019A8154D1100160119A8154D1133001D85164D110016011D85164D113348269D164D11001601269D164D1133701CA5164D110016011CA5164D1133700A85174D110016010A85174D1133343096174D110016013096174D1133623BA9174D110016013BA9174D1107000007782D116D2D110500AF85D9020000077803E434039430008203943002F05200A41200000009070200005074324C1D02332C3684004E110016013684004E11330C138D004E11001601138D004E11333419A2004E1100160119A2004E11332C37B0004E1100160137B0004E110A6B2B82210E115B6B3082010E1100500D234B040000000000045A5C08641014742E14010404003082210E11333E1685014E110016011685014E11332C0386014E110016010386014E11334C158E014E11001601158E014E11336C0195014E110016010195014E11332C13A1014E1100160113A1014E11330018AE014E1100160118AE014E1133000CBA014E110016010CBA014E11332C378C024E11001601378C024E113310368D024E11001601368D024E11332C17AA024E1100160117AA024E113322148A034E11001601148A034E1133001A9A034E110016011A9A034E1133002AB0034E110016012AB0034E1133001386044E110016011386044E110A731D8B246E113F0E1D8B646E118595515B73268B040E1100500D234B070000000100065A5C0810BF0464CD1401060600268B240E113388078D044E11001601078D044E1133003A91044E110016013A91044E11335E2A9A044E110016012A9A044E11332203A5044E1100160103A5044E11330638B4044E1100160138B4044E1133221DB5044E110016011DB5044E11332C3283054E110016013283054E1133082588054E110016012588054E113300138D054E11001601138D054E1133001299054E110016011299054E11333814B5054E1100160114B5054E11332C35B5054E1100160135B5054E1133101088064E110016011088064E11332C0A92064E110016010A92064E11332C37A5064E1100160137A5064E1133000BBA064E110016010BBA064E113300318B074E11001601318B074E110000000000B4CD")
    decoded_events = Pummpcomm.History.decode(history_page, elem(PumpModel.model_number("722"), 1)) |> elem(1)
    page_from_decoded_events = decoded_events |> Enum.map_join(fn (event) -> elem(event, 1)[:raw] end)
    page_from_decoded_events = page_from_decoded_events <> <<Crc16.crc_16(page_from_decoded_events)::16>>
    assert history_page == page_from_decoded_events
  end

  test "It can reconstruct a binary page after decoding it - 2" do
    {:ok, history_page} = Base.decode16("33002F98074E110016012F98074E11332C35A0074E1100160135A0074E11330035AC074E1100160135AC074E11334C35B4074E1100160135B4074E11332C018E084E11001601018E084E1133441993084E110016011993084E11335E329D084E11001601329D084E11337E2AA8084E110016012AA8084E11337E2BA8084E110016012BA8084E11332C00BA084E1100160100BA084E115B000EBB080E111E5009234B002100000000215A5C0818211410DF14012121000EBB280E110B70000D9F29AE114F000CA1090E112151008C37281E003C14001E3C25853E2051008C37281E003C14001E3C25853E5B002BA40D0E111E5007234B002A000000002A5A5C085814142C1E14012A2A002BA42D0E111E0021B80D0E111F00308E0E0E114F002B990E0E112051008C37281E003C14001E3C25853E2151008C37281E003C14001E3C25853E0B6D003B812FAE110A1E27822F6E913F232782CF6E118098445B1E3A820F0E11005107234B380000001B001D5A5C0BA85C04586A142C7414011D1D003B822F0E11338C20870F4E1100160120870F4E110B68001F9930AE110ACC299C306E113F19299C906E118098445BCC2B9C100E11005006234B200000001B00055A5C0E745804A8B20458C0142CCA14010505002B9C300E11338C06A1104E1100160106A1104E110B65CC01A930AE115B0013AF100E11145006234B002100000000215A5C11141B04746B04A8C50458D3142CDD140121210013AF300E11333C07B4104E1100160107B4104E1133363B84114E110016013B84114E1133363B98114E110016013B98114E11333601AA114E1100160101AA114E1133360EBA114E110016010EBA114E11338C3884124E110016013884124E11333E349C124E11001601349C124E11338C3984134E110016013984134E110B658C138F33AE110A682F8F330E110B6900009C35AE110A3F299D356E113F07299DF56E118562505B3F2A9E150E110D5006234BFC15F0000000115A5C0B842214143614748614011111002A9E350E11330005B6160E1100160105B6160E110A2D3681376E113F053681B76E118562501E000DA4170E110B658F1FAD37AE11070000074E2E116D2E110510842D1E070000074E04AA4002A424005D02A42401F44A00B01A0000000804040000006439CCC5040A721D9E206F113F0E1D9E406F118595511F00319E000F115B7223A4000F110F500D234B060B000003000E5A5C0844BA0484DC14010E0E0023A4200F110B65903B8121AF110B65C0018122AF110B65C83B8123AF110B65D3018124AF110B65E83B8125AF110B65E3018126AF110B65CF3B8127AF110B65BC018128AF110ACA2182286F113F192182486F118098445BCA2D82080F11005009234B200000000000205A5C0538C414012020002D82280F1100000000000000B233")
    decoded_events = Pummpcomm.History.decode(history_page, elem(PumpModel.model_number("722"), 1)) |> elem(1)
    page_from_decoded_events = decoded_events |> Enum.map_join(fn (event) -> elem(event, 1)[:raw] end)
    page_from_decoded_events = page_from_decoded_events <> <<Crc16.crc_16(page_from_decoded_events)::16>>
    assert history_page == page_from_decoded_events
  end

  test "It can reconstruct a binary page after decoding it - 3" do
    {:ok, history_page} = Base.decode16("332C37B7084D1100160137B7084D11332C308B094D11001601308B094D11332C39A0094D1100160139A0094D11332C04A1094D1100160104A1094D11333609870A4D1100160109870A4D11337836900A4D1100160136900A4D1133363A980A4D110016013A980A4D11330031A80A4D1100160131A80A4D11330032B40A4D1100160132B40A4D11330025880B4D1100160125880B4D115B000C9D0B0D110F5007234B001500000000155A5C0858A90430D104011515000C9D2B0D11333632A40B4D1100160132A40B4D11333633B40B4D1100160133B40B4D1133521AB90B4D110016011AB90B4D1133362F840C4D110016012F840C4D1133721F890C4D110016011F890C4D110B659F228E2CAD11338C2C8E0C4D110016012C8E0C4D115B00088F0C0D11145007234B001C000000001C5A5C0E242D0430370458D70430FF04011C1C00088F2C0D11333610920C4D1100160110920C4D1133442C980C4D110016012C980C4D113384029E0C4D11001601029E0C4D11334A08A60C4D1100160108A60C4D11338C00AD0C4D1100160100AD0C4D11333634840D4D1100160134840D4D11330022880D4D1100160122880D4D110B65A3388F2DAD1133003B940D4D110016013B940D4D1133003AAC0D4D110016013AAC0D4D1133002EB80D4D110016012EB80D4D1133002E880E4D110016012E880E4D1133000C960E4D110016010C960E4D11330025A10E4D1100160125A10E4D1133000DB20E4D110016010DB20E4D11333600B90E4D1100160100B90E4D11330039850F4D1100160139850F4D1133363A8C0F4D110016013A8C0F4D11338C33940F4D1100160133940F4D115B0005A70F0D110A5007234B000E000000000E5A5C1170D10424F90430031458A31430CB140B658E2DA72FAD11010E0E0005A72F0D11333631B00F4D1100160131B00F4D115B000280100D11145007234B001C000000001C5A5C14021404361E0470E604240E1430181458B814011C1C000280300D1133000685104D110016010685104D1133360B86104D110016010B86104D113320338C104D11001601338C104D1133162390104D110016012390104D1133362595104D110016012595104D1133002A99104D110016012A99104D1133362CA4104D110016012CA4104D115B0005B4100D111E5006234B003200000000325A5C14703404024804365204701A14244214304C140132320006B4300D1133360BB9104D110016010BB9104D113336108E114D11001601108E114D11333632A0114D1100160132A0114D11330034AC114D1100160134AC114D11330033B8114D1100160133B8114D1133002A89124D110016012A89124D11338C2BA0124D110016012BA0124D110B659737A332AD110B6900008033AD110B654A21A233AD91338C16A7130D1100160116A7130D113DEE")
    decoded_events = Pummpcomm.History.decode(history_page, elem(PumpModel.model_number("722"), 1)) |> elem(1)
    page_from_decoded_events = decoded_events |> Enum.map_join(fn (event) -> elem(event, 1)[:raw] end)
    page_from_decoded_events = page_from_decoded_events <> <<Crc16.crc_16(page_from_decoded_events)::16>>
    assert history_page == page_from_decoded_events
  end

  test "It can reconstruct a binary page after decoding it - 4" do
    {:ok,history_page} = Base.decode16("6E368F050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000378F0000006E378F050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000700000000388F0000006E388F0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000021001DE813190F0700000000398F0000006E398F0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000003A8F0000006E3A8F0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000003B8F0000006E3B8F0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000003C8F0000006E3C8F0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000003D8F0000006E3D8F0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000007000000003E8F0000006E3E8F05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000190000C2081F0F190000C10A1F0F07000000003F8F0000006E3F8F05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000190040010A010F0700000000410F0000006E410F05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000190040010A020F0700000000420F0000006E420F05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000190040010A030F0700000000430F0000006E430F05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000190040010A040F1A00722713040F1A01522813040F030000000A4A2A33040F7B00572A13040F0004000300010001552A13040F000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008EB6")
    decoded_events = Pummpcomm.History.decode(history_page, "554") |> elem(1)
    page_from_decoded_events = decoded_events |> Enum.map_join(fn (event) -> elem(event, 1)[:raw] end)
    page_from_decoded_events = page_from_decoded_events <> <<Crc16.crc_16(page_from_decoded_events)::16>>
    assert history_page == page_from_decoded_events
  end
end
