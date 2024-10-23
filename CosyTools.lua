script_name("CosyTools")
script_version("1")

local TAG = '{7B68EE}[WOUBLE] {CFCFCF}CosyTools | {9B9B9B}'
local DTAG = '{7B68EE}CosyDEBUG | {9B9B9B}'
local c_green = '{1DDC4B}'
local c_red = '{E92313}'
local c_main = '{9B9B9B}'

require 'lib.moonloader'
local imgui = require 'imgui'
local vkey = require'vkeys'
samp = require 'samp.events'
local effil = require 'effil'
local requests = require "requests"
local inicfg = require 'inicfg'
local fa = require 'fAwesome5'
local ffi = require("ffi")
local font = renderCreateFont("Tahoma", 9, 5) --[[�����]]
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local selected = 4
local active = false
--[[settings colors and lines]]
local colorObj = '0xFFFFFFFF' --[[������� ������ ����� , �������� 0xFFFFFFFF - ����� ����]]
local linewidth = '3.5' --[[��������������� �������� �� 3.0 �� 5.0]]
--[[settings colors and lines]]

local mainIni = inicfg.load({
	render = {
	    rtreasure = false,
	    rbookmark = false,
	    rdeer = false,
	    rflax = false,
	    rcotton = false,
	    rseeds = false,
	    rore = false,
	    rtree = false,
		rwood = false,
		myObjectOne = false,
		myObjectTwo = false,
		rclothes = false,
		rmushroom = false,
		rgift = false,
		rbox = false,
		rore_underground = false,
	    nameObjectOne = u8'Object name',
		nameObjectTwo = u8'Object name'
    },
    ghetto = {
	    rgrove = false,
	    rballas = false,
	    rrifa = false,
	    raztec = false,
	    rNightWolves = false,
	    rvagos = false,
		rpaint = false
	},
	settings = {
	    scriptName = u8'ch',
		clue = false,
		distanceoff = false,
		selected_item = 0
	},
	antiwarn = {
		work = false,
		ds = true,
		vk = false,
		action = 1,
		ds_id = '<@id>'
		
	},
	simons = {},
	aw_leaders = {'��������� ������', '���. ���������� ������', '�������� ���', '����������� ��������� ���', '����������', '�����', '����������� ����', '���', 'local', '�������'},
	aw_names= {}
}, 'CosyTools')

local work = imgui.ImBool(true)
local debuger = imgui.ImBool(false)
local aw_work = imgui.ImBool(mainIni.antiwarn.work)
local aw_ds = imgui.ImBool(mainIni.antiwarn.ds)
local aw_vk = imgui.ImBool(mainIni.antiwarn.vk)
local aw_action = imgui.ImInt(mainIni.antiwarn.action)
local aw_ds_id = imgui.ImBuffer(mainIni.antiwarn.ds_id,200)
local rtreasure = imgui.ImBool(mainIni.render.rtreasure)
local rbookmark = imgui.ImBool(mainIni.render.rbookmark)
local rdeer = imgui.ImBool(mainIni.render.rdeer)
local rflax = imgui.ImBool(mainIni.render.rflax)
local rcotton = imgui.ImBool(mainIni.render.rcotton)
local rseeds = imgui.ImBool(mainIni.render.rseeds)
local rore = imgui.ImBool(mainIni.render.rore)
local rore_underground = imgui.ImBool(mainIni.render.rore_underground)
local rtree = imgui.ImBool(mainIni.render.rtree)
local rwood = imgui.ImBool(mainIni.render.rwood)
local myObjectOne = imgui.ImBool(mainIni.render.myObjectOne)
local myObjectTwo = imgui.ImBool(mainIni.render.myObjectTwo)
local rclothes = imgui.ImBool(mainIni.render.rclothes)
local rmushroom = imgui.ImBool(mainIni.render.rmushroom)
local rgift= imgui.ImBool(mainIni.render.rgift)
local nameObjectOne = imgui.ImBuffer(mainIni.render.nameObjectOne, 256)
local nameObjectTwo = imgui.ImBuffer(mainIni.render.nameObjectTwo, 256)
local testbuffer = imgui.ImBuffer(50)
local name = imgui.ImBuffer(50)
local aw_leader_name = imgui.ImBuffer(50)
local aw_names_name = imgui.ImBuffer(50)
local scriptName = imgui.ImBuffer(mainIni.settings.scriptName, 256)
local clue = imgui.ImBool(mainIni.settings.clue)
local distanceoff = imgui.ImBool(mainIni.settings.distanceoff)
local selected_item = imgui.ImInt(mainIni.settings.selected_item)
local rbox = imgui.ImBool(mainIni.render.rbox)

------------------------------------------------------
local rgrove = imgui.ImBool(mainIni.ghetto.rgrove)
local rballas = imgui.ImBool(mainIni.ghetto.rballas)
local rrifa = imgui.ImBool(mainIni.ghetto.rrifa)
local raztec = imgui.ImBool(mainIni.ghetto.raztec)
local rNightWolves = imgui.ImBool(mainIni.ghetto.rNightWolves)
local rvagos = imgui.ImBool(mainIni.ghetto.rvagos)
local rpaint = imgui.ImBool(mainIni.ghetto.rpaint)


local main_window_state = imgui.ImBool(false)
local sw, sh = getScreenResolution()
local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })

if not doesFileExist('moonloader/config/CosyTools.ini') then inicfg.save(mainIni, 'CosyTools.ini') end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
	_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	myNick = sampGetPlayerNickname(myid)
    
	autoupdate("https://raw.githubusercontent.com/WOUB1E/CozyTools/refs/heads/main/cosy_ver.json", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/WOUB1E/CozyTools/refs/heads/main/CosyTools.lua")
	
	sampRegisterChatCommand('removeconfig', function()
        os.remove('moonloader\\config\\CosyTools.ini')
		thisScript():reload()
		msg('������ ������� �������!')
    end)
	
	sampRegisterChatCommand('stap',function()
		if terminate_session then
			terminate_session:terminate()
			active = false
			msg('AntiWarn | ����, ������!!')
		end
	end)
	
	sampRegisterChatCommand('aw',function()
		aw_work.v = not aw_work.v
		if aw_work.v then
			msg('AntiWarn {1DDC4B}�������')
		else
			msg('AntiWarn {E92313}��������')
		end
	end)
	
	sampRegisterChatCommand(mainIni.settings.scriptName, function()
        main_window_state.v = not main_window_state.v

        imgui.Process = main_window_state.v
    end)

    imgui.Process = false
	
	while true do
        wait(0)
		if selected_item.v == 0 then
			if isKeyJustPressed(vkey.VK_F12) then
				main_window_state.v = not main_window_state.v
				imgui.Process = main_window_state.v
			end
		end
		if selected_item.v == 1 then
			if isKeyJustPressed(vkey.VK_F2) then
				main_window_state.v = not main_window_state.v
				imgui.Process = main_window_state.v
			end
		end
		if selected_item.v == 2 then
			if isKeyJustPressed(vkey.VK_F3) then
				main_window_state.v = not main_window_state.v
				imgui.Process = main_window_state.v
			end
		end
		if rdeer.v then
		    for k,v in ipairs(getAllChars()) do
			    if select(2, sampGetPlayerIdByCharHandle(v)) == -1 and v ~= PLAYER_PED and getCharModel(v) == 3150 then
			        local xp, yp, zp = getCharCoordinates(PLAYER_PED)
				    local px, py, pz = getCharCoordinates(v)
				    local wX, wY = convert3DCoordsToScreen(px, py, pz)
				    local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
				    distance = string.format("%.0f�", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
				    if isPointOnScreen(px, py, pz, 0) then
					    if distanceoff.v then
							renderFontDrawText(font, '������', wX, wY , colorObj)
						elseif distanceoff.v == false then
				            renderFontDrawText(font, '������\n ���������: '..distance, wX, wY , colorObj)
						end
				        renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				    end
			    end
		    end
	    end
		if rtreasure.v or rseeds.v or rore.v or rclothes.v or rgift.v then -- new test functions optimization
		    for k, v in pairs(getAllObjects()) do
			    local num = getObjectModel(v)
			    if isObjectOnScreen(v) and rtreasure.v then
				    if num == 2680 then
					    local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					    local res, px, py, pz = getObjectCoordinates(v)
					    local wX, wY = convert3DCoordsToScreen(px, py, pz)
					    distance = string.format("%.0f�", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					    local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					    if getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp) > 32 then
						    if distanceoff.v then
					            renderFontDrawText(font, '�����(�������� ����)', wX, wY , colorObj)
                            elseif distanceoff.v == false then
							    renderFontDrawText(font, '�����(�������� ����)\n ���������: '..distance, wX, wY , colorObj)
						    end
					    elseif getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp) < 32 then
						    if distanceoff.v then
					            renderFontDrawText(font, '�����', wX, wY , colorObj)
                            elseif distanceoff.v == false then
							    renderFontDrawText(font, '�����\n ���������: '..distance, wX, wY , colorObj)
						    end
					    end
					    renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				    end
			    end
			if isObjectOnScreen(v) and rseeds.v then
				if num == 859 then
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					distance = string.format("%.0f�", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					if distanceoff.v then
						renderFontDrawText(font, '�������', wX, wY , colorObj)
					elseif distanceoff.v == false then
						renderFontDrawText(font, '�������\n ���������: '..distance, wX, wY , colorObj)
					end
					renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				end
			end
            if isObjectOnScreen(v) and rore.v then
				if num == 854 then
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					distance = string.format("%.0f�", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					if distanceoff.v then
						renderFontDrawText(font, '�����', wX, wY , colorObj)
					elseif distanceoff.v == false then
						renderFontDrawText(font, '�����\n ���������: '..distance, wX, wY , colorObj)
					end
					renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				end
			end
			if isObjectOnScreen(v) and rclothes.v then
				if num == 18893 or num == 2844 or num == 2819 or num == 18919 or num == 18974 or num == 18946 or num == 2705 or num == 2706 then
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					distance = string.format("%.0f�", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					if distanceoff.v then
						renderFontDrawText(font, '������� ������', wX, wY , colorObj)
					elseif distanceoff.v == false then
						renderFontDrawText(font, '������� ������\n ���������: '..distance, wX, wY , colorObj)
					end
					renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				end
			end
			if isObjectOnScreen(v) and rgift.v then
				if num == 19054 or num == 19055 or num == 19056 or num == 19057 or num == 19058 then
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					distance = string.format("%.0f�", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					if distanceoff.v then
						renderFontDrawText(font, '��������', wX, wY , colorObj)
					elseif distanceoff.v == false then
						renderFontDrawText(font, '��������\n ���������: '..distance, wX, wY , colorObj)
					end
					renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				end
			end
		    end
	    end
		for id = 0, 2048 do
            local result = sampIs3dTextDefined( id )
            if result then
                local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById( id )
				distance = string.format("%.0f�", getDistanceBetweenCoords3d(posX, posY, posZ,x2,y2,z2))
				local textograffiti = text..'\n\n         - (���������: ' ..distance..') -'
				local texto = text..'\n - (���������: ' ..distance..') -'
                if rbookmark.v and text:find("��������") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen(posX,posY,posZ,1) then
						if distanceoff == false then
							renderFontDrawText(font,' ��������\n ���������: '..distance, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,' ��������', wposX, wposY, colorObj)
						end
                    end
                end
				if rflax.v and text:find("˸�") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen(posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if rcotton.v and text:find("������")then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen(posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				--�������
				if rtree.v and text:find("��������� ������") or rtree.v and text:find("�������� ������") or rtree.v and text:find("�������� ������") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
						    renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if rwood.v and text:find("������ ������� ��������") then
					local resX, resY = getScreenResolution()
					local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
					if isPointOnScreen (posX,posY,posZ,1) then
					    renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj)
					end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						if distanceoff.v == false then
                            renderFontDrawText(font,' ������ ���.��������\n ���������: '..distance, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,' ������ ���.��������', wposX, wposY, colorObj)
						end
					end
                end
				if rore_underground.v and text:find("����� ������ ��������") then
					local resX, resY = getScreenResolution()
					local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
					if isPointOnScreen (posX,posY,posZ,1) then
					    renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj)
					end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						if distanceoff.v == false then
                            renderFontDrawText(font,' ����(���������)\n ���������: '..distance, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,' ����(���������)', wposX, wposY, colorObj)
						end
					end
                end
				if rbox.v and text:find("������� ������") then
					local resX, resY = getScreenResolution()
					local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
					if isPointOnScreen (posX,posY,posZ,1) then
					    renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj)
					end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						if distanceoff.v == false then
                            renderFontDrawText(font,' ������ BomjGang\n ���������: '..distance, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,' ������ BomjGang', wposX, wposY, colorObj)
						end
					end
                end
				--�����
				if rgrove.v and text:find("�����: {ff6666}{009327}Grove Street") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if rballas.v and text:find("�����: {ff6666}{CC00CC}East Side Ballas") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
						renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj)
					end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
			    if rrifa.v and text:find("�����: {ff6666}{6666FF}The Rifa") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if raztec.v and text:find("�����: {ff6666}{00FFE2}Varrios Los Aztecas") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if rNightWolves.v and text:find("�����: {ff6666}{A87878}Night Wolves") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if rvagos.v and text:find("�����: {ff6666}{D1DB1C}Los Santos Vagos") and text:find('�������� ��������� ����� �����:') then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if rpaint.v and text:find("�����: {ff6666}{00FFE2}Varrios Los Aztecas") and not text:find('�������� ��������� ����� �����:') or rpaint.v and text:find("�����: {ff6666}{D1DB1C}Los Santos Vagos") and not text:find('�������� ��������� ����� �����:') or rpaint.v and text:find("�����: {ff6666}{A87878}Night Wolves") and not text:find('�������� ��������� ����� �����:') or  rpaint.v and text:find("�����: {ff6666}{6666FF}The Rifa") and not text:find('�������� ��������� ����� �����:') or  rpaint.v and text:find("�����: {ff6666}{CC00CC}East Side Ballas") and not text:find('�������� ��������� ����� �����:') or rpaint.v and text:find("�����: {ff6666}{009327}Grove Street") and not text:find('�������� ��������� ����� �����:') then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if rmushroom.v and text:find("������� ����") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen(posX,posY,posZ,1) then
						if distanceoff.v == false then
                            renderFontDrawText(font,' ����\n ���������: '..distance, wposX, wposY, colorObj)
                        elseif distanceoff.v then
							renderFontDrawText(font,' ����', wposX, wposY, colorObj)
						end
					end
                end
				-------------------------------���� obj-----------------------------------
				if myObjectOne.v and text:find(u8:decode(nameObjectOne.v)) then 
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
						renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
					end
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if myObjectTwo.v and text:find(u8:decode(nameObjectTwo.v)) then 
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
			end
		end
        if main_window_state.v == false then
            imgui.Process = false
        end
	end
end

function samp.onShowDialog(did, style, title, b1, b2, text)
	if debuger.v then
		dmsg('DIALOG INFO | ID = [{FFFFFF}'..did..'{9B9B9B}] TITLE = [{FFFFFF}'..title..'{9B9B9B}]')
		print(text)
		print('-    ---    ---   ---   ---   ---   ---   -')
	end
	if did == 15253 then
		sampSendDialogResponse(did, 1, 1, nil)
		return false
	elseif did == 15254 then
		sampSendDialogResponse(did, 1, nil, nil)
		return false
	elseif did == 25893 and smi  then
		sampSendDialogResponse(did, 1, nil, nil)
		return false
	elseif did == 15346 and smi  then
		sampSendDialogResponse(did, 1, nil, nil)
		return false
	elseif did == 25477 and smi then
		sampSendDialogResponse(did, 1, 0, nil)
		return false
	elseif did == 15347 and smi then
		sampSendDialogResponse(did, 1, nil, nil)
		return false
	end	
end

function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                msg('���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('��������� %d �� %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('�������� ���������� ���������.')
                      msg('���������� ���������! ����� ������: '..updateversion)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        msg('���������� ������ ��������. �������� ���������� ������...')
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              msg('� ��� ����� v'..thisScript().version..'. ���������� �� ���������.')
			  msg((work.v and c_green..'SimonSays '..c_main..' | ' or c_red..'SimonSays '..c_main..' | ')..''..(aw_work.v and c_green..'AntiWarn '..c_main..' | ' or c_red..'AntiWarn '..c_main..' | '))
            end
          end
        else
          print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

function msg(text)
	sampAddChatMessage(TAG..''..text,-1)
end

function dmsg(text)
	sampAddChatMessage(DTAG..''..text,-1)
end

function samp.onServerMessage(color,text)
	-- antiwarn
	if aw_work.v then
		_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
		myNick = sampGetPlayerNickname(myid)
		if text:find('%[R%].-%A+ %w+_%w+%[.+%]: .+') then
			local tag, textt = string.match(text,'%[R%].+(%A+) %w+_%w+%[.+%]: (.+)')
			find_me(text,textt,tag)
		elseif text:find('.+%[.+%] �������:%{.+%} .+') then
			local textt = string.match(text,'.+%[.+%] �������:%{.+%} (.+)')
			find_me(text,textt,'local')
		elseif text:find('%[D%].-%A+ %w+_%w+%[.+%]: .+') then
			local tag, textt = string.match(text,'%[D%].-(%A+) %w+_%w+%[.+%]: (.+)')
			find_me(text,textt,tag)
		end
	end
	--antiwarn
	-- simon
	if work.v then
		if text:find('%(%( .+%[%d+%]: %{B7AFAF%}#.+ %)%)') then -- ��������
			print(text)
			local simon, command = string.match(text, '%(%( (.+)%[%d+%]: %{B7AFAF%}#(.+)%{FFFFFF%} %)%)')
			if table.concat(mainIni.simons, ', '):find(simon) then
				_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
				myNick = sampGetPlayerNickname(myid)
				if simon  ~= myNick then
					lua_thread.create(function()
						wait(200)
						sampProcessChatInput(command)
					end)
				end
			end
		elseif text:find('%(%( (.+)%[%d+%]: %{B7AFAF%}.+, .+%{FFFFFF%} %)%)') then -- ���������
			print(text)
			local simon, who, command = string.match(text, '%(%( (.+)%[%d+%]: %{B7AFAF%}(.+), (.+)%{FFFFFF%} %)%)')
			if table.concat(mainIni.simons, ', '):find(simon) then
				_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
				myNick = sampGetPlayerNickname(myid)
				if simon  ~= myNick then
					if who == myid or who == myNick then
						lua_thread.create(function()
							wait(200)
							sampProcessChatInput(command)
						end)
					end
				end
			end
		elseif text:find('%{C04312%}%[�����%].+ %w+_%w+%[%d+%]:%{B9C1B8%} #.+') then
			local simon, command = string.match(text, '%{C04312%}%[�����%].+ (%w+_%w+)%[%d+%]:%{B9C1B8%} #(.+)')
			if table.concat(mainIni.simons, ', '):find(simon) then
				_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
				myNick = sampGetPlayerNickname(myid)
				if simon  ~= myNick then
					lua_thread.create(function()
						wait(200)
						sampProcessChatInput(command)
					end)
				end
			end
		elseif text:find('%[R%].+ %w+_%w+%[%d+%]: %(%( #.+ %)%)') then
			local simon, command = string.match(text, '%[R%].+ (%w+_%w+)%[%d+%]: %(%( #(.+) %)%)')
			if table.concat(mainIni.simons, ', '):find(simon) then
				_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
				myNick = sampGetPlayerNickname(myid)
				if simon  ~= myNick then
					lua_thread.create(function()
						wait(200)
						sampProcessChatInput(command)
					end)
				end
			end
		end
	end
	-- simon
end

function key_selection()
	if selected_item.v == 0 then
	    imgui.Text(u8"��������� ���������.��� ��������� ������� �� ������� ������� F12")
	elseif selected_item.v == 1 then
		imgui.Text(u8"��������� ���������.��� ��������� ������� �� ������� ������� F2")
    elseif selected_item.v == 2 then
		imgui.Text(u8"��������� ���������.��� ��������� ������� �� ������� ������� F3")
	end
end

function imgui.OnDrawFrame()
	if not main_window_state.v then imgui.Process = false end
	if main_window_state.v then
	imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(630, 455), imgui.Cond.FirstUseEver)
	imgui.Begin(u8'CosyTools', main_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove)
	imgui.BeginChild('##menu', imgui.ImVec2(150, 425), true)
	imgui.CenterText(u8'����')
	if imgui.Button(fa.ICON_FA_INFO_CIRCLE .. u8' ����������', imgui.ImVec2(135, 70.4)) then selected = 1 end
	imgui.Separator()
	if imgui.Button(fa.ICON_FA_USER .. u8' ������', imgui.ImVec2(135, 70.4)) then selected = 2 end
	imgui.Separator()
	if imgui.Button(fa.ICON_FA_WRENCH	 .. u8' �����������', imgui.ImVec2(135, 70.4)) then selected = 5 end
	imgui.Separator()
	if imgui.Button(fa.ICON_FA_ELLIPSIS_V .. u8' �����������', imgui.ImVec2(135, 70.4)) then selected = 4 end
	imgui.Separator()
	if imgui.Button(fa.ICON_FA_BINOCULARS .. u8' ������', imgui.ImVec2(135, 70.4)) then selected = 3 end
	imgui.EndChild()
	imgui.SameLine()
	if selected == 3 then
		imgui.BeginChild('##render', imgui.ImVec2(227, 425), true)
		imgui.CenterText(u8'��������')
		imgui.Separator()
		imgui.Checkbox(u8"���", rflax)
		-- [[if clue.v == false then...end -- �������� ������� ��������� ]]
		if clue.v == false then
			imgui.Hint(u8"���������� ������ �� ������ ���\n����������: ������ ����������� �� ������ ���� � �����",0) 
		end
		imgui.Checkbox(u8"������", rcotton)
		if clue.v == false then
		    imgui.Hint(u8"���������� ������ �� ������ ������\n����������: ������ ����������� �� ������ ������ � �����",0)
		end
		imgui.Checkbox(u8"�����", rtreasure)
		if clue.v == false then
		    imgui.Hint(u8"���������� ������ �� ���� [������� ������� � ������]\n����������: ������������ ������� �������� ������� ����-�����\n������ ���������!",0)
	    end
		imgui.Checkbox(u8"��������", rbookmark)
		if clue.v == false then
		    imgui.Hint(u8"���������� ������ �� ��������",0)
	    end
		imgui.Checkbox(u8"������", rseeds)
		if clue.v == false then
		    imgui.Hint(u8"���������� ������ �� ������ ����������",0)
	    end
		imgui.Checkbox(u8"�����", rdeer)
		if clue.v == false then
		    imgui.Hint(u8"���������� ������ �� ������\n����������: �������� ���� �� �� ����� ��������� ������",0)
	    end
		imgui.Checkbox(u8"����", rore)
		if clue.v == false then
		    imgui.Hint(u8"���������� ������ �� ����\n����������: ������ �� ���������� �������� ���",0)
	    end
		imgui.Checkbox(u8"������� � �������", rtree)
		if clue.v == false then
		    imgui.Hint(u8"���������� ������ �� �������",0)
	    end
		imgui.Checkbox(u8"������� ������� ��������", rwood)
		if clue.v == false then
		    imgui.Hint(u8"���������� ������ �� ������� ������� ��������",0)
	    end
		imgui.Checkbox(u8"������ ������", rclothes)
		if clue.v == false then
		    imgui.Hint(u8"���������� ������ �� ������ ������",0)
	    end
		imgui.Checkbox(u8"�����", rmushroom)
		if clue.v == false then
		    imgui.Hint(u8"���������� ������ �� �����",0)
	    end
		imgui.Checkbox(u8"�������(�� �����)", rgift)
		if clue.v == false then
		    imgui.Hint(u8"���������� ������ �� �������, ������� ��������� �� �����",0)
	    end
		imgui.Checkbox(u8"����(��������� �����)", rore_underground)
		if clue.v == false then
		    imgui.Hint(u8"���������� ������ �� ����, ������� ��������� � ��������� �����",0)
	    end
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild('##render2', imgui.ImVec2(227, 425), true)
		imgui.CenterText(u8'���� �������(��������)')
		imgui.Separator()
		imgui.Text(u8'���� Object #1')
		imgui.Checkbox(u8"", myObjectOne)
		if clue.v == false then
		    imgui.Hint(u8"������ ������� ��������� �������� ���� ��������� ������� �� �������\n����������: ���������� ������� �������",0)
	    end
		imgui.SameLine()
		imgui.InputText(u8'##�������� ������� ��� ������� �1', nameObjectOne)
		if clue.v == false then
		    imgui.Hint(u8"�������� ���� �����, �� ������� ������ ������� �������\n����������: ���� ������� ALT- �� ��� � ������ ALT",0)
	    end
		imgui.Text(u8'���� Object #2')
		imgui.Checkbox(u8"", myObjectTwo)
		if clue.v == false then
		    imgui.Hint(u8"������ ������� ��������� �������� ���� ��������� ������� �� �������\n����������: ���������� ������� �������",0)
	    end
		imgui.SameLine()
		imgui.InputText(u8'##�������� ������� ��� ������� �2', nameObjectTwo)
		imgui.Separator()
		imgui.CenterText(u8'������ ��������')
		imgui.Separator()
		if imgui.Checkbox(u8"����", rgrove) then
			if rpaint.v then
			    rpaint.v = false
			end
		end
	    if imgui.Checkbox(u8"������", rballas) then
			if rpaint.v then
			    rpaint.v = false
			end
		end
	    if imgui.Checkbox(u8"����", rrifa) then
			if rpaint.v then
			    rpaint.v = false
			end
		end
	    if imgui.Checkbox(u8"�����", raztec) then
		    if rpaint.v then
			    rpaint.v = false
			end
		end
	    if imgui.Checkbox(u8"������ �����", rNightWolves) then
			if rpaint.v then
			    rpaint.v = false
			end
		end
	    if imgui.Checkbox(u8"�����", rvagos) then
			if rpaint.v then
			    rpaint.v = false
			end
		end
		if imgui.Checkbox(u8"��������� ��� ��������", rpaint) then
			rgrove.v = false
			rballas.v = false
			raztec.v = false
			rNightWolves.v = false
			rvagos.v = false
			rrifa.v = false--[[������� ���������� ������ ��������]]
		end
		saving()
		imgui.EndChild()
    elseif selected == 2 then
		imgui.BeginChild('##simon', imgui.ImVec2(227, 425), true)
		imgui.CenterText(u8'SimonSays')
		imgui.Separator()
		imgui.Checkbox(u8"������������ �� �������", work)
		if clue.v == false then
		    imgui.Hint(u8"���� ����� �������� �� ����� � ������������\n�� ������� �� ��������.",0)
	    end
		imgui.Text(u8'\n\n\n\n\n\n\n\n\n')
		imgui.Separator()
		imgui.CenterText(u8'������� ����������')
		imgui.Separator()
		imgui.Text(u8'����� ������ ���������� �:\n/b - ��� �� ���\n/fam - �������� ����\n/rb - ��� �� ���� �����������\n\n���� ���������:\n��� ����: /b #[command]\n�� 1(id): /b [id], [command]\n�� 1(nick): /b [nick], [command]\n\n�������:\n/b #Hello world\n/rb #Hello World\n/b 42, Hello World')
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild('##simonlist', imgui.ImVec2(227, 425), true)
		imgui.CenterText(u8'������ ��������')
		imgui.Separator()
		imgui.PushItemWidth(210)
		if imgui.InputTextWithHint(u8"##world", u8"������� nick_name", name) then
			name.v = name.v:gsub('%(', '')
			name.v = name.v:gsub('%)', '')
			name.v = name.v:gsub('%[', '')
			name.v = name.v:gsub('%]', '')
		end
		if imgui.Button(u8('��������'), imgui.ImVec2(210, 40)) then
			if #name.v > 0 then
				msg('������� ����� ���: '..u8:decode(name.v))
				table.insert(mainIni.simons, name.v)
				inicfg.save(mainIni, "CosyTools.ini")
			else
				msg('���� � ����� �����!')
			end
		end
		if #mainIni.simons > 0 then
			imgui.Separator()
			for k, v in pairs(mainIni.simons) do
				if imgui.Button(fa.ICON_FA_TRASH..'##'..k) then 
					table.remove(mainIni.simons, k)
					inicfg.save(mainIni, "CosyTools.ini")
				end
				imgui.SameLine()
				imgui.Text('['..k..']: '..v)
				imgui.Separator()
			end
		end
		imgui.EndChild()
    elseif selected == 1 then
		imgui.BeginChild('##information', imgui.ImVec2(460, 425), true)
		imgui.CenterText(u8'���������� � ������������')
		imgui.Separator()
		imgui.Text(u8'��������� ������: /'..scriptName.v)
		imgui.Text(u8'--[] ���� ������ ����� ����������� �������� - �������� ������')
		imgui.Text(u8'--[] ��� ������ ������� - ����������� �������: /removeconfig')
		imgui.Text(u8'--[] ��� ������ � ������� ������������')
        imgui.Separator()
		imgui.PushItemWidth(150)
		if imgui.InputText(u8'##�������� �������', scriptName) then
			mainIni.settings.scriptName = scriptName.v
			inicfg.save(mainIni, "CosyTools.ini")
		end
		imgui.PopItemWidth()
		imgui.SameLine()
		imgui.Text(u8'������� ��������� ������� (��� �����)')
		imgui.Text(u8'����� ����� ����� ������� - ������������� ������')
		imgui.Separator()
		if imgui.Checkbox(u8"������ ���������", clue) then
			mainIni.settings.clue = clue.v
			inicfg.save(mainIni, "CosyTools.ini")
		end
		if imgui.Checkbox(u8"������ ����������� ���������", distanceoff) then
			mainIni.settings.distanceoff = distanceoff.v
			inicfg.save(mainIni, "CosyTools.ini")
		end
		imgui.Checkbox(u8"����� ������������", debuger)
		if clue.v == false then
		    imgui.Hint(u8"���� ����� �������� �� ��������� ������ ������������",0)
	    end
		imgui.PushItemWidth(120)
		if imgui.Combo(u8'��������� �������(�������)', selected_item, {'F12', 'F2', 'F3'}, 4) then
			if selected_item.v == 0 or selected_item.v == 1 or selected_item.v == 2 then
				lua_thread.create(function()
					key = true
					wait(6000)
					key = false
			    end)
			end
			mainIni.settings.selected_item = selected_item.v
			inicfg.save(mainIni, "CosyTools.ini")
		end
		if key then
			key_selection()
		end
        imgui.PopItemWidth()
		imgui.Separator()
        imgui.Text(u8'��������!!!')
		imgui.Text(u8'��� ������������� �������� ������ FPS �� 99%.')
		imgui.Text(u8'��� ������� � ����� ����� ��, �� �����')
		imgui.Text(u8'����� ��� �������� ������� �������� ������ fps �� 98%')
		imgui.Text(u8'-- ��� �������������� ������ ������� ����� �����')
		imgui.Separator()
		if imgui.Button(u8'��������', imgui.ImVec2(100,36)) then
			autoupdate("https://raw.githubusercontent.com/WOUB1E/CozyTools/refs/heads/main/cosy_ver.json", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/WOUB1E/CozyTools/refs/heads/main/CosyTools.lua")
		end
		imgui.Hint(u8"������ ������ �������� ������� ���������� �������\n� ��� �� ������� ��� ��� ������� ����������.",0)
		imgui.SameLine()
		if imgui.Button(u8'�������������', imgui.ImVec2(100,36)) then
			thisScript():reload()
		end
		if clue.v == false then
		    imgui.Hint(u8"������ ������ ������������ ������.",0)
	    end
		imgui.SameLine()
		if imgui.Button(u8'��������� ������', imgui.ImVec2(115,36)) then
			thisScript():unload()
		end
		if clue.v == false then
		    imgui.Hint(u8"������ ������ ��������� ������ �� ����, �� �� ������� �� ������������.\n����������: ����� ������ ��������, ������������� ������� ��� ����������� � ����.",0)
	    end
		imgui.SameLine()
		if imgui.Button(u8'�������� ������', imgui.ImVec2(115,36)) then
			os.remove('moonloader\\config\\CosyTools.ini')
		    thisScript():reload()
		    msg('������ ������� �������!')
		end
		if clue.v == false then
		    imgui.Hint(u8"������ ������ ������� ��� ���� ���������(ini file)\n����������: ��� ������� �� ������ ������ �� ��������� ��� ���� ���������!",0)
	    end
		imgui.EndChild()
	elseif selected == 4 then
		imgui.BeginChild('##miscMain', imgui.ImVec2(460, 425), false)
			imgui.Columns(2,'colums1',false)
			imgui.BeginChild('##misc', imgui.ImVec2(226, 209), true)
				imgui.CenterText(u8'AntiWarn')
				imgui.Separator()
				imgui.Checkbox(u8"���/����", aw_work)
				if clue.v == false then
					imgui.Hint(u8"�������� ����� � ������������ �� �������� �����.",0)
				end
				imgui.Checkbox(u8"���������� � DS", aw_ds)
				if clue.v == false then
					imgui.Hint(u8"� ������ ������������ �������� ���������\n� ����������� ����� � ��������.",0)
				end
				imgui.Checkbox(u8"���������� � VK", aw_vk)
				if clue.v == false then
					imgui.Hint(u8"� ������ ������������ �������� ���������\n� ����������� ������ �� ���������.",0)
				end
				if imgui.Combo(u8'��������', aw_action, {u8'�����', u8'��������� | 1 ���',u8'��������� | 2 ���', u8'��������� | 3 ���', u8'��������� | 4 ���'}, 4) then
					mainIni.antiwarn.action = aw_action.v
					inicfg.save(mainIni, "CosyTools.ini")
				end
				imgui.PushItemWidth(165)
				imgui.InputTextWithHint(u8"##aw_leaders_list1", u8"������� ds id", aw_ds_id)
				imgui.SameLine()
				imgui.Text(u8'                                           DS ID')
				imgui.Text(u8'��������!!\n�� � ���� ������ �� ������� <@>')
				imgui.EndChild() 

				imgui.NextColumn()
				imgui.BeginChild('##misc2', imgui.ImVec2(226, 209), true)
				imgui.CenterText(u8'������ �������� �����')
				imgui.Separator()
				imgui.PushItemWidth(200)
				if imgui.InputTextWithHint(u8"##aw_leaders_list", u8"������� ���", aw_leader_name) then
					aw_leader_name.v = aw_leader_name.v:gsub('%(', '')
					aw_leader_name.v = aw_leader_name.v:gsub('%)', '')
					aw_leader_name.v = aw_leader_name.v:gsub('%[', '')
					aw_leader_name.v = aw_leader_name.v:gsub('%]', '')
				end
				if imgui.Button(u8('��������'), imgui.ImVec2(200, 40)) then
					if #aw_leader_name.v > 0 then
						msg('������� ����� ���: '..u8:decode(aw_leader_name.v))
						table.insert(mainIni.aw_leaders, aw_leader_name.v)
						inicfg.save(mainIni, "CosyTools.ini")
					else
						msg('���� � ����� �����!')
					end
				end
				if #mainIni.aw_leaders > 0 then
					imgui.Separator()
					for k, v in pairs(mainIni.aw_leaders) do
						if imgui.Button(fa.ICON_FA_TRASH..'##'..k) then 
							table.remove(mainIni.aw_leaders, k)
							inicfg.save(mainIni, "CosyTools.ini")
						end
						imgui.SameLine() 
						imgui.Text(u8(v))
						imgui.Separator()
					end
				end
			imgui.EndChild()
			imgui.Columns(1)
			imgui.Columns(2,'colums2',false)
			imgui.BeginChild('##misc3', imgui.ImVec2(226, 209), true)
				imgui.CenterText(u8'Information')
				imgui.Separator()
				imgui.Text(u8'��� ������� �������� ���, ���� �\n�����, ��������� ���� ��� � �����\n������������ �������� ��������\n�����.\n\n�������� ������� ����� ����\n��� ��������: [/aw]\n\n������� �� �������� � �����\n�� ��������� ��� ��������� �����\n� ����� ������� ���������� �\nwoub1e.')
			imgui.EndChild()
			imgui.NextColumn()
			imgui.BeginChild('##misc4', imgui.ImVec2(226, 209), true)
				imgui.CenterText(u8'������ �������� ����')
				imgui.Separator()
				imgui.PushItemWidth(200)
				if imgui.InputTextWithHint(u8"##aw_names_list", u8"������� �����", aw_names_name) then
					aw_names_name.v = aw_names_name.v:gsub('%(', '')
					aw_names_name.v = aw_names_name.v:gsub('%)', '')
					aw_names_name.v = aw_names_name.v:gsub('%[', '')
					aw_names_name.v = aw_names_name.v:gsub('%]', '')
				end
				if imgui.Button(u8('��������'), imgui.ImVec2(200, 40)) then
					if #aw_names_name.v > 0 then
						msg('������� ����� ���: '..u8:decode(aw_names_name.v))
						table.insert(mainIni.aw_names, aw_names_name.v)
						inicfg.save(mainIni, "CosyTools.ini")
					else
						msg('���� � ����� �����!')
					end
				end
				if #mainIni.aw_names > 0 then
					imgui.Separator()
					for k, v in pairs(mainIni.aw_names) do
						if imgui.Button(fa.ICON_FA_TRASH..'##'..k) then 
							table.remove(mainIni.aw_names, k)
							inicfg.save(mainIni, "CosyTools.ini")
						end
						imgui.SameLine() 
						imgui.Text(v)
						imgui.Separator()
					end
				end
			imgui.EndChild() 
		imgui.EndChild()
	saving()
	elseif selected == 5 then
		imgui.BeginChild('##Soon', imgui.ImVec2(460, 425), true)
		imgui.CenterText(u8'Soon')
		imgui.EndChild()
	end
	imgui.End()
    end
end

function apply_custom_style()

	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2

	style.WindowPadding = ImVec2(8, 8)
	style.WindowRounding = 5.0
	style.ChildWindowRounding = 5.0
	style.FramePadding = ImVec2(2, 2)
	style.FrameRounding = 5.0
	style.ItemSpacing = ImVec2(5, 5)
	style.ItemInnerSpacing = ImVec2(5, 5)
	style.TouchExtraPadding = ImVec2(0, 0)
	style.IndentSpacing = 5.0
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 5.0
	style.GrabMinSize = 20.0
	style.GrabRounding = 5.0
	style.WindowTitleAlign = ImVec2(0.5, 0.5)
	style.ButtonTextAlign = ImVec2(0.5, 0.5)
 
	colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
	colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
	colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
	colors[clr.ChildWindowBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
	colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
	colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
	colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
	colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
	colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
	colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
	colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
	colors[clr.Button] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.ButtonHovered] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
	colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
	colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
	colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
	colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
	colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
apply_custom_style()

function saving()
    mainIni.render.rtreasure = rtreasure.v
	mainIni.render.rbookmark = rbookmark.v
	mainIni.render.rgift = rgift.v
	mainIni.render.rdeer = rdeer.v
	mainIni.render.rflax = rflax.v
	mainIni.render.rcotton = rcotton.v
	mainIni.render.rseeds = rseeds.v
	mainIni.render.rore = rore.v
	mainIni.render.rore_underground = rore_underground.v
    mainIni.render.rtree = rtree.v
	mainIni.render.rclothes = rclothes.v
	mainIni.render.rmushroom = rmushroom.v
	mainIni.ghetto.rgrove = rgrove.v
	mainIni.ghetto.rballas =  rballas.v
	mainIni.ghetto.rrifa = rrifa.v
	mainIni.ghetto.raztec =  raztec.v
	mainIni.ghetto.rNightWolves = rNightWolves.v
	mainIni.ghetto.rvagos =  rvagos.v
	mainIni.ghetto.rpaint =  rpaint.v
	mainIni.render.rwood =  rwood.v
	mainIni.render.rbox =  rbox.v
	mainIni.render.myObjectOne =  myObjectOne.v
	mainIni.render.myObjectTwo =  myObjectTwo.v
	mainIni.render.nameObjectOne = nameObjectOne.v
	mainIni.render.nameObjectTwo = nameObjectTwo.v
	mainIni.settings.selected_item = selected_item.v
	mainIni.antiwarn.work = aw_work.v
	mainIni.antiwarn.ds = aw_ds.v
	mainIni.antiwarn.vk = aw_vk.v
	mainIni.antiwarn.action = aw_action.v
	mainIni.antiwarn.ds_id = aw_ds_id.v
    inicfg.save(mainIni, "CosyTools.ini")
end

function SendWebhook(URL, DATA, callback_ok, callback_error) -- ������� �������� �������
    local function asyncHttpRequest(method, url, args, resolve, reject)
        local request_thread = effil.thread(function (method, url, args)
           local requests = require 'requests'
           local result, response = pcall(requests.request, method, url, args)
           if result then
              response.json, response.xml = nil, nil
              return true, response
           else
              return false, response
           end
        end)(method, url, args)
        if not resolve then resolve = function() end end
        if not reject then reject = function() end end
        lua_thread.create(function()
            local runner = request_thread
            while true do
                local status, err = runner:status()
                if not err then
                    if status == 'completed' then
                        local result, response = runner:get()
                        if result then
                           resolve(response)
                        else
                           reject(response)
                        end
                        return
                    elseif status == 'canceled' then
                        return reject(status)
                    end
                else
                    return reject(err)
                end
                wait(0)
            end
        end)
    end
    asyncHttpRequest('POST', URL, {headers = {['content-type'] = 'application/json'}, data = u8(DATA)}, callback_ok, callback_error)
end

function url_encode(str)
  local str = string.gsub(str, "\\", "\\")
  local str = string.gsub(str, "([^%w])", char_to_hex)
  return str
end

function char_to_hex(str)
  return string.format("%%%02X", string.byte(str))
end

function threadHandle(runner, url, args, resolve, reject) -- ��������� effil ������ ��� ����������
	local t = runner(url, args)
	local r = t:get(0)
	while not r do
		r = t:get(0)
		wait(0)
	end
	local status = t:status()
	if status == 'completed' then
		local ok, result = r[1], r[2]
		if ok then resolve(result) else reject(result) end
	elseif err then
		reject(err)
	elseif status == 'canceled' then
		reject(status)
	end
	t:cancel(0)
end

function requestRunner() -- �������� effil ������ � �������� https �������
	return effil.thread(function(u, a)
		local https = require 'ssl.https'
		local ok, result = pcall(https.request, u, a)
		if ok then
			return {true, result}
		else
			return {false, result}
		end
	end)
end

function async_http_request(url, args, resolve, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	lua_thread.create(function()
		threadHandle(runner, url, args, resolve, reject)
	end)
end

function imgui.CenterText(text)
	local width = imgui.GetWindowWidth()
	local size = imgui.CalcTextSize(text)
	imgui.SetCursorPosX(width/2-size.x/2)
	imgui.Text(text)
end

function imgui.Link(link,name,myfunc)
    myfunc = type(name) == 'boolean' and name or myfunc or false
    name = type(name) == 'string' and name or type(name) == 'boolean' and link or link
    local size = imgui.CalcTextSize(name)
    local p = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local resultBtn = imgui.InvisibleButton('##'..link..name, size)
    if resultBtn then
        if not myfunc then
            os.execute('explorer '..link)
        end
    end
    imgui.SetCursorPos(p2)
    if imgui.IsItemHovered() then
        imgui.TextColored(imgui.ImVec4(0, 0.5, 1, 1), name)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32(imgui.ImVec4(0, 0.5, 1, 1)))
    else
        imgui.TextColored(imgui.ImVec4(0, 0.3, 0.8, 1), name)
    end
    return resultBtn
end

function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
        font_config.MergeMode = true

        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 13.0, font_config, fa_glyph_ranges)
    end
end

function imgui.Hint(text, delay, action)
    if imgui.IsItemHovered() then
        if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
        local alpha = (os.clock() - go_hint) * 5
        if os.clock() >= go_hint then
            imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
            imgui.PushStyleVar(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
                imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(0.11, 0.11, 0.11, 1.00))
                    imgui.BeginTooltip()
                    imgui.PushTextWrapPos(450)
                    imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.ButtonHovered], u8'���������:')
                    imgui.TextUnformatted(text)
                    if action ~= nil then
                        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.TextDisabled], '\n '..action)
                    end
                    if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
                    imgui.PopTextWrapPos()
                    imgui.EndTooltip()
                imgui.PopStyleColor()
            imgui.PopStyleVar(2)
        end
    end
