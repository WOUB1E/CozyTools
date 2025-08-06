script_name("CosyTools")
script_version("9")
--[[
ОБНОВЫ:


--]]
local TAG = ':robot: {7B68EE}[WOUBLE] {CFCFCF}CosyTools | {9B9B9B}'
local DTAG = ':robot: {7B68EE}CosyDEBUG | {9B9B9B}'
local c_green = '{1DDC4B}'
local c_red = '{E92313}'
local c_main = '{9B9B9B}'

local socket = require 'socket'

require 'lib.moonloader'
local imgui = require 'imgui'
local vkey = require'vkeys'
local memory = require'memory'
samp = require 'samp.events'
local effil = require 'effil'
local requests = require "requests"
local inicfg = require 'inicfg'
local fa = require 'fAwesome5'
local ffi = require 'ffi'
local bit = require 'bit'
local was_command = false
local ffi = require("ffi")
local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Verdana', 12, font_flag.BOLD + font_flag.SHADOW)
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local selected = 1
local WasArmour = false
local alarm = true
local statusskin = 0
NeedWait = 0
local updateid
local currentarmour = 0
local TimerWork = false
local myskin = 0
local hook = {hooks = {}}
local lastskin = 0
local rab = false
local CheckStat = false
local CheckStatText = false
local active = false
local PayDayStat = {
	ohraprocent = 0,
	lgotaprocent = 0,
	lgotalvl = 0,
	xOst = 0,
	x = 1,
	bank = 0,
	zp = 0,
	depstat = 0,
	dep = 0,
	azstat = 0,
	az = 0
}
--[[settings colors and lines]]
local linewidth = '3.5' --[[Рекомендованные значения от 3.0 до 5.0]]
--[[settings colors and lines]]
local mainIni = inicfg.load({
	settings = {
	    scriptName = u8'ch',
		clue = false,
		distanceoff = false,
		selected_item = 0
	},
	antiwarn = {
		work = false,
		ds = true,
		tg = false,
		action = 1,
		ds_id = '<@id>'
		
	},
	autopatch = {
		work = false,
		patch_swat = u8'На поясе жетон __ /На груди нашивка __'
	},
	simons = {},
	aw_leaders = {u8'начальник тюрьмы', u8'зам. начальника тюрьмы', u8'директор фбр', u8'заместитель директора фбр', u8'андершериф', u8'шериф', u8'заместитель шефа', u8'шеф', u8'куратор'},
	aw_names= {}
}, 'CosyTools')
--local opis_official = "На поясе висит жетон FBI"
--local opis_swatform = 'На поясе жетон FBI/На груди нашивка "'..number..'"'
local work = imgui.ImBool(true)
local debuger = imgui.ImBool(false)
local ap_work = imgui.ImBool(mainIni.autopatch.work)
local ap_d_official = 'На поясе висит жетон FBI'
local patch_swat = imgui.ImBuffer(mainIni.autopatch.patch_swat, 100)
local aw_work = imgui.ImBool(mainIni.antiwarn.work)
local aw_ds = imgui.ImBool(mainIni.antiwarn.ds)
local aw_tg = imgui.ImBool(mainIni.antiwarn.tg)
local aw_action = imgui.ImInt(mainIni.antiwarn.action)
local aw_ds_id = imgui.ImBuffer(mainIni.antiwarn.ds_id,200)
local testbuffer = imgui.ImBuffer(50)
local name = imgui.ImBuffer(50)
local aw_leader_name = imgui.ImBuffer(50)
local aw_names_name = imgui.ImBuffer(50)
local scriptName = imgui.ImBuffer(mainIni.settings.scriptName, 256)
local clue = imgui.ImBool(mainIni.settings.clue)
local distanceoff = imgui.ImBool(mainIni.settings.distanceoff)
local selected_item = imgui.ImInt(mainIni.settings.selected_item) 

local main_window_state = imgui.ImBool(false)
local sw, sh = getScreenResolution()
local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })

chat_id = '-1002280229994' -- чат ID юзера
token = '7761048476:AAG26QwcnaIVDLZqh04jaMQFHIIqULTEp9I' -- токен бота 

local updateid -- ID последнего сообщения для того чтобы не было флуда
 
if not doesFileExist('moonloader/config/CosyTools.ini') then inicfg.save(mainIni, 'CosyTools.ini') end

