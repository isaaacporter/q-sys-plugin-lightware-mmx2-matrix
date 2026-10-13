-- ControlType can be Button, Knob, Indicator or Text
-- ButtonType ( ControlType == Button ) can be Momentary, Toggle or Trigger
-- IndicatorType ( ControlType == Indicator ) can be Led, Meter, Text or Status
-- ControlUnit ( ControlType == Knob ) can be Hz, Float, Integer, Pan, Percent, Position or Seconds
ctrls = {
    -- System Pins
    {
        Name = "online",
        ControlType = "Indicator",
        IndicatorType = "Led",
        PinStyle = "Output",
        Count = 1,
        UserPin = true
    },
    {
        Name = "ip_address",
        ControlType = "Indicator",
        IndicatorType = "Text",
        PinStyle = "Both",
        Count = 1,
        UserPin = true
    },
    {
        Name = "model",
        ControlType = "Indicator",
        IndicatorType = "Text",
        PinStyle = "Output",
        Count = 1,
        UserPin = true
    },
    {
        Name = "serial_number",
        ControlType = "Indicator",
        IndicatorType = "Text",
        PinStyle = "Output",
        Count = 1,
        UserPin = true
    },
    {
        Name = "firmware_version",
        ControlType = "Indicator",
        IndicatorType = "Text",
        PinStyle = "Output",
        Count = 1,
        UserPin = true
    },
    {
        Name = "input_signal",
        ControlType = "Indicator",
        IndicatorType = "Led",
        PinStyle = "Output",
        Count = input_count,
        UserPin = true
    }
}
for i = 1, output_count do
    table.insert(
        ctrls,
        {
            Name = "output_" .. i,
            ControlType = "Text",
            PinStyle = "Both",
            UserPin = true
        }
    )
    table.insert(
        ctrls,
        {
            Name = "video_mute_" .. i,
            ControlType = "Button",
            ButtonType = "Toggle",
            PinStyle = "Both",
            UserPin = true
        }
    )
    for s = 1, input_count do
        table.insert(
            ctrls,
            {
                Name = "input_" .. s .. "-output_" .. i,
                ControlType = "Button",
                ButtonType = "Toggle",
                PinStyle = "Both",
                UserPin = true
            }
        )
    end
end