end --[[������� ������� ��������� by HarlyCloud]]

function imgui.InputTextWithHint(label, hint, buf, flags, callback, user_data)
    local l_pos = {imgui.GetCursorPos(), 0}
    local handle = imgui.InputText(label, buf, flags, callback, user_data)
    l_pos[2] = imgui.GetCursorPos()
    local t = (type(hint) == 'string' and buf.v:len() < 1) and hint or '\0'
    local t_size, l_size = imgui.CalcTextSize(t).x, imgui.CalcTextSize('A').x
    imgui.SetCursorPos(imgui.ImVec2(l_pos[1].x + 8, l_pos[1].y + 2))
    imgui.TextDisabled((imgui.CalcItemWidth() and t_size > imgui.CalcItemWidth()) and t:sub(1, math.floor(imgui.CalcItemWidth() / l_size)) or t)
    imgui.SetCursorPos(l_pos[2])
    return handle
end

local lower, sub, char, upper = string.lower, string.sub, string.char, string.upper
local concat = table.concat

function term(text)
	if active == false and aw_work.v then
		terminate_session = lua_thread.create(function()
			active = true
			if aw_ds then
				SendNotify(text)
			end
			if aw_vk then
				SendVkNotify(text)
			end
			msg('AntiWarn | � ��� ���� {E33131}60 ������{9B9B9B}, ����� ��������� {E33131}/stap{9B9B9B}, ����� ������������� ����� �� ����.')
			wait(60000)
			SendOff()
			SendVkOff(text)
			active = false
			if aw_action.v == 0 then
				sampDisconnectWithReason(quit)
			elseif aw_action.v == 1 then
				rec(60000)
			elseif aw_action.v == 2 then
				rec(120000)
			elseif aw_action.v == 3 then
				rec(180000)
			elseif aw_action.v == 4 then
				rec(240000)
			end
		end)
	end