function samp.onShowDialog(did, style, title, b1, b2, text)
	if debuger.v then
		dmsg('DIALOG INFO | ID = [{FFFFFF}'..did..'{9B9B9B}] TITLE = [{FFFFFF}'..title..'{9B9B9B}]')
		print(text)
		print('-    ---    ---   ---   ---   ---   ---   -')
	end
	
	if CheckStat then
		if title:find("Основная статистика") then
			sendTelegramNotification(MarkdownV2(text))
			CheckStat = false
			sampCloseCurrentDialogWithButton(1)
		end
	end
	
	if work.v then
		if title:find('%{.+%}Активные предложения') then
			local count = 0
			for line in text:gmatch('[^\r\n]+') do
				count = count + 1
				if line:find('.+\t.+%}%w+_%w+\t.+') and was_command then
					sender = string.match(line, '.+%}(%w+_%w+)\t.+')
					if table.concat(mainIni.simons, ', '):find(sender) then
						tap = count
						sampSendDialogResponse(did, 1, tap-2, nil)
						return false
					end
				elseif line:find('Принять предложение') and was_command then
					sampSendDialogResponse(did, 1, 2, nil)
					return false
				end
			end
		end
	end

	
	if ap_work.v and rab then
		if title:find("%{BFBBBA%}Личные настройки") then -- сеттингс
			sampSendDialogResponse(did, 1, 7, nil)
			return false
		elseif title:find("%{BFBBBA%}Настройки персонажа") then -- личные настройки
			sampSendDialogResponse(did, 1, 2, nil)
			return false
		elseif did == 15016 then -- установка описания
			if statusskin == 1 then
				sampSendDialogResponse(did, 1, nil, ap_d_official)
				msg(ap_d_official)
				rab = false
				return false
			elseif statusskin == 2 then
				sampSendDialogResponse(did, 1, nil, patch_swat.v)
				rab = false
				return false
			elseif statusskin == 0 then
				sampSendDialogResponse(did, 2, nil, nil)
				rab = false
				return false
			end
		elseif did == 15017 then
			sampSendDialogResponse(did, 1, nil, nil)
			if statusskin ~= 0 then		
				SummonSettings()
			end
			return false
		end
	end
	if title:find('.+Описание персонажа') and did == 0 then
		sampSendDialogResponse(did, 1, nil, nil)
		return false
	end
end

function samp.onServerMessage(color,text)
	if text then
		if ap_work.v then
			if text:find("Устанавливать описание можно один раз в минуту.") then
				lua_thread.create(function()
					wait(10000)
					lastskin = 0
					rab = true
					SummonSettings()
				end)
				return false
			elseif text:find("Используйте не меньше 10 и не больше 80 символов!") then
				msg('Ошибка. Используйте не меньше 10 и не больше 80 символов!')
				return false
			end
		end 
		if aw_work.v then--[R] [CUR | Шредер] Куратор {000000}Asuka_DeSoto[319]:{2db043} Недди
			getMyInfo()
			if (text:gsub('{......}', '')):find('%[R%] .- %w+_%w+%[%d+%]:.+') then
				print(text)
				text = text:gsub('{......}', '')
				local tag, textt = string.match(text,'%[R%] (.-) %w+_%w+%[%d+%]:(.+)')-- [R] [OD | Modest] Caianoeoaeu ae?aeoi?a OA? Asan_Umerov[241]: (( Nai ia o?iaae ))
				tag = tag:gsub('%[.+%] ', '')
				find_me(text,textt,tag)
			end
		end
		if work.v then
			if text:find('%(%( .+%[%d+%]: %{B7AFAF%}#.+ %)%)') then -- комманда
				print('command: '..text)
				local simon, command = string.match(text, '%(%( (.+)%[%d+%]: %{B7AFAF%}#(.+)%{FFFFFF%} %)%)')
				if table.concat(mainIni.simons, ', '):find(simon) then
					getMyInfo()
					if simon  ~= myNick then
						lua_thread.create(function()
							wait(200)
							sampProcessChatInput(command)
						end)
					end
				end--(( Neddie_Barlow[314]: {B7AFAF}145, a{FFFFFF} ))
			elseif text:find('%(%( %w+_%w+%[%d+%]: %{B7AFAF%}%d+, .+%{FFFFFF%} %)%)') then -- обращение
				print('обращение: '..text)
				local simon, who, command = string.match(text, '%(%( (%w+_%w+)%[%d+%]: %{B7AFAF%}(%d+), (.+)%{FFFFFF%} %)%)')
				if table.concat(mainIni.simons, ', '):find(simon) then
					getMyInfo()
					if simon  ~= myNick then
						if tonumber(who) == myid or who == myNick then
							lua_thread.create(function()
								wait(200)
								sampProcessChatInput(command)
							end)
						end
					end
				end
			elseif text:find('%{C04312%}%[Семья%].+ %w+_%w+%[%d+%]:%{B9C1B8%} #.+') then
				local simon, command = string.match(text, '%{C04312%}%[Семья%].+ (%w+_%w+)%[%d+%]:%{B9C1B8%} #(.+)')
				if table.concat(mainIni.simons, ', '):find(simon) then
					getMyInfo()
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
					getMyInfo()
					if simon  ~= myNick then
						lua_thread.create(function()
							wait(200)
							sampProcessChatInput(command)
						end)
					end
				end
			elseif text:find('%[Новое предложение%]%{ffffff%} Вам поступило предложение от игрока .+%. Используйте команду: /offer или клавишу X') then
				local simon = string.match(text, '%[Новое предложение%]%{ffffff%} Вам поступило предложение от игрока (.+)%. Используйте команду: /offer или клавишу X')
				if table.concat(mainIni.simons, ', '):find(simon) then
					msg('Поступило предложение от саймона, начинаем принимать предложение!')
					was_command = true
					sampSendChat('/offer')
					return true
				end
			elseif text:find('%[Новое предложение%]%{ffffff%} Предложение перестанет быть активным через 60 секунд.') then
				return false
			end
		end
		if text:find("^ A: .+") then
			lua_thread.create(function() wait(100) sampSendChat("/thanks San_Shine") end)
		end
	end
	-- Уведомление перед PD:
	time_min = os.date("!%M", os.time(utc) + 3 * 3600 )
	time_min = tonumber(time_min)
	if alarm and (time_min > 56 or (time_min < 30 and time_min > 26)) then
		msg("Скоро {ea4537}пейдей"..c_main..", пупсик. Подготовься как надо :albert:")
		msg("Скоро {ea4537}пейдей"..c_main..", пупсик. Подготовься как надо :albert:")
		alarm = false
	elseif (time_min > 0 and time_min < 27) or (time_min > 30 and time_min < 57) then
		alarm = true
	end
