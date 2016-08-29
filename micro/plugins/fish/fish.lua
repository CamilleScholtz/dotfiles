if GetOption("fishfmt") == nil then
    AddOption("fishfmt", false)
end

MakeCommand("fishfmt", "fish.fishfmt", 0)

function onSave(view)
    if CurView().Buf:FileType() == "fish" then
        if GetOption("fishfmt") then
            fishfmt()
        end
    end
end

function fishfmt()
    CurView():Save(false)
    local handle = io.popen("fish_indent -w " .. CurView().Buf.Path)
    local result = handle:read("*a")
    handle:close()
    
    CurView():ReOpen()
end
