--[[
    https://github.com/kevinlekiller/mpv_scripts
   
    Sets "PowerMizer" in Nvidia GPUs with the proprietary driver to
    "Maximum Performance" mode while mpv is running.
    Sets "PowerMizer" back to "Adaptive" after mpv exits.
    
    The script will try to automatically detect a GPU.
    
    You can also manually set your GPU like this: --script-opts=powermizer-gpu="[gpu:1]"
    Find your GPU with this command: nvidia-settings -q gpus
--]]
--[[
    Copyright (C) 2015  kevinlekiller

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
    https://www.gnu.org/licenses/gpl-2.0.html
--]]
local test = os.execute("which nvidia-settings > /dev/null")
if (test == 0 or test == true) then
    local gpu = mp.get_opt("powermizer-gpu")
    if (gpu ~= nil) then
        gpu = string.match(gpu, "%[gpu:%d+%]")
    end
    if (gpu == nil) then
        local handle = assert(io.popen("nvidia-settings -q gpus"))
        for line in handle:lines() do
            gpu = string.match(line, "%[gpu:%d+%]")
            if (gpu ~= nil) then
                break
            end
        end
        handle:close()
        if (gpu == nil) then
            gpu = "[gpu:0]"
        end
    end

    function start()
        os.execute("nvidia-settings -a " .. gpu .. "/GPUPowerMizerMode=1 > /dev/null")
    end

    function stop()
        os.execute("nvidia-settings -a " .. gpu .. "/GPUPowerMizerMode=0 > /dev/null")
    end

    mp.register_event("file-loaded", start)
    mp.register_event("shutdown", stop)
end