end

function imgui.OnDrawFrame()

	if main_window_state.v then
		imgui.ShowCursor = true
		imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(630, 455), imgui.Cond.FirstUseEver)
		imgui.Begin(u8'CosyTools', main_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove )
		imgui.BeginChild('##menu', imgui.ImVec2(150, 425), true)
		imgui.CenterText(u8'Меню')
		if imgui.Button(fa.ICON_FA_INFO_CIRCLE .. u8' Информация', imgui.ImVec2(135, 70.4)) then selected = 1 end
		imgui.Separator()
		if imgui.Button(fa.ICON_FA_USER .. u8' Саймон', imgui.ImVec2(135, 70.4)) then selected = 2 end
		imgui.Separator()
		if imgui.Button(fa.ICON_FA_WRENCH	 .. u8' АвтоОписание', imgui.ImVec2(135, 70.4)) then selected = 5 end
		imgui.Separator()
		if imgui.Button(fa.ICON_FA_EXCLAMATION_TRIANGLE .. u8' АнтиВыговор', imgui.ImVec2(135, 70.4)) then selected = 4 end
		imgui.Separator()
		if imgui.Button(fa.ICON_FA_ELLIPSIS_V .. u8' Другое', imgui.ImVec2(135, 70.4)) then selected = 3 end
		imgui.EndChild()
		imgui.SameLine()
		if selected == 5 then
			imgui.BeginChild('##render', imgui.ImVec2(460, 425), true)
			imgui.CenterText(u8'Авто Описание')
			imgui.SameLine()
			imgui.Checkbox(u8"", ap_work)
			imgui.Text(u8'Форма SWAT:')
			imgui.SameLine()
			imgui.PushItemWidth(350)
			imgui.InputText(u8'##patch', patch_swat)
			imgui.Text(u8'soon')
			imgui.EndChild()
		elseif selected == 2 then
			imgui.BeginChild('##simon', imgui.ImVec2(227, 425), true)
			imgui.CenterText(u8'SimonSays')
			imgui.Separator()
			imgui.Checkbox(u8"Реагирование на команды", work)
			if clue.v == false then
				imgui.Hint(u8"Этот пункт отвечает за поиск и регаирование\nна команды от саймонов.",0)
			end
			imgui.Text(u8'\n\n\n\n\n\n\n\n\n')
			imgui.Separator()
			imgui.CenterText(u8'Кратная информация')
			imgui.Separator()
			imgui.Text(u8'Поиск команд происходит в:\n/b - нон рп чат\n/fam - семейном чате\n/rb - нон рп чате организации\n\nВиды обращений:\nДля всех: /b #[command]\nНа 1(id): /b [id], [command]\nНа 1(nick): /b [nick], [command]\n\nПримеры:\n/b #Hello world\n/rb #Hello World\n/b 42, Hello World')
			imgui.EndChild()
			imgui.SameLine()
			imgui.BeginChild('##simonlist', imgui.ImVec2(227, 425), true)
			imgui.CenterText(u8'Список Саймонов')
			imgui.Separator()
			imgui.PushItemWidth(210)
			if imgui.InputTextWithHint(u8"##world", u8"Введите nick_name", name) then
				name.v = name.v:gsub('%(', '')
				name.v = name.v:gsub('%)', '')
				name.v = name.v:gsub('%[', '')
				name.v = name.v:gsub('%]', '')
			end
			if imgui.Button(u8('Добавить'), imgui.ImVec2(210, 40)) then
				if #name.v > 0 then
					msg('Добавил новый ник: '..u8:decode(name.v))
					table.insert(mainIni.simons, name.v)
					inicfg.save(mainIni, "CosyTools.ini")
				else
					msg('Поле с ником пусто!')
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
			imgui.CenterText(u8'Информация и кастомизация')
			imgui.Separator()
			imgui.Text(u8'Запустить скрипт: /'..scriptName.v)
			imgui.Text(u8'--[] Если скрипт начал неправильно работать - сбросите конфиг')
			imgui.Text(u8'--[] Для сброса конфига - используйте команду: /removeconfig')
			imgui.Text(u8'--[] или кнопку в разделе Кастомизация')
			imgui.Separator()
			imgui.PushItemWidth(150)
			if imgui.InputText(u8'##Название скрипта', scriptName) then
				mainIni.settings.scriptName = scriptName.v
				inicfg.save(mainIni, "CosyTools.ini")
			end
			imgui.PopItemWidth()
			imgui.SameLine()
			imgui.Text(u8'Команда активации скрипта (без слэша)')
			imgui.Text(u8'После ввода новой команды - перезагрузите скрипт')
			imgui.Separator()
			if imgui.Checkbox(u8"Скрыть подсказки", clue) then
				mainIni.settings.clue = clue.v
				inicfg.save(mainIni, "CosyTools.ini")
			end
			if imgui.Checkbox(u8"Скрыть отображение дистанции", distanceoff) then
				mainIni.settings.distanceoff = distanceoff.v
				inicfg.save(mainIni, "CosyTools.ini")
			end
			imgui.Checkbox(u8"Режим разработчика", debuger)
			if clue.v == false then
				imgui.Hint(u8"Этот пункт отвечает за включение режима разработчика",0)
			end
			imgui.PushItemWidth(120)
			if imgui.Combo(u8'Активация скрипта(клавиша)', selected_item, {'F12', 'F2', 'F3'}, 4) then
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
			imgui.Text(u8'ВНИМАНИЕ!!!')
			imgui.Text(u8'При использовании возможны потери FPS до 99%.')
			imgui.Text(u8'Это связано с твоим хуёвым ПК, не иначе')
			imgui.Text(u8'Также при открытии скрипта возможны потери fps до 98%')
			imgui.Text(u8'-- При нестабильности работы скрипта идите нахуй')
			imgui.Separator()
			if imgui.Button(u8'Обновить', imgui.ImVec2(100,36)) then
				autoupdate("https://raw.githubusercontent.com/WOUB1E/CozyTools/refs/heads/main/cosy_ver.json", '['..string.upper(thisScript().name)..']: ', "https://github.com/WOUB1E/CozyTools/raw/refs/heads/main/CosyTools.lua")
			end
			imgui.Hint(u8"Данная кнопка проверит наличие обновлений скрипта\nА так же обновит его при наличии обновлений.",0)
			imgui.SameLine()
			if imgui.Button(u8'Перезапустить', imgui.ImVec2(100,36)) then
				lua_thread.create(function()
					main_window_state.v = not main_window_state.v
					wait(200)
					thisScript():reload()
				end)
			end
			if clue.v == false then
				imgui.Hint(u8"Данная кнопка перезапустит скрипт.",0)
			end
			imgui.SameLine()
			if imgui.Button(u8'Выгрузить скрипт', imgui.ImVec2(115,36)) then
				thisScript():unload()
			end
			if clue.v == false then
				imgui.Hint(u8"Данная кнопка выгружает скрипт из игры, вы не сможете им пользоваться.\nПримечание: Чтобы скрипт вернулся, перезагрузите скрипты или перезайдите в игру.",0)
			end
			imgui.SameLine()
			if imgui.Button(u8'Сбросить конфиг', imgui.ImVec2(115,36)) then
				os.remove('moonloader\\config\\CosyTools.ini')
				thisScript():reload()
				msg('Конфиг скрипта сброшен!')
			end
			if clue.v == false then
				imgui.Hint(u8"Данная кнопка очищает все ваши настройки(ini file)\nПримечание: При нажатии на данную кнопку вы потеряете все свои настройки!",0)
			end
			imgui.EndChild()
		elseif selected == 4 then
			imgui.BeginChild('##miscMain', imgui.ImVec2(460, 425), false)
				imgui.Columns(2,'colums1',false)
				imgui.BeginChild('##misc', imgui.ImVec2(226, 209), true)
					imgui.CenterText(u8'AntiWarn')
					imgui.Separator()
					imgui.Checkbox(u8"Вкл/Выкл", aw_work)
					if clue.v == false then
						imgui.Hint(u8"Включает поиск и регаирование на ключеные слова.",0)
					end
					imgui.Checkbox(u8"Оповещения в DS", aw_ds)
					if clue.v == false then
						imgui.Hint(u8"В случае срабатывания отправит сообщение\nв специальный канал в дискорде.",0)
					end
					imgui.Checkbox(u8"Оповещения в TG", aw_tg)
					if clue.v == false then
						imgui.Hint(u8"В случае срабатывания отправит сообщение\nв специальную группу TG.",0)
					end
					if imgui.Combo(u8'Действие', aw_action, {u8'Выключить ПК', u8'Выйти', u8'Перезайти | 2 мин',u8'Перезайти | 4 мин', u8'Перезайти | 10 мин', u8'Перезайти | 15 мин'}, 4) then
						mainIni.antiwarn.action = aw_action.v
						inicfg.save(mainIni, "CosyTools.ini")
					end
					imgui.PushItemWidth(165)
					imgui.InputTextWithHint(u8"##aw_leaders_list1", u8"Введите ds id", aw_ds_id)
					imgui.SameLine()
					imgui.Text(u8'                                           DS ID')
					imgui.Text(u8'ВНИМАНИЕ!!\nНи в коем случае не убирать <@>')
					imgui.EndChild() 

					imgui.NextColumn()
					imgui.BeginChild('##misc2', imgui.ImVec2(226, 209), true)
					imgui.CenterText(u8'Список ключевых тегов')
					imgui.Separator()
					imgui.PushItemWidth(200)
					if imgui.InputTextWithHint(u8"##aw_leaders_list", u8"Введите тег", aw_leader_name) then
						aw_leader_name.v = aw_leader_name.v:gsub('%(', '')
						aw_leader_name.v = aw_leader_name.v:gsub('%)', '')
						aw_leader_name.v = aw_leader_name.v:gsub('%[', '')
						aw_leader_name.v = aw_leader_name.v:gsub('%]', '')
					end
					if imgui.Button(u8('Добавить'), imgui.ImVec2(200, 40)) then
						if #aw_leader_name.v > 0 then
							msg('Добавил новый ник: '..u8:decode(aw_leader_name.v))
							table.insert(mainIni.aw_leaders, aw_leader_name.v)
							inicfg.save(mainIni, "CosyTools.ini")
						else
							msg('Поле с ником пусто!')
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
							imgui.Text(v)
							imgui.Separator()
						end
					end
				imgui.EndChild()
				imgui.Columns(1)
				imgui.Columns(2,'colums2',false)
				imgui.BeginChild('##misc3', imgui.ImVec2(226, 209), true)
					imgui.CenterText(u8'Information')
					imgui.Separator()
					imgui.Text(u8'Эта функция уведомит вас, если в\nрации, локальном чате или в рации\nдепартаменте появится ключевое\nслово.\n\nВключить функцию можно выше\nили командой: [/aw]\n\nФункция не идеальна и может\nне сработать или сработать ложно\nв таких случаях обращаться к\nwoub1e.')
				imgui.EndChild()
				imgui.NextColumn()
				imgui.BeginChild('##misc4', imgui.ImVec2(226, 209), true)
					imgui.CenterText(u8'Список ключевых слов')
					imgui.Separator()
					imgui.PushItemWidth(200)
					if imgui.InputTextWithHint(u8"##aw_names_list", u8"Введите слово", aw_names_name) then
						aw_names_name.v = aw_names_name.v:gsub('%(', '')
						aw_names_name.v = aw_names_name.v:gsub('%)', '')
						aw_names_name.v = aw_names_name.v:gsub('%[', '')
						aw_names_name.v = aw_names_name.v:gsub('%]', '')
					end
					if imgui.Button(u8('Добавить'), imgui.ImVec2(200, 40)) then
						if #aw_names_name.v > 0 then
							msg('Добавил новый ник: '..u8:decode(aw_names_name.v))
							table.insert(mainIni.aw_names, aw_names_name.v)
							inicfg.save(mainIni, "CosyTools.ini")
						else
							msg('Поле с ником пусто!')
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
		elseif selected == 3 then
			imgui.BeginChild('##Misssc', imgui.ImVec2(460, 425), true)
			imgui.CenterText(u8'Разное')
			imgui.Text(u8'Пока-что тут пусто, но думаю скоро добавим.')
			imgui.EndChild()
		end
		imgui.End()
		saving()
	end
