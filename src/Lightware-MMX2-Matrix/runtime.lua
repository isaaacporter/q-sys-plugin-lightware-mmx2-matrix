-- Local Structure for holding State
LW3 = {
    Host = "",
    Port = 6107,
    Rx = ""
}

-- Build TCP Client
conn = TcpSocket.New()
conn.ReadTimeout = 0
conn.WriteTimeout = 0
conn.ReconnectTimeout = 5

-- Create and setup the Communications Timeout
timerComms = Timer.New()
timerComms.EventHandler = function(timer)
    timer:Stop()
    Controls.online.Boolean = false
    print("Connection Timed Out")
    conn:Disconnect()
    fnConnect()
end

-- Create and setup Polling
timerPoll = Timer.New()

timerPoll.EventHandler = function(timer)
    fnPoll()
end

function fnInitPoll()
    timerPoll:Stop()
    timerPoll:Start(20)
end

function fnPoll()
    -- No need for Polling - tested device returns UpTime each second
    --fnSend("GET", "/.*")
end

-- Data Sending Helper Function
function fnSend(cmd, arg)
    -- Build Packet
    local toSend = cmd .. " " .. arg
    -- Send to device
    print("-->LW::" .. toSend)
    conn:Write(toSend .. "\x0D\x0A")
    -- Reset Polling
    fnInitPoll()
end

function matrix_feedback(inp, outp)
    Controls["output_" .. outp].String = inp
    for i = 1, input_count do
        Controls["input_" .. i .. "-output_" .. outp].Boolean = i == tonumber(inp)
    end
end

function tie_command(inp, outp)
    fnSend("CALL", string.format("/V1/MEDIA/VIDEO/XP:switch(I%1i:O%1i)", inp, outp))
end

-- Setup Utility Callbacks as required
conn.Connected = function(conn)
    print("TCP socket is connected")

    -- Get Meta Data
    fnSend("GET", "/")

    -- Get and Subscribe to System State Data
    fnSend("GET", "/V1/MANAGEMENT/DATETIME")
    fnSend("OPEN", "/V1/MANAGEMENT/DATETIME")

    -- Get and Subscribe to Video Routing Data
    fnSend("OPEN", "/V1/MEDIA/VIDEO/XP/*")
    for i = 1, output_count do
        fnSend("GETALL", string.format("/V1/MEDIA/VIDEO/XP/O%i", i))
    end
    for i = 1, input_count do
        fnSend("GETALL", string.format("/V1/MEDIA/VIDEO/XP/I%i", i))
    end
end
conn.Reconnect = function(conn)
    print("TCP socket is reconnecting")
end
conn.Closed = function(conn)
    print("TCP socket was closed by the remote end")
end
conn.Error = function(conn, err)
    print("TCP socket had an error:" .. err)
end
conn.Timeout = function(conn, err)
    print("TCP socket timed out:" .. err)
end

-- Helper Function - Open TCP Connection
function fnConnect()
    print("TCP Socket Connecting")
    -- Open Connection
    conn:Connect(LW3.Host, LW3.Port)
    -- Set IP address value
    if Controls.ip_address then
        Controls.ip_address.String = LW3.Host .. ":" .. LW3.Port
    end
end

local function split(str, delim)
    local result = {}
    for part in str:gmatch("[^" .. delim .. "]+") do
        result[#result + 1] = part
    end
    return result
end

-- Setup Data Callbacks as required
conn.Data = function(conn)
    -- Read out lines from the buffer
    line = conn:ReadLine(TcpSocket.EOL.Any)
    while (line ~= nil) do
        --print(line)
        -- Remove the header
        x = line:find(" ")
        if x ~= nil then
            line = line:sub(x + 1)
        end
        -- Get Path if "." is present
        x = line:find("%.")
        y = line:find("%=")
        if x ~= nil and y ~= nil then
            path = line:sub(1, x - 1)
            func = line:sub(x + 1, y - 1)
            val = line:sub(y + 1)
            -- Select Command Path
            if path == "/" then -- Root
                -- System Status
                -- Part Number
                if func == "PartNumber" then
                --Controls.PartNumber.String = val
                end
                -- Serial Number
                if func == "SerialNumber" then
                    Controls.serial_number.String = val
                end
                -- Product Name
                if func == "ProductName" then
                    Controls.model.String = val
                end                    
                -- Firmware
                if func == "PackageVersion" then
                    Controls.firmware_version.String = val
                end
            elseif path == "/V1/MANAGEMENT/DATETIME" then -- Management Status
                -- Uptime
                if func == "Uptime" then
                    --Controls.UpTime.Value = val
                    -- Stop and restart Comms timer
                    timerComms:Stop()
                    if Controls.online then -- Check for when developing in a Control Script block
                        Controls.online.Boolean = true
                    end
                    timerComms:Start(30)
                end
            elseif string.find(path, "/V1/MEDIA/VIDEO/XP") then -- Video Crosspoint
                if func == "ConnectedSource" then
                    matrix_feedback(val:sub(-1),path:sub(-1))
                elseif func == "ConnectedDestinations" then 
                    -- Connected source is catching them all
                elseif func == "SignalPresent" then 
                    -- Check it's an Input SignalPresent
                    if path:sub(-2,-2) == "I" then
                        Controls["input_signal"][tonumber(path:sub(-1))].Boolean = (val == "true")
                    end
                elseif func == "Mute" then
                    Controls["video_mute_" .. path:sub(-1)].Boolean = (val == "true")
                end
            end
        end
        -- Read a new line
        line = conn:ReadLine(TcpSocket.EOL.Any)
    end
end

-- Set IP address from Properties if present
if Properties then
    if Properties["IP Address"].Value ~= "" then
        LW3.Host = Properties["IP Address"].Value
        fnConnect()
    else
        print("IP Address Property Not Set")
    end
end
for i = 1, output_count do
    Controls["output_" .. i].EventHandler = function()
        tie_command(Controls["output_" .. i].String, i)
    end
    Controls["video_mute_" .. i].EventHandler = function()
        if Controls["video_mute_" .. i].Boolean then
            print("CALL", string.format("/V1/MEDIA/VIDEO/XP:muteDestination(O%i)", i))
            fnSend("CALL", string.format("/V1/MEDIA/VIDEO/XP:muteDestination(O%i)", i))
        else
            fnSend("CALL", string.format("/V1/MEDIA/VIDEO/XP:unmuteDestination(O%i)", i))
        end
    end
end
for i = 1, output_count do
    for p = 1, input_count do
        Controls["input_" .. p .. "-output_" .. i].EventHandler = function()
            Controls["output_" .. i].String = tostring(p)
            tie_command(Controls["output_" .. i].String, i)
        end
    end
end
