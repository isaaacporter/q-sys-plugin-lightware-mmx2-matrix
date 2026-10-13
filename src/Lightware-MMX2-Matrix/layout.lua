input_count, output_count = string.match(props["Model"].Value, "MMX2-(%d+)x(%d+)") -- not sure why this doesn't work

if props["Model"].Value == "MMX2-4x1" then
    input_count, output_count = 4, 1
elseif props["Model"].Value == "MMX2-4x3" then
    input_count, output_count = 4, 3
else
    input_count, output_count = 4, 1 -- default
end

local title_size = {224, 32}
local btn_size = {32, 24}
local status_groupbox_size = {title_size[1], 6 * btn_size[2]}
local matrix_groupbox_position = {0, title_size[2] + status_groupbox_size[2] + (0.5 * btn_size[2])}
local matrix_groupbox_size = {
    72 + (output_count * btn_size[1]),
    16 + (3 * btn_size[2]) + (input_count * btn_size[2])
}

graphics = {
    {
        Type = "Header",
        Text = "Lightware Matrix",
        HTextAlign = "Center",
        Color = Colors.lightware_red,
        FontSize = 16,
        Position = {0, 0},
        Size = title_size
    },
    {
        Type = "GroupBox",
        Text = "Status",
        HTextAlign = "Left",
        Fill = Colors.lightware_black,
        CornerRadius = 8,
        StrokeColor = Colors.lightware_red,
        Color = Colors.lightware_red,
        StrokeWidth = 1,
        Position = {0, title_size[2]},
        Size = status_groupbox_size
    },
    {
        Type = "Text",
        Text = "Online:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Bold",
        HTextAlign = "Right",
        Color = Colors.White,
        Position = {0, title_size[2] + (0.5 * btn_size[2])},
        Size = {3 * btn_size[1], btn_size[2]}
    },
    {
        Type = "Text",
        Text = "IP Address:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Bold",
        HTextAlign = "Right",
        Color = Colors.White,
        Position = {0, title_size[2] + (1.5 * btn_size[2])},
        Size = {3 * btn_size[1], btn_size[2]}
    },
    {
        Type = "Text",
        Text = "Model:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Bold",
        HTextAlign = "Right",
        Color = Colors.White,
        Position = {0, title_size[2] + (2.5 * btn_size[2])},
        Size = {3 * btn_size[1], btn_size[2]}
    },
    {
        Type = "Text",
        Text = "Serial Number:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Bold",
        HTextAlign = "Right",
        Color = Colors.White,
        Position = {0, title_size[2] + (3.5 * btn_size[2])},
        Size = {3 * btn_size[1], btn_size[2]}
    },
    {
        Type = "Text",
        Text = "Firmware:",
        Font = "Roboto",
        FontSize = 12,
        FontStyle = "Bold",
        HTextAlign = "Right",
        Color = Colors.White,
        Position = {0, title_size[2] + (4.5 * btn_size[2])},
        Size = {3 * btn_size[1], btn_size[2]}
    },
    {
        Type = "GroupBox",
        Text = "Matrix",
        HTextAlign = "Left",
        Fill = Colors.lightware_black,
        CornerRadius = 8,
        StrokeColor = Colors.lightware_red,
        Color = Colors.lightware_red,
        StrokeWidth = 1,
        Position = matrix_groupbox_position,
        Size = matrix_groupbox_size
    },
    {
        Type = "Text",
        Text = "Signal",
        FontSize = 10,
        Color = Colors.White,
        Position = {matrix_groupbox_position[1], (matrix_groupbox_position[2] + (2.5 * btn_size[2]))},
        Size = btn_size
    }
}
for i = 1, input_count do
    table.insert(
        graphics,
        {
            Type = "Text",
            Text = "In" .. i,
            Color = Colors.White,
            Position = {
                (matrix_groupbox_position[1] + btn_size[1]),
                (matrix_groupbox_position[2] + (2.5 * btn_size[2])) + (i * btn_size[2])
            },
            Size = btn_size
        }
    )
end
for i = 1, output_count do
    table.insert(
        graphics,
        {
            Type = "Text",
            Text = "Out\r" .. i,
            Color = Colors.White,
            Position = {btn_size[1] + (i * btn_size[1]), (matrix_groupbox_position[2] + (1.5 * btn_size[2]))},
            Size = btn_size
        }
    )
end
-- System
layout["online"] = {
    PrettyName = "System~Online",
    Style = "Indicator",
    Color = {0, 255, 0},
    Position = {3 * btn_size[1], title_size[2] + (0.5 * btn_size[2])},
    Size = {btn_size[2], btn_size[2]}
}
layout["ip_address"] = {
    PrettyName = "System~IP Address",
    Style = "TextBox",
    Position = {3 * btn_size[1], title_size[2] + (1.5 * btn_size[2])},
    Size = {3 * btn_size[1], btn_size[2]}
}
layout["model"] = {
    PrettyName = "System~Model Name",
    Style = "Text",
    Position = {3 * btn_size[1], title_size[2] + (2.5 * btn_size[2])},
    Size = {3 * btn_size[1], btn_size[2]}
}
layout["serial_number"] = {
    PrettyName = "System~Part Number",
    Style = "Text",
    Position = {3 * btn_size[1], title_size[2] + (3.5 * btn_size[2])},
    Size = {3 * btn_size[1], btn_size[2]}
}
layout["firmware_version"] = {
    PrettyName = "System~Firmware Version",
    Style = "Text",
    Position = {3 * btn_size[1], title_size[2] + (4.5 * btn_size[2])},
    Size = {3 * btn_size[1], btn_size[2]}
}
for i = 1, output_count do -- For each output
    layout["output_" .. i] = {
        PrettyName = "Output " .. i .. "~Select",
        Style = "Indicator",
        Color = {255, 255, 255},
        Position = {btn_size[1] + (i * btn_size[1]), matrix_groupbox_position[2] + (2.5 * btn_size[2])},
        Size = btn_size
    }
    layout["video_mute_" .. i] = {
        PrettyName = "Video Mute~Video Mute " .. i,
        Style = "Button",
        Legend = "Mute",
        Color = {255, 0, 0},
        Position = {btn_size[1] + (i * btn_size[1]), matrix_groupbox_position[2] + (0.5 * btn_size[2])},
        Size = btn_size
    }
    for s = 1, input_count do -- For each input
        layout["input_" .. s .. "-output_" .. i] = {
            PrettyName = "Output " .. i .. "~In" .. s .. " -> Out" .. i,
            Style = "Button",
            Legend = tostring(s),
            Position = {
                btn_size[1] + (i * btn_size[1]),
                matrix_groupbox_position[2] + (2.5 * btn_size[2] + (s * btn_size[2]))
            },
            Size = btn_size
        }
    end
end
for i = 1, input_count do
    layout["input_signal " .. i] = {
        PrettyName = string.format("Signal Presence~Source %02i", i),
        Style = "Indicator",
        Color = {0, 255, 0},
        Position = {
            (matrix_groupbox_position[1] + (btn_size[1] - btn_size[2]) / 2),
            matrix_groupbox_position[2] + ((i + 2.5) * btn_size[2])
        },
        Size = {btn_size[2], btn_size[2]}
    }
end