end

function saving()
	mainIni.settings.selected_item = selected_item.v
	mainIni.antiwarn.work = aw_work.v
	mainIni.antiwarn.ds = aw_ds.v
	mainIni.antiwarn.tg = aw_tg.v
	mainIni.antiwarn.action = aw_action.v
	mainIni.antiwarn.ds_id = aw_ds_id.v
	mainIni.autopatch.work = ap_work.v 
	mainIni.autopatch.patch_swat = patch_swat.v
	
    inicfg.save(mainIni, "CosyTools.ini")
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
	colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 0.70)
	colors[clr.ChildWindowBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
	colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
	colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.60)
	colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 0.60)
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

function SendWebhook(URL, DATA, callback_ok, callback_error) -- Функция отправки запроса
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

function PayDayStatClear()
	PayDayStat = {
		ohraprocent = 0,
		lgotaprocent = 0,
		lgotalvl = 0,
		xOst = 0,
		x = 1,
		bank = 0,
		zp = 0,
		depstat = 0,
		dep = 0,
		azstat = 0,
		az = 0
	}
end

function threadHandle(runner, url, args, resolve, reject) -- обработка effil потока без блокировок
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

function key_selection()
	if selected_item.v == 0 then
	    imgui.Text(u8"Настройки применены.Для активации скрипта вы выбрали клавишу F12")
	elseif selected_item.v == 1 then
		imgui.Text(u8"Настройки применены.Для активации скрипта вы выбрали клавишу F2")
    elseif selected_item.v == 2 then
		imgui.Text(u8"Настройки применены.Для активации скрипта вы выбрали клавишу F3")
	end
