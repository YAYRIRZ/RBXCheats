--[[
    LURAPH v14.7 FULL WORKSPACE DUMPER
    Запусти этот скрипт ПЕРВЫМ в executor
    Затем запусти обфусцированный скрипт
    Все результаты сохранятся в workspace
]]

print("[LURAPH DUMPER] Initializing full workspace dump...")

-- Storage
local dump_data = {
    strings = {},
    loads = {},
    constants = {},
    functions = {},
    all_data = {}
}

-- Hook string.char
local orig_char = string.char
string.char = function(...)
    local result = orig_char(...)
    if #result > 1 then
        table.insert(dump_data.strings, result)
    end
    return result
end

-- Hook table.concat
local orig_concat = table.concat
table.concat = function(t, sep, i, j)
    local result = orig_concat(t, sep, i, j)
    if #result > 3 then
        table.insert(dump_data.strings, result)
    end
    return result
end

-- Hook loadstring
local orig_loadstring = loadstring
loadstring = function(code, chunkname)
    print("[DUMP] loadstring called! Length: " .. #code)
    table.insert(dump_data.loads, code)
    
    -- Save immediately
    local filename = "luraph_load_" .. #dump_data.loads .. ".lua"
    writefile(filename, code)
    print("[DUMP] Saved to " .. filename)
    
    return orig_loadstring(code, chunkname)
end

-- Hook load if exists
if load then
    local orig_load = load
    load = function(code, chunkname, env)
        print("[DUMP] load called! Length: " .. #code)
        table.insert(dump_data.loads, code)
        
        local filename = "luraph_load_" .. #dump_data.loads .. ".lua"
        writefile(filename, code)
        print("[DUMP] Saved to " .. filename)
        
        return orig_load(code, chunkname, env)
    end
end

-- Hook bit32.bxor
if bit32 and bit32.bxor then
    local orig_bxor = bit32.bxor
    bit32.bxor = function(a, b)
        table.insert(dump_data.constants, {type="bxor", a=a, b=b, result=orig_bxor(a,b)})
        return orig_bxor(a, b)
    end
end

-- Auto-save function
local function save_all()
    print("\n[LURAPH DUMPER] Saving all data...")
    
    -- Save strings
    local strings_output = ""
    local unique_strings = {}
    for _, s in ipairs(dump_data.strings) do
        if not unique_strings[s] and #s > 2 then
            unique_strings[s] = true
            strings_output = strings_output .. s .. "\n"
        end
    end
    writefile("luraph_strings.txt", strings_output)
    print("[DUMP] Saved " .. #dump_data.strings .. " strings to luraph_strings.txt")
    
    -- Save all loads
    for i, code in ipairs(dump_data.loads) do
        writefile("luraph_decoded_" .. i .. ".lua", code)
    end
    print("[DUMP] Saved " .. #dump_data.loads .. " decoded files")
    
    -- Save constants
    local const_output = ""
    for _, c in ipairs(dump_data.constants) do
        if c.type == "bxor" then
            const_output = const_output .. string.format("bxor(%d, %d) = %d\n", c.a, c.b, c.result)
        end
    end
    writefile("luraph_constants.txt", const_output)
    print("[DUMP] Saved " .. #dump_data.constants .. " constants to luraph_constants.txt")
    
    -- Save summary
    local summary = string.format([[
LURAPH v14.7 DUMP SUMMARY
=========================
Strings captured: %d
Load calls: %d
Constants: %d

Files saved:
- luraph_strings.txt (all decoded strings)
- luraph_decoded_*.lua (decoded Lua code from loadstring/load)
- luraph_constants.txt (XOR operations and other constants)
- luraph_load_*.lua (individual load calls)
]], #dump_data.strings, #dump_data.loads, #dump_data.constants)
    
    writefile("LURAPH_DUMP_SUMMARY.txt", summary)
    print("\n" .. summary)
    print("[LURAPH DUMPER] Complete! Check workspace for all files.")
end

-- Auto-save after 20 seconds
delay(20, save_all)

-- Export
_G.luraph_save_all = save_all
_G.luraph_dump_data = dump_data

print("[LURAPH DUMPER] Hooks installed!")
print("[LURAPH DUMPER] Now run your obfuscated script...")
print("[LURAPH DUMPER] Auto-save in 20 seconds, or call: luraph_save_all()")
