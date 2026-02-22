-- --- ARASAKA CYBERDECK HUD - LUA ENGINE ---
-- Optimized with dynamic scaling and parametric hardware detection

-- 1. Helper: Get config variables from Conky Templates
local function get_conf(id)
    return conky_parse("${template" .. id .. "}")
end

-- 2. Resolution Scaling Helpers
-- Reads dimensions from the .conf file to calculate relative positions
local screen_w = tonumber(conky_parse("${screen_width}")) or 2560
local screen_h = tonumber(conky_parse("${screen_height}")) or 1440

-- Calculates X position based on screen width percentage
local function get_x(percent)
    return math.floor(screen_w * (percent / 100))
end

-- Calculates Y position/offset based on screen height percentage
local function get_y(percent)
    return math.floor(screen_h * (percent / 100))
end

-- 3. Helper: Pure-space padding for precise box alignment
-- Handles multi-byte UTF-8 characters like "°C" correctly
local function pad_val(val, len)
    local s = tostring(val)
    s = s:gsub("^%s*(.-)%s*$", "%1")
    local _, real_len = s:gsub("[%z\1-\127\194-\244][\128-\191]*", "")
    if real_len >= len then return s end
    return s .. string.rep(" ", len - real_len)
end

-- 4. Component: Arasaka Style Data Box with relative positioning
function draw_cyber_box(title, value, x_percent, y_percent_offset)
    local color = "00FFFF"
    local x = get_x(x_percent)
    local y_off = get_y(y_percent_offset)
    local display_val = pad_val(value, 8)
    
    local line1 = string.format("${goto %d}${voffset %d}${color %s}╔══════════════╦════════╗", x, y_off, color)
    local line2 = string.format("${goto %d}║%-14s║%8s║", x, title, display_val)
    local line3 = string.format("${goto %d}╚══════════════╩════════╝", x)
    return line1 .. "\n" .. line2 .. "\n" .. line3
end