end

function rec(timee)
	raknetEmulPacketReceiveBitStream(PACKET_DISCONNECTION_NOTIFICATION, raknetNewBitStream())
	raknetDeleteBitStream(raknetNewBitStream())
	wait(timee)
	sampDisconnectWithReason(0)
	sampSetGamestate(GAMESTATE_WAIT_CONNECT)
end 

function find_me(text,textt,tag)
	if table.concat(mainIni.aw_leaders, ', '):find(string.nlower(tag)) then
		for k, v in pairs(mainIni.aw_names) do
			if string.nlower(textt):find(string.nlower(u8:decode(v))) then
				term(text)
			end
		end
		if string.nlower(textt):find(myid) then
			term(text)
		end
	end
end

local lu_rus, ul_rus = {}, {}
for i = 192, 223 do
    local A, a = char(i), char(i + 32)
    ul_rus[A] = a
    lu_rus[a] = A
end
local E, e = char(168), char(184)
ul_rus[E] = e
lu_rus[e] = E

function string.nlower(s)
    s = lower(s)
    local len, res = #s, {}
    for i = 1, len do
        local ch = sub(s, i, i)
        res[i] = ul_rus[ch] or ch
    end
    return concat(res)
end


function SendVkNotify(text)
	token_vk = '999f88d0def02db3b4de53b49850af2d924515f3e2bac4c6fae3899ac773b0fa16cef35c7893ae8555536' -- ����� ������ ��
	groupid_vk = '210879029' -- id ������ (������ �����!)
	chat_id = '2' -- id ������
	
	msgtext=([[%s | ��� ���������!
	
	%s]]):format(myNick,text)
	
	msgtext=u8(msgtext)
	msgtext=url_encode(msgtext)
	requests.get("https://api.vk.com/method/messages.send?v=5.103&access_token="..token_vk.."&chat_id="..chat_id.."&message="..msgtext.."&group_id="..groupid_vk.."&random_id="..random(1111111111, 9999999999))
end

function SendVkOff(a)
	token_vk = '999f88d0def02db3b4de53b49850af2d924515f3e2bac4c6fae3899ac773b0fa16cef35c7893ae8555536' -- ����� ������ ��
	groupid_vk = '210879029' -- id ������ (������ �����!)
	chat_id = '2' -- id ������
	
	msgtext=([[%s | �� ���� �������!]]):format(myNick)
	
	msgtext=u8(msgtext)
	msgtext=url_encode(msgtext)
	requests.get("https://api.vk.com/method/messages.send?v=5.103&access_token="..token_vk.."&chat_id="..chat_id.."&message="..msgtext.."&group_id="..groupid_vk.."&random_id="..random(1111111111, 9999999999))
end

function SendNotify(a)
	SendWebhook('https://discord.com/api/webhooks/1290697679088652430/oPrHQJobVrNZbptYG2Z2ppvV45SVf4I45y7T4VqfUKL1oq3sWjCIBTmvBtcSLmz2fVPo', ([[{
  "content": "<:icons_ping:859424401324900352> | %s, �� ���� ���������!",
  "embeds": [
    {
      "description": "**%s**",
      "color": null
    }
  ],
  "attachments": []
}]]):format(aw_ds_id.v,a))
end

function SendOff()
	SendWebhook('https://discord.com/api/webhooks/1290697679088652430/oPrHQJobVrNZbptYG2Z2ppvV45SVf4I45y7T4VqfUKL1oq3sWjCIBTmvBtcSLmz2fVPo', ([[{
  "content": "<:icons_outage:868122243845206087> | %s, �� ���� �������!",
  "embeds": null,
  "attachments": []
}]]):format(aw_ds_id.v))
end

u = 0 -- don't delete

function random(x, y)
    u = u + 1
    if x ~= nil and y ~= nil then
        return math.floor(x +(math.random(math.randomseed(os.time()+u))*999999 %y))
    else
        return math.floor((math.random(math.randomseed(os.time()+u))*100))
    end
end