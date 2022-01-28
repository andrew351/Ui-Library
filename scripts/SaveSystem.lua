local SaveSystem = {}

local function tableIndex(table)
    local length = 0
    for i, v in pairs(table) do
        length += 1
    end
return length
end

local function GetExploit()
    local Table = {}
    Table.Synapse = syn
    Table.ProtoSmasher = pebc_create
    Table.Sentinel = issentinelclosure
    Table.ScriptWare = getexecutorname

    for ExploitName, ExploitFunction in next, Table do
        if (ExploitFunction) then
            return ExploitName
        end
    end

    return "Undefined"
end

local function EncodeJson(x)
    return game:GetService("HttpService"):JSONEncode(x)
end

local function DecodeJson(x)
    return game:GetService("HttpService"):JSONDecode(x)
end

local function GlobalImport(SettingsName, ProfileName, DefaultSettings)
    local Settings
local FileName = SettingsName.."_"..ProfileName..".json" -- must include a .json, change the 'ScriptNameSettings' to what you want
if writefile and readfile then
   local ExistingFile = pcall(readfile, FileName)
   if not ExistingFile then
        writefile(FileName, EncodeJson(DefaultSettings))
        Settings = DefaultSettings
   else
       Settings = DecodeJson(readfile(FileName))
   end
end
return Settings
end

local function ScriptWareImport(SettingsName,ProfileName,DefaultSettings)
    local Settings
    if not isprofile(SettingsName,ProfileName) then
        writeprofile(SettingsName, ProfileName, EncodeJson(DefaultSettings))
        Settings = DefaultSettings
    else
        Settings = DecodeJson(getprofile(SettingsName, ProfileName))
    end
    return Settings
end

function SaveSystem:Import(SettingsName, ProfileName, DefaultSettings)
    local Settings
    if GetExploit() == "ScriptWare" then 
        Settings = ScriptWareImport(SettingsName,ProfileName,DefaultSettings)
    else
        Settings = GlobalImport(SettingsName, ProfileName, DefaultSettings)
    end
    if(tableIndex(Settings) == 0) then return DefaultSettings end
    return Settings
end

local function ScriptWareEdit(SettingsName,ProfileName,Settings)
    if not isprofile(SettingsName,ProfileName) then
        deleteprofile(SettingsName, ProfileName)
            end
        writeprofile(SettingsName, ProfileName, EncodeJson(Settings))
end

local function GlobalEdit(SettingsName,ProfileName,Settings)
    writefile(SettingsName.."_"..ProfileName..".json", EncodeJson(Settings))
end

function SaveSystem:Edit(SettingsName,ProfileName,Settings)

    if GetExploit() == "ScriptWare" then 
        ScriptWareEdit(SettingsName,ProfileName,Settings)
    else
        GlobalEdit(SettingsName,ProfileName,Settings)
    end

end

function SaveSystem:Delete(SettingsName,ProfileName)

    if GetExploit() == "ScriptWare" then 
        deleteprofile(SettingsName, ProfileName)
    else
        delfile(SettingsName.."_"..ProfileName..".json")
    end

end

return SaveSystem