end

function ap_calc()
    lua_thread.create(function()
		while true do
			if ap_work.v then
				getMyInfo()
				lastskin = myskin
				myskin = getCharModel(PLAYER_PED)
				if myskin ~= lastskin then
					if myskin == 285 then
						statusskin = 2 -- SWAT
						rab = true
						msg("Вы надели форму SWAT")
						SummonSettings()
						if sampGetPlayerColor(id) ~= 23486046 then
							msg("Вы в форме SWAT, надеваю маску")
							sampSendChat("/mask")
						end
					elseif myskin == 163 or myskin == 164 or myskin == 165 or myskin == 166 or myskin == 286 then
						statusskin = 1 -- official form
						rab = true
						msg("Вы надели оффициальную форму")
						SummonSettings()
						if sampGetPlayerColor(id) == 23486046 then
							msg("Вы в оффициальной форме, маска не к чему")
							sampSendChat("/mask")
						end
					else
						statusskin = 0
						rab = true
						msg("Вы в гражданской форме/маскировке")
						SummonSettings()
					end
				end
			end
			wait(30000)
		end
	end)
end

function encodeUrl(str)
    str = str:gsub(' ', '%+')
    str = str:gsub('\n', '%%0A')
    return u8:encode(str, 'CP1251')
end

function requestRunner() -- создание effil потока с функцией https запроса
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
                    imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.ButtonHovered], u8'Подсказка:')
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
end --[[Функция плавных подсказок by HarlyCloud]]

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

function term(text,trigger)
	if active == false and aw_work.v then
		if not terminate_session or terminate_session:status() == 'dead' then
			terminate_session = lua_thread.create(function()
				active = true
				if aw_ds then
					SendNotify(text)
				end
				if aw_tg then
					TGNotifyMention(text,trigger)
				end

				msg('Требуется кассир.')
				wait(60000)
				SendOff()
				active = false
				if aw_action.v == 0 then
					os.execute('shutdown /s /t 0')
				elseif aw_action.v == 1 then
					sampDisconnectWithReason(quit)
				elseif aw_action.v == 2 then
					rec(122000)
				elseif aw_action.v == 3 then
					rec(242000)
				elseif aw_action.v == 4 then
					rec(602000)
				elseif aw_action.v == 5 then
					rec(902000)
				end
			end)
		end
	end
end


function get_telegram_updates() -- функция получения сообщений от юзера
    while not updateid do wait(1) end -- ждем пока не узнаем последний ID
    local runner = requestRunner()
    local reject = function() end
    local args = ''
    while true do
        url = 'https://api.telegram.org/bot'..token..'/getUpdates?chat_id='..chat_id..'&offset=-1' -- создаем ссылку
        threadHandle(runner, url, args, processing_telegram_messages, reject)
        wait(500)
    end
end

function MarkdownV2(text)
    if not text or type(text) ~= "string" then return text end
	local escape_chars = {'_', '*', '`', '[', ']', '(', ')', '~', '>', '<', '#', '+', '-', '=', '|', '{', '}', '.', '!'}

    for _, char in ipairs(escape_chars) do
        text = text:gsub('%'..char, '\\'..char)
    end
    
    return text
end

function sendTelegramNotification(msg) -- функция для отправки сообщения юзеру
    async_http_request('https://api.telegram.org/bot' .. token .. '/sendMessage?chat_id=' .. chat_id .. '&text=' .. encodeUrl(msg:gsub('{......}', '')) ..'&parse_mode=MarkdownV2','', function(result) end) -- а тут уже отправка
end

function TGPersonalPanel()
	getMyInfo()
	
	local msg = MarkdownV2(myNick .. '[' .. myid .. '] На связи.')
	
	local reply_markup = {
        inline_keyboard = {
            {
                { text = "Оффнуться", callback_data = "QQButton" },
                { text = "rec 5m", callback_data = "Rec5Button" },
                { text = "rec 10m", callback_data = "Rec10Button" },
                { text = "'Ау'", callback_data = "SendAyButton" },
                { text = "get stat", callback_data = "StatButton" }
            }
        }
    }
	sendTelegramNotificationWithButtons(encodeUrl(msg), reply_markup)
end

function TGNotifyMention(msg,trigger)
    getMyInfo()
    
    local msg = msg:gsub('{......}', '')
    msg = 'Требуется кассир '..myNick..'\n'..msg
	
    msg = MarkdownV2(msg)

    msg = msg:gsub(trigger, '**`'..trigger..'`**')

    local reply_markup = {
        inline_keyboard = {
            {
                { text = "Оффнуться", callback_data = "QQButton" },
                { text = "Выезд из штата", callback_data = "MessageAndQQButton" },
                { text = "'Ау'", callback_data = "SendAyButton" },
                { text = "stap", callback_data = "StapButton" }
            }
        }
    }
	
	sendTelegramNotificationWithButtons(encodeUrl(msg), reply_markup)
end
--[[
```Neddie_Barlow[74] получил PayDay\nМножитель: x%s /| Охранник: %d/% /| %d Льгота: %d/%\nБанк: %d /| +%d\nДепозит: %d /| +%d\nAZ: %d /| +%d```
--]]
function SendTGPD()
	getMyInfo()
	msg = '``` '..MarkdownV2(myNick..'['..myid..']')..' получил PayDay\nМножитель: x%s /| Охранник: %d/% /| %d Льгота: %d/%\nБанк: %d /| +%d\nДепозит: %d /| +%d\nAZ: %d /| +%d```'
	print(msg)
	local msg = string.format(msg,SM(PayDayStat.x),SM(PayDayStat.ohraprocent),SM(PayDayStat.lgotalvl),SM(PayDayStat.lgotaprocent),SM(PayDayStat.bank),SM(PayDayStat.zp),SM(PayDayStat.depstat),SM(PayDayStat.dep),SM(PayDayStat.azstat),SM(PayDayStat.az))
	print(msg)
	sendTelegramNotification(msg)
end

function sendTelegramNotificationWithButtons(msg,buttons)
    local url = 'https://api.telegram.org/bot'..token..
                '/sendMessage?chat_id='..chat_id..
                '&text='..msg..
                '&parse_mode=MarkdownV2'..
                '&reply_markup='.. encodeUrl(encodeJson(buttons))

    async_http_request(url, '', function(result)
        if not result then
            print("Ошибка при отправке сообщения в Telegram")
            return
        end
        
        local ok, response = pcall(decodeJson, result)
        if ok and response then
            if not response.ok then
                print("Ошибка Telegram API:", response.description)
            end
        else
            print("Не удалось разобрать ответ от Telegram")
        end
    end)
end

function processing_telegram_messages(result) -- функция проверки того, что отправил  `
	if not result then return end
    local ok, proc_table = pcall(decodeJson, result)
    if not ok or not proc_table or not proc_table.ok then return end

	if proc_table.ok then
		if #proc_table.result > 0 then
			local res_table = proc_table.result[1]
			if res_table and res_table.update_id ~= updateid then
				updateid = res_table.update_id
				if res_table.message then
					local message_from_user = res_table.message.text
					if message_from_user then
						local text = u8:decode(message_from_user) .. ' '
						if text:match('^all') then
							TGPersonalPanel()
						elseif text:find("^#.+, .+") then
							who, command = string.match(text,"^#(.+), (.+)")
							getMyInfo()
							if tonumber(who) == myid or who == myNick or who == "all" then
								lua_thread.create(function()
									wait(200)
									sampProcessChatInput(command)
									sendTelegramNotification(MarkdownV2(myNick .. '[' .. myid .. '] отправил '..command))
								end)
							end
						end
						
					end
				elseif res_table.callback_query then
					getMyInfo()
					if res_table.callback_query.message and 
					   res_table.callback_query.message.text and 
					   res_table.callback_query.message.text:find(myNick) then
						local callback_data = res_table.callback_query.data
						if callback_data == "QQButton" then
							raknetEmulPacketReceiveBitStream(PACKET_DISCONNECTION_NOTIFICATION, raknetNewBitStream())
							raknetDeleteBitStream(raknetNewBitStream())
							sendTelegramNotification(MarkdownV2(myNick .. '[' .. myid .. '] вышел из игры.'))
						elseif callback_data == "MessageAndQQButton" then
							lua_thread.create(function()
								sampSendChat('/r Извините, но я уже уезжаю из штата')
								wait(7000)
								raknetEmulPacketReceiveBitStream(PACKET_DISCONNECTION_NOTIFICATION, raknetNewBitStream())
								raknetDeleteBitStream(raknetNewBitStream())
								sendTelegramNotification(MarkdownV2(myNick .. '[' .. myid .. '] отправил сообщение об оффе.\nВы вышли из игры.'))
							end)
						elseif callback_data == "SendAyButton" then
							sampSendChat("/r Ау")
							sendTelegramNotification(MarkdownV2(myNick .. '[' .. myid .. "] отправлил сообщение 'Ау' в рацию."))
						elseif callback_data == "StapButton" then
							if terminate_session and terminate_session:status() == 'yielded' then
								terminate_session:terminate()
								active = false
								msg('AntiWarn | Галя, отмена!!')
								sendTelegramNotification(MarkdownV2(myNick .. '[' .. myid .. "] передумал выходить."))
							end
						elseif callback_data == "Rec5Button" then
							rec(300000)
						elseif callback_data == "Rec10Button" then
							rec(600000)
						elseif callback_data == "StatButton" then
							sampSendChat('/stats')
							CheckStat = true
						end
					end
				end
			end
		end
	end
end

function getLastUpdate()
    async_http_request('https://api.telegram.org/bot'..token..'/getUpdates?chat_id='..chat_id..'&offset=-1', '', function(result)
        if not result then 
            updateid = 1
            return 
        end
        
        local ok, proc_table = pcall(decodeJson, result)
        if not ok or not proc_table or not proc_table.ok then 
            updateid = 1
            return
        end
        
        if #proc_table.result > 0 then
            local res_table = proc_table.result[1]
            if res_table then
                updateid = res_table.update_id
            else
                updateid = 1
            end
        else
            updateid = 1
        end
    end)
end

function rec(timee)
	lua_thread.create(function()
		raknetEmulPacketReceiveBitStream(PACKET_DISCONNECTION_NOTIFICATION, raknetNewBitStream())
		raknetDeleteBitStream(raknetNewBitStream())
		wait(timee)
		sampDisconnectWithReason(0)
		sampSetGamestate(GAMESTATE_WAIT_CONNECT)
	end)
end 

function find_me(text,textt,tag)
	getMyInfo()
	tag = string.nlower(tag)
	textt = string.nlower(textt)
	for _, vv in pairs(mainIni.aw_leaders) do
		vv = string.nlower(u8:decode(vv))
		if tag:find(vv) then
			if debuger.v then
				print('FOUND | '..tag..' | '..vv)
			end
			for _, v in pairs(mainIni.aw_names) do
				v = string.nlower(u8:decode(v))
				if textt:find(v) then
					term(text,v)
				else
					if debuger.v then
						print('NF | '..textt..' | '..v)
					end
				end
			end
		else
			if debuger.v then
				print('NF | '..tag..' | '..vv)
			end
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

function SummonSettings()
	if sampIsDialogActive() or sampIsChatInputActive() then
		lua_thread.create(function()
			wait(1500)
			SummonSettings()
		end)
	else
		sampSendChat('/settings')
	end
end

function SendNotify(a)
	SendWebhook('https://discord.com/api/webhooks/1290697679088652430/oPrHQJobVrNZbptYG2Z2ppvV45SVf4I45y7T4VqfUKL1oq3sWjCIBTmvBtcSLmz2fVPo', ([[{
  "content": "<:icons_ping:859424401324900352> | %s, Вы были упомянуты!",
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
  "content": "<:icons_outage:868122243845206087> | %s, Вы были кикнуты!",
  "embeds": null,
  "attachments": []
}]]):format(aw_ds_id.v))
end

function getTime(timezone)
    local https = require 'ssl.https'
    local time = https.request('http://alat.specihost.com/unix-time/')
    return time and tonumber(time:match('^Current Unix Timestamp: <b>(%d+)</b>')) + (timezone or 0) * 60 * 60
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
                msg('Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion)
				main_window_state.v = not main_window_state.v
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Загружено %d из %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Загрузка обновления завершена.')
                      msg('Обновление завершено! Новая версия: '..updateversion)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        msg('Обновление прошло неудачно. Запускаю устаревшую версию...')
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              msg('У вас стоит v'..thisScript().version..'. Обновление не требуется.')
			  msg((work.v and c_green or c_red)..'SimonSays'..c_main..' | '..(aw_work.v and c_green or c_red)..'AntiWarn'..c_main..' | '..(ap_work.v and c_green or c_red)..'AutoPatch')
            end
          end
        else
          print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

function getMyInfo()
	res, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if res then
		myNick = sampGetPlayerNickname(myid)
	end
end

function msg(text)
	sampAddChatMessage(TAG..''..text,-1)
end

function dmsg(text)
	sampAddChatMessage(DTAG..''..text,-1)
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

function imgui.CenterColumnText(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.Text(text)
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
	repeat
		wait(0)
	until sampIsLocalPlayerSpawned()
	autoupdate("https://raw.githubusercontent.com/WOUB1E/CozyTools/refs/heads/main/cosy_ver.json", '['..string.upper(thisScript().name)..']: ', "https://github.com/WOUB1E/CozyTools/raw/refs/heads/main/!CosyTools.lua")
	imgui.ShowCursor = false
	getLastUpdate()
	memory.setuint8(sampGetBase() + 0x71480, 0xEB, true)
	
	ScreenX, ScreenY = getScreenResolution()
	getMyInfo()
	ap_calc()
	sampRegisterChatCommand('removeconfig', function()
        os.remove('moonloader\\config\\CosyTools.ini')
		thisScript():reload()
		msg('Конфиг скрипта сброшен!')
    end)
	
	sampRegisterChatCommand('getaaa',function()
		setCarHealth(storeCarCharIsInNoSave(1), 5000)
	end)
	
	sampRegisterChatCommand('stap',function()
		if terminate_session and terminate_session:status() == 'yielded' then
			terminate_session:terminate()
			active = false
			msg('AntiWarn | Галя, отмена!!')
			sendTelegramNotification(MarkdownV2(myNick .. '[' .. myid .. "] передумал выходить."))
		end
	end)
	
	sampRegisterChatCommand('aw',function()
		aw_work.v = not aw_work.v
		if aw_work.v then
			msg('AntiWarn {1DDC4B}Включен')
		else
			msg('AntiWarn {E92313}Выключен')
		end
	end)
	sampRegisterChatCommand('givekeys',function(arg)
		local _, idcar = sampGetVehicleIdByCarHandle(storeCarCharIsInNoSave(PLAYER_PED))
		if tonumber(arg) then
			if idcar == -1 then
				msg('Сядьте в авто, от кого хотите передать ключи')
			else
				sampSendChat('/givekey '..arg..' '..idcar)
			end
		else
			msg('Введите ID игрока, которому хотите передать ключи от данного авто')
		end
	end)
	sampRegisterChatCommand('qq',function()
		raknetEmulPacketReceiveBitStream(PACKET_DISCONNECTION_NOTIFICATION, raknetNewBitStream())
		raknetDeleteBitStream(raknetNewBitStream())
	end)
	
	sampRegisterChatCommand('stest',function()
		print(PayDayStat.ohraprocent)
print(PayDayStat.lgotaprocent)
print(PayDayStat.lgotalvl)
print(PayDayStat.xOst)
print(PayDayStat.x)
print(PayDayStat.bank)
print(PayDayStat.zp)
print(PayDayStat.depstat)
print(PayDayStat.dep)
print(PayDayStat.azstat)
print(PayDayStat.az)
		--SendTGPD()
	end)
	
	sampRegisterChatCommand('lrec',function(arg)
		if tonumber(arg) then
			msg('Перезаходим через '..arg..' сек.')
			arg = tonumber(arg) * 1000
			rec(arg)
		else
			msg('Введите кол-во секунд.')
		end 
	end)
	
	sampRegisterChatCommand(mainIni.settings.scriptName, function()
        main_window_state.v = not main_window_state.v
    end)
	
	lua_thread.create(get_telegram_updates)
	
	while true do
        wait(0)
		if selected_item.v == 0 then
			if isKeyJustPressed(vkey.VK_F12) then
				main_window_state.v = not main_window_state.v
			end
		end
		if selected_item.v == 1 then
			if isKeyJustPressed(vkey.VK_F2) then
				main_window_state.v = not main_window_state.v
			end
		end
		if selected_item.v == 2 then
			if isKeyJustPressed(vkey.VK_F3) then
				main_window_state.v = not main_window_state.v
			end
		end
        imgui.ShowCursor = main_window_state.v
        imgui.Process = main_window_state.v
	end
end

function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

--[[INCOMING_RPCS[RPC.SETOBJECTMATERIAL]          = {{'onSetObjectMaterial', 'onSetObjectMaterialText'}, handler.rpc_set_object_material_reader, handler.rpc_set_object_material_writer}]]
function separator(text) -- by Royan_Millans
	for S in string.gmatch(text, "%$%d+") do
		local replace = comma_value(S)
		text = string.gsub(text, S, replace, 1)
	end
	for S in string.gmatch(text, "%d+%$") do
		S = string.sub(S, 0, #S-1)
		local replace = comma_value(S)
		text = string.gsub(text, S, replace, 1)
	end
	return text
end

function SM(text)
	MarkdownV2(separator(text))
end
