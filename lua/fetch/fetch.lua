--  License: MIT
--[[
		Copyright 2021 NekOware

		Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--]]
--[[
		NOTE:
			This script only works on windows.
--]]

-- //  Cool Setting Variables

local width_min = 8


-- // Utility functions.

  -- TODO: Debloat this table
local fixStrTbl = {['Ç']='\128',['ü']='\129',['é']='\130',['â']='\131',['ä']='\132',['à']='\133',['å']='\134',['ç']='\135',['ê']='\136',['ë']='\137',['è']='\138',['ï']='\139',['î']='\140',['ì']='\141',['Ä']='\142',['Å']='\143',['É']='\144',['æ']='\145',['Æ']='\146',['ô']='\147',['ö']='\148',['ò']='\149',['û']='\150',['ù']='\151',['ÿ']='\152',['Ö']='\153',['Ü']='\154',['ø']='\155',['£']='\156',['Ø']='\157',['×']='\158',['ƒ']='\159',['á']='\160',['í']='\161',['ó']='\162',['ú']='\163',['ñ']='\164',['Ñ']='\165',['ª']='\166',['º']='\167',['¿']='\168',['®']='\169',['¬']='\170',['½']='\171',['¼']='\172',['¡']='\173',['«']='\174',['»']='\175',['░']='\176',['▒']='\177',['▓']='\178',['│']='\179',['┤']='\180',['Á']='\181',['Â']='\182',['À']='\183',['©']='\184',['╣']='\185',['║']='\186',['╗']='\187',['╝']='\188',['¢']='\189',['¥']='\190',['┐']='\191',['└']='\192',['┴']='\193',['┬']='\194',['├']='\195',['─']='\196',['┼']='\197',['ã']='\198',['Ã']='\199',['╚']='\200',['╔']='\201',['╩']='\202',['╦']='\203',['╠']='\204',['═']='\205',['╬']='\206',['¤']='\207',['ð']='\208',['Ð']='\209',['Ê']='\210',['Ë']='\211',['È']='\212',['ı']='\213',['Í']='\214',['Î']='\215',['Ï']='\216',['┘']='\217',['┌']='\218',['█']='\219',['▄']='\220',['¦']='\221',['Ì']='\222',['▀']='\223',['Ó']='\224',['ß']='\225',['Ô']='\226',['Ò']='\227',['õ']='\228',['Õ']='\229',['µ']='\230',['þ']='\231',['Þ']='\232',['Ú']='\233',['Û']='\234',['Ù']='\235',['ý']='\236',['Ý']='\237',['¯']='\238',['´']='\239',['≡']='\240',['±']='\241',['‗']='\242',['¾']='\243',['¶']='\244',['§']='\245',['÷']='\246',['¸']='\247',['°']='\248',['¨']='\249',['·']='\250',['¹']='\251',['³']='\252',['²']='\253',['■']='\254'}

local function fixStr(str)
	return''..str:gsub("([%z\1-\127\194-\244][\128-\191]*)",function(c)return(fixStrTbl[c]or c)end)
end

local function errorBadOS()
	print(
		'>                                                                     \n'..
		'> This software has been made for windows systems only.               \n'..
		'> It will not work as intended if used on any other operating system. \n'..
		'>                                                                     '
	)
	os.exit(255)
end

-- //  Colour stuff. (ANSI 3/4 bit colour codes. https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit)

local rcol='\27[m'

local col = {
	black  = '30',
	yellow = '33',
	cyan   = '36',
	white  = '37',
	res    = ''
}

local ccol = {
	title = '37;40',
	edges = '36;40',
	gapch = '36;40',
	usern = '36;40',
	hostn = '36;40',
	unhns = '31;40'
}

local colbg = {
	black    = '40' ,
	bred     = '101',
	byellow  = '103',
	bgreen   = '102',
	bbgreen   = '102;92',
	bcyan    = '106',
	bblue    = '104',
	bmagenta = '105',
	res      = ''
}

local function colf(cols)return('\27['..cols..'m')end

for i,v in pairs(col)  do col[i]  =colf(v)end
for i,v in pairs(ccol) do ccol[i] =colf(v)end
for i,v in pairs(colbg)do colbg[i]=colf(v)end


-- //  Get Most System Info

local po = io.popen('echo Username:                  %username% && systeminfo','r')
local sysinfo=po:read('*all')
po:close()

-- Check if return has 5 or more lines. if not then assuming script not running on windows.
if (function(h)local _,n=h:gsub('\n','')return(n)end)(sysinfo)<5 then errorBadOS()end

-- Remove most garbage from returned info.
local sysinf = ('\n'..sysinfo..'\n')
	:gsub('\r\n','\n')
	:gsub('(Processor%(s%):%s+).-\n%s+%[%d+%]: ','%1')
	:gsub('\n[^\n]+\n%s+[^\n]+\n%s+[^\n]+\n.-\n(%S)','\n%1')
	:gsub('\n[^:]+:%s+\n','\n')
	:gsub('(\n[^\n]+:)(%s)',function(n,s)
		local v1,c1 = n:gsub('[ %-]','_'):gsub(':_','_')
		local v2,c2 = v1:gsub('%(s%)','')
		return v2:lower()..s..(' '):rep(c1+(c2*3))
	end)
	:gsub('^[\n]+','')
	:gsub('[\n]+$','')

local got = {}
for i in sysinf:gmatch('([^\n]+)')do --p(i)
	local vnam, vval=i:match('^([^:]+):%s+(.-)$')
	got[vnam]=vval
end


-- //  Get System Uptime [var -> upt]

local ut={}
local po=io.popen('powershell -Command "\"$((Get-Date) - ([Management.ManagementDateTimeConverter]::ToDateTime((Get-WmiObject Win32_OperatingSystem).LastBootUpTime)))\""')
for i in po:lines()do
	if i:gsub('[\1-\32]','')~=''then
		ut[i:lower():gsub(' ',''):match('^[^:]+')]=tonumber(i:lower():gsub(' ',''):match('[^:]+$'))
	end
end
po:close()

local upt = ''
for i,v in pairs{'days','hours','minutes','seconds'}do
	upt=upt..(ut[v]and ut[v]>0 and ut[v]..v:sub(1,1)..', ' or'')
end
upt=upt:sub(1,-3)


-- //  Get CPU Prod Name

local cpu = (function(s)local _=io.popen(s)local __=_:read('*all')_:close()return(__)end)('wmic cpu get name')
	:gsub('\r\n','\n')
	:gsub('%s+\n','\n')
	:match('\n([^\n]+)')
	:gsub('%(%a+%)','')
	:gsub('@.-$','')
	:gsub(' CPU.-$','')
	:gsub(' APU.-$','')
	:gsub('^(%S+)(.-)$',function(brand,thing)
		if brand=='Intel'then return(brand..thing)
		else
			return''..(brand..thing):gsub('%s%S+%s%S+$','')
		end
	end)


-- //  Get Hostname (the one in systeminfo is all caps thus inaccurate)

local hostname = (function(s)local _=io.popen(s)local __=_:read('*all')_:close()return(__)end)('powershell -Command "$(hostname)"')
	:gsub('\r\n','\n')
	:gsub('^[\n]+','')
	:gsub('[\n]+$','')


-- //  Fix unruly values.

got.username=got.username:gsub('^%s+',''):gsub('%s+$','')
local memform = got.total_physical_memory:match('%S+$')

got.total_physical_memory    = got.total_physical_memory     :gsub('(%d)\255(%d)','%1%2')
got.available_physical_memory= got.available_physical_memory :gsub('(%d)\255(%d)','%1%2')
--p(got.total_physical_memory:match('^%S+'),got.available_physical_memory:match('^%S+'),memform)

-- //  Make cool thing to display to user

local disp = {
	ccol.usern..(got.username or'??')..rcol..ccol.unhns..'@'..rcol..ccol.hostn..(hostname or'??')..rcol..colbg.black,
	'os ~ '..got.os_name:match('%s(.-)$'),
	'up ~ '..upt,
	'cpu ~ '..cpu,
	'mem ~ '..tostring(tonumber(got.total_physical_memory:match('^%S+'))-tonumber(got.available_physical_memory:match('^%S+')))..memform..'/'..got.total_physical_memory:match('^%S+')..memform,
	'kern ~ '..got.os_version:match('^%S+'),
	'',
	colbg.bred..'  '..colbg.byellow..'  '..colbg.bbgreen..'~ '..colbg.res..colbg.bcyan..'  '..colbg.bblue..'  '..colbg.bmagenta..'  '..colbg.black
} -- The '~ ' in the last line is used to allign the colours with the details.


-- //  Make cool width so they would look nicer.

local disg = #got.username
local disl = 0
for i=2,#disp do
	if #disp[i]>0 and disp[i]:gsub('\27%[[0-9;]-m','')~='' then
		local ch=#disp[i]:gsub('\27%[[0-9;]-m',''):match('^[^~]+')
		disg=(ch>disg and ch or disg)
	end
end
disg=(width_min>disg and width_min or disg)

-- Adds colours to titles/seperators

for i=2,#disp-1 do
	disp[i]=disp[i]:gsub('^([^~]+)(~)',ccol.title..'%1'..rcol..colbg.black..ccol.gapch..'%2'..rcol..colbg.black)
end

-- Adds starter spaces and counts lengths

disp[1]=(' '):rep(disg):sub(#got.username+1)..disp[1]
for i=2,#disp do
	if disp[i]:gsub('\27%[[0-9;]-m','')~='' then
		disp[i] = (' '):rep(disg):sub(#disp[i]:gsub('\27%[[0-9;]-m',''):match('^[^~]+')+1)..disp[i]
		local dtem = #disp[i]:gsub('\27%[[0-9;]-m','')
		disl=( dtem>disl and dtem or disl )
	end
end

-- Does the spacing.

disp[1]=disp[1]..(' '):rep(disl):sub(#disp[1]:gsub('\27%[[0-9;]-m','')+1)
for i=2,#disp do
	disp[i] = disp[i]..(' '):rep(disl):sub(#disp[i]:gsub('\27%[[0-9;]-m','')+1)
end

-- Adding 1 empty to first and last positions

local tempd = {}
table.insert(tempd,(' '):rep(disl))
for i=1,#disp do
	table.insert(tempd,disp[i])
end
table.insert(tempd,(' '):rep(disl))
disp  = tempd
tempd = nil

-- Adding the colours.

for i=2,(#disp)-1 do
	disp[i] = ccol.edges..'│ '..colbg.res..colbg.black..disp[i]..colbg.res..ccol.edges..' │'..colbg.res
end

local c=#disp
disp[1] = ccol.edges..'┌─'..disp[1]:gsub('%s','─')..'─┐'..col.res
disp[c] = ccol.edges..'└─'..disp[c]:gsub('%s','─')..'─\217'..col.res

-- //  Output details to user

io.write(fixStr(('\n\n'..table.concat(disp,'\n')..'\n\n'):gsub('\n','\n  ')..'\n'))