function conky_draw_main()
    local out = ""
    local font_main = get_conf(1)
    local net_if = get_conf(2)
    local tz = get_conf(3)

    -- Parsing combined templates (split by |)
    local cpu_data = get_conf(4)
    local cpu_chip, cpu_label = cpu_data:match("([^|]+)|([^|]+)")
    
    local sys_data = get_conf(5)
    local sys_chip, sys_label = sys_data:match("([^|]+)|([^|]+)")

    local gpu_data = get_conf(6)
    local pwr_data = get_conf(7)
    
    -- Sensors Commands
    local mem_p_val = tonumber(conky_parse("${memperc}"))
    local mem_u_val = conky_parse("${mem}")
    local mem_max_val = conky_parse("${memmax}")
    local cpu_load_val = "${cpu cpu0}%"
    local cpu_temp_val = string.format("${exec sensors %s | grep '%s' | awk '{print $4}'}", cpu_chip, cpu_label)
    local sys_temp_val = string.format("${exec sensors %s | grep '%s' | awk '{print $2}'}", sys_chip, sys_label)
    local fs_used_val = "${fs_used_perc /}%"
    local gpu_val = string.format("${exec %s}",gpu_data)
    local pwr_val = string.format("${exec %s | grep percentage | awk '{print $2}'}",pwr_data)
    local data_in_val = "${diskio_write}"
    local data_out_val = "${diskio_read}"
    local net_in_val = "${downspeed " .. net_if .. "}"
    local net_out_val = "${upspeed " .. net_if .. "}"

    -- --- 1. CYBERDECK RAM (CENTERED HUD) ---
    local ram_x = get_x(37.1) 
    local box_width = 46 
    
    out = out .. "${voffset " .. get_y(2.5) .. "}${goto " .. ram_x .. "}${color 00FFFF}${font " .. font_main .. ":size=15}╔════════════════CYBERDECK RAM═════════════════╗"
    
    local mem_info = string.format("%s / %s [%d%%]", mem_u_val, mem_max_val, mem_p_val)
    local info_padding = math.floor((box_width - #mem_info) / 2)
    out = out .. "\n${goto " .. ram_x .. "}║" .. string.rep(" ", info_padding) .. mem_info .. string.rep(" ", box_width - #mem_info - info_padding) .. "║"
    
    local segments = 15 
    local filled = math.floor(mem_p_val / (100 / segments))
    local bar = ""
    for i = 1, segments do
        bar = bar .. (i <= filled and "█" or "▯") .. " " 
    end
    
    out = out .. "\n${goto " .. ram_x .. "}║" .. string.rep(" ", 8) .. bar .. string.rep(" ", 8) .. "║"
    out = out .. "\n${goto " .. ram_x .. "}╚══════════════════════════════════════════════╝"

    -- --- 2. LEFT SIDE DIAGNOSTICS (CURVED LAYOUT) ---
    out = out .. draw_cyber_box("DECK CHIP LOAD", conky_parse(cpu_load_val), 14.8, 6.9)
    out = out .. draw_cyber_box("DECK CHIP TEMP", conky_parse(cpu_temp_val), 12.1, 2.7)
    out = out .. draw_cyber_box("DECK SYS TEMP", conky_parse(sys_temp_val), 9.7, 2.7)
    out = out .. draw_cyber_box("DECK CAPACITY", conky_parse(fs_used_val), 8.2, 2.7)
    out = out .. draw_cyber_box("DECK POWER", conky_parse(pwr_val), 7.4, 2.7)
    out = out .. draw_cyber_box("BRAINDANCE L.", conky_parse(gpu_val) .. "%", 7.4, 2.7) -- Label fissa
    out = out .. draw_cyber_box("DATA IN", conky_parse(data_in_val), 8.2, 2.7)
    out = out .. draw_cyber_box("DATA OUT", conky_parse(data_out_val), 9.7, 2.7)
    out = out .. draw_cyber_box("NET IN", conky_parse(net_in_val), 12.1, 2.7)
    out = out .. draw_cyber_box("NET OUT", conky_parse(net_out_val), 14.8, 2.7)

    -- --- 3. ARASAKA BRANDING & CLOCK ---
    out = out .. "\n${voffset " .. get_y(-10.4) .. "}${goto " .. get_x(46.8) .. "}${font " .. font_main .. ":size=15}${color EA4A5A}${tztime " .. tz .. " %H:%M:%S}"
    
    local logo_x_left = get_x(35.1)
    local logo_x_center = get_x(46.8)

    local arasaka_logo = [[
${color EA4A5A}${font ]] .. font_main .. [[:bold:size=4}
${goto ]] .. logo_x_center .. [[}             ......              
${goto ]] .. logo_x_center .. [[}        ..::::.....::::.         
${goto ]] .. logo_x_center .. [[}      .::.            .:::.      
${goto ]] .. logo_x_center .. [[}    .::       .:::.      .::     
${goto ]] .. logo_x_center .. [[}   ::.      .:::::::       ::.   
${goto ]] .. logo_x_center .. [[}  .:        .:::::::.  .    ::   
${goto ]] .. logo_x_center .. [[}  :. .::::::..:::::..::::::  ::  
${goto ]] .. logo_x_center .. [[} .:  ::::::::  :::  :::::::: ::  
${goto ]] .. logo_x_center .. [[} .:. .:::::::. .:. .:::::::. ::  
${goto ]] .. logo_x_center .. [[}  :.   .....:::::::::.....   ::  
${goto ]] .. logo_x_center .. [[}  .:.        .:::::.        ::   
${goto ]] .. logo_x_center .. [[}   ::.         ::.         ::    
${goto ]] .. logo_x_center .. [[}    .::        .::       .::     
${goto ]] .. logo_x_center .. [[}      .::.     ...    .:::.      
${goto ]] .. logo_x_center .. [[}         .::::....:::::.         
${goto ]] .. logo_x_center .. [[}              .....              
${goto ]] .. logo_x_left .. [[}               ......               ...........................                      .......                           ..........                           ......               .......            ...........          .......             
${goto ]] .. logo_x_left .. [[}        ..:::::::::::::..          .::::::::::::::::::::::::::::.              .::::::::::::::.                        ::::::::::::.                 ..::::::::::::::.          .:::::::.       .:::::::::::::.    .::::::::::::::.          
${goto ]] .. logo_x_left .. [[}     .::::::::::::::::::::..       .::::::::::::::::::::::::::::::          .::::::::::::::::::::.                     ::::::::::::::             .:::::::::::::::::::::.       .:::::::.    .:::::::::::::.    .::::::::::::::::::::.       
${goto ]] .. logo_x_left .. [[}   .:::::::::::::::::::::::::..    .:::::::::::::::::::::::::::::::       ::::::::::::::::::::::::::.                  :::::::::::::::          .::::::::::::::::::::::::::.    .:::::::. .:::::::::::::.     ::::::::::::::::::::::::::.    
${goto ]] .. logo_x_left .. [[}  ::::::::::..    ..::::::::::::.  .:::::::............. .::::::::::    .::::::::::..    .:::::::::::::   .............:..............         :::::::::::..   ..::::::::::::.  .::::::::::::::::::::.      .::::::::::..    .:::::::::::::  
${goto ]] .. logo_x_left .. [[} :::::::::.          ..::::::::::  .:::::::.               .::::::::   .::::::::.           .::::::::::.   .:::::::::::::.                    :::::::::.           .::::::::::  .:::::::::::::::::.         ::::::::.           .::::::::::. 
${goto ]] .. logo_x_left .. [[}.::::::::               .::::::::  .:::::::.                ::::::::   ::::::::.               ::::::::.      .:::::::::::::..               .::::::::               .::::::::  .::::::::::::::.           ::::::::.               ::::::::. 
${goto ]] .. logo_x_left .. [[}::::::::                 ::::::::  .:::::::.                ........  .::::::::                .:::::::.         .:::::::::::::..            ::::::::.                ::::::::  .:::::::::::.              ::::::::                .:::::::. 
${goto ]] .. logo_x_left .. [[}::::::::                 ::::::..  .::::::::::.                       .::::::::                .::::::.    .....    .:::::::::::::..         ::::::::                 ::::::..  .:::::::::::.              ::::::::                .::::::.  
${goto ]] .. logo_x_left .. [[}.::::::::                ::::::.     .:::::::::::.                     ::::::::.               .::::::.   ::::::::     .:::::::::::::.       .::::::::                ::::::.     .::::::::::::.           ::::::::.               .::::::.  
${goto ]] .. logo_x_left .. [[} :::::::::               ::::::::  .::::::::::::::::.                  .::::::::.              .:::::::.  ::::::::.        .::::::::::::.     :::::::::.              ::::::::  .:::::::::::::::::.        .::::::::.              .:::::::. 
${goto ]] .. logo_x_left .. [[}  ::::::::::..     ..    ::::::::  .:::::::::::::::::::.                .::::::::::.      ..   .:::::::.  ::::::::::.       .::::::::::::::    ::::::::::..     ..    ::::::::  .::::::::::::::::::::.      .::::::::::..     ..   .:::::::. 
${goto ]] .. logo_x_left .. [[}   .::::::::::::::::::.  ::::::::  .::::::::.:::::::::::::.               :::::::::::::::::::  .:::::::.  .::::::::::::::::::::::::::::::::     .::::::::::::::::::.  ::::::::  .:::::::: .:::::::::::::.     :::::::::::::::::::  .:::::::. 
${goto ]] .. logo_x_left .. [[}     .:::::::::::::::::. ::::::::   .......    .:::::::::::::.              .::::::::::::::::: .:::::::.   .:::::::::::::::::::::::::::::::       .:::::::::::::::::. ::::::::   .......     .:::::::::::::.    .::::::::::::::::: .:::::::. 
${goto ]] .. logo_x_left .. [[}        .:::::::::::::::.::::::::                 .:::::::::::::.             ..::::::::::::::..:::::::.     .:::::::::::::::::::::::::::::          ..::::::::::::::.::::::::                  .:::::::::::::.    .::::::::::::::..:::::::. 
${goto ]] .. logo_x_left .. [[}              .....      ........                    .............                  ......      .......        ...........................                 .....      ........                     ............         ......      .......  
]]
    out = out .. arasaka_logo .. "\n${goto " .. get_x(46.1) .. "}${font " .. font_main .. ":size=15}Mk.1-0 KAGE "

    -- --- 4. SYSTEM INFO & DAEMONS (RIGHT ALIGNED) ---
    local right_col_x = get_x(78.1) 
    
    out = out .. "${voffset " .. get_y(-68.5) .. "}${goto " .. right_col_x .. "}${font " .. font_main .. ":size=15}${color 00FFFF}╔════════════════SYSTEM INFO═════════════════╗"
    local sys_info = conky_parse("${execi 60 neofetch --off --color_blocks off --disable shell term wm theme icons memory | sed '1,3d' | grep ':'}")
    for line in sys_info:gmatch("[^\n]+") do
        local clean_line = line:gsub("\27%[[0-9;]*m", ""):gsub("^%s*", "")
        if #clean_line > 0 then
            out = out .. "\n${goto " .. right_col_x .. "}║ " .. string.format(" %-42s", clean_line:sub(1,42)) .. "║"
        end
    end
    out = out .. "\n${goto " .. right_col_x .. "}╚════════════════════════════════════════════╝"
      
    out = out .. "${voffset " .. get_y(2.0) .. "}${goto " .. right_col_x .. "}${font " .. font_main .. ":size=15}${color 00FFFF}╔═══════════════NETWORK DAEMONS══════════════╗"
    local raw_ps = conky_parse("${execi 5 ps ux --sort=-%cpu | awk 'NR>1 && NR<24 {printf \"%s|%s\\n\", $11, $3}'}")
    for line in raw_ps:gmatch("[^\n]+") do
        local name, cpu = line:match("([^|]+)|([^|]+)")
        if name and cpu then
            out = out .. "\n${goto " .. right_col_x .. "}║ " .. pad_val(name:match("([^/]+)$"):sub(1,34), 34) .. " " .. pad_val(cpu, 6) .. "% ║"
        end
    end
    out = out .. "\n${goto " .. right_col_x .. "}╚════════════════════════════════════════════╝${font}"

    return out
end