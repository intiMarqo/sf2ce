
--Modo IntiMarqo v1.0
--SF2ce Modo entrenamiento para Fightcade2  
--Desarrollado por : intiMarqo
--06/09/2021
--https://www.youtube.com/channel/UC86un-0H23nsI14ZBXS23EQ
--https://www.twitch.tv/intimarqo

	--> 320x, 240y --cmd
	--> 384x, 224y --lua
local v=true	
local t={}
local t_juego ={
			 juego_contador_entrada=0
			,ind_arena=0X00FF803A
		}
local t_color = { 
		on1  = 0xFF0000FF,
		on2  = 0x000000FF,
		off1 = 0xFFFFFFFF,
		off2 = 0x000000FF
	}

local K_N = 0x000000FF
local K_R = 0XFF0000FF
local K_A = 0X0000FFFF
local K_B = 0XFFFFFFFF
	
local t_jugador={
	  nro_jugador=2
	 ,ind_prepara_counter=0
	 ,ind_ejecuta_counter=0
     ,nro_secuencia_desde=1
	 ,ind_recibeGolpe = 0x00FF8708
	 ,ind_inhabilitado= 0x00FF86C1
	 ,ind_orientacion = 0x00FF857C
	 ,ind_mareo 	  = 0x00FF871D
	 ,ind_aire		  = 0X00FF8C49
	 ,ind_contrincante_ejecutaGolpe=0x00FF8549
	 ,ind_contrincante_agachado    =0x00FF83C1
	 ,ind_char        =0x00FF894F
}
local accion_p2_BC={
              secuenciaConterProgramado= {{"Back"}}
			 ,secuenciaAtaqueProgramado_indice=1
			 ,secuenciaConvertida = {}
			 ,secuenciaDefault=""
			 ,nro_repeticion_accion=30
			 ,aux_contador_local=0
	    }
local accion_p2_BCA={
			  secuenciaAtaqueProgramado= {{"Back"}}
			 ,secuenciaAtaqueProgramado_indice=1
			 ,secuenciaConterProgramado= {{"Forward"},{"Down"},{"Forward","Down","Weak Punch"}}
			 ,secuenciaConterProgramado_indice=1
		     ,secuenciaConvertida      = {}
		}
function accion_salta()
		t_movimientos = {}
		t_movimientos["P2 Up"]=true
		joypad.set(t_movimientos)
end
function accion_saltaPatea()
	t_movimientos = {}
	v_indicador_aire= memory.readbyte(t_jugador.ind_aire)
	v_orientacion   = memory.readbyte(t_jugador.ind_orientacion)
	v_char          = memory.readbyte(t_jugador.ind_char)
	print(v_indicador_aire)
	t_movimientos["P"..t_jugador.nro_jugador.." Up"]=true
	
	if v_orientacion == 1 then
		t_movimientos["P"..t_jugador.nro_jugador.." Left"]=true
	elseif v_orientacion == 0 then
		t_movimientos["P"..t_jugador.nro_jugador.." Right"]=true
	end
	
	if v_char == 0 or v_char == 1 or v_char ==3 or v_char == 4 or v_char == 6 or v_char == 8 or v_char == 9 or v_char == 10 then 
		if v_indicador_aire==10 or v_indicador_aire==9 or v_indicador_aire==8 or v_indicador_aire==7 then
			t_juego.juego_contador_entrada=1
		end
		if (v_indicador_aire == 4 or v_indicador_aire==5 or v_indicador_aire==3 or v_indicador_aire==6)  and t_juego.juego_contador_entrada==1 then
			t_movimientos["P"..t_jugador.nro_jugador.." Strong Kick"]=true
		else
			t_movimientos["P"..t_jugador.nro_jugador.." Strong Kick"]=false
		end
	elseif v_char == 2 or v_char == 5 or v_char ==7 or v_char ==11 then 
		if v_indicador_aire==11 or v_indicador_aire==12 or v_indicador_aire==13 then
			t_juego.juego_contador_entrada=1
		end
		if (v_indicador_aire == 10 or v_indicador_aire==9 or v_indicador_aire==8)  and t_juego.juego_contador_entrada==1 then
			t_movimientos["P"..t_jugador.nro_jugador.." Strong Kick"]=true
		else
			t_movimientos["P"..t_jugador.nro_jugador.." Strong Kick"]=false
		end
	end
	
	
	if v_indicador_aire == 0 then
		t_juego.juego_contador_entrada=0
	end 
	
	joypad.set(t_movimientos)
end
			 
function accion_patadaAbajoPequena()
		t_movimientos2 = {}
		if t_juego.juego_contador_entrada == 0 then
			t_movimientos2["P2 Down"]=true
			t_movimientos2["P2 Weak Kick"]=true
			joypad.set(t_movimientos2)
			t_juego.juego_contador_entrada=t_juego.juego_contador_entrada+1
		else
			t_movimientos2["P2 Down"]=true
			t_movimientos2["P2 Weak Kick"]=false
			joypad.set(t_movimientos2)
			t_juego.juego_contador_entrada=t_juego.juego_contador_entrada-1
		end 
end

function accion_patadaAbajoGrande()
		t_movimientos2 = {}
		if t_juego.juego_contador_entrada == 0 then
		t_movimientos2["P2 Down"]=true
		t_movimientos2["P2 Strong Kick"]=true
		joypad.set(t_movimientos2)
		t_juego.juego_contador_entrada=t_juego.juego_contador_entrada+1
		else
		t_movimientos2["P2 Down"]=true
		t_movimientos2["P2 Strong Kick"]=false
		joypad.set(t_movimientos2)
		t_juego.juego_contador_entrada=t_juego.juego_contador_entrada-1
		end 
end

function accion_bloquearComboAbajo()
	t_movimientos = {}
	ind_recibe_golpe = memory.readbyte(t_jugador.ind_recibeGolpe)
	v_orientacion  = memory.readbyte(t_jugador.ind_orientacion)
	
	if ind_recibe_golpe==1 then
		accion_p2_BC.aux_contador_local=accion_p2_BC.nro_repeticion_accion
	end
	
	if accion_p2_BC.aux_contador_local > 0 then
	
		accion_p2_BC.secuenciaDefault="P"..t_jugador.nro_jugador.." Down"
		t_movimientos[accion_p2_BC.secuenciaDefault]=true
		
		if v_orientacion == 1 then
			accion_p2_BC.secuenciaDefault="P"..t_jugador.nro_jugador.." Right"
		elseif v_orientacion == 0 then
			accion_p2_BC.secuenciaDefault="P"..t_jugador.nro_jugador.." Left"
		end
	
		t_movimientos[accion_p2_BC.secuenciaDefault]=true
		joypad.set(t_movimientos)
		accion_p2_BC.aux_contador_local=accion_p2_BC.aux_contador_local-1
	end
end
t[9]="q"
function accion_bloquearComboArriba()
	t_movimientos = {}
	ind_recibe_golpe = memory.readbyte(t_jugador.ind_recibeGolpe)
	v_orientacion    = memory.readbyte(t_jugador.ind_orientacion)
	
	if ind_recibe_golpe==1 then
		accion_p2_BC.aux_contador_local=accion_p2_BC.nro_repeticion_accion
	end
	
	if accion_p2_BC.aux_contador_local > 0 then
	
		if v_orientacion == 1 then
			accion_p2_BC.secuenciaDefault="P"..t_jugador.nro_jugador.." Right"
		elseif v_orientacion == 0 then
			accion_p2_BC.secuenciaDefault="P"..t_jugador.nro_jugador.." Left"
		end
	
		t_movimientos[accion_p2_BC.secuenciaDefault]=true
		joypad.set(t_movimientos)
		accion_p2_BC.aux_contador_local=accion_p2_BC.aux_contador_local-1
	end
end

t[8]="r"
function accion_bloquearContraAtacar()
	t_movimientos = {}
	v_orientacion  = memory.readbyte(t_jugador.ind_orientacion)
	v_recibeGolpe  = memory.readbyte(t_jugador.ind_recibeGolpe)
	v_inhabilitado = memory.readbyte(t_jugador.ind_inhabilitado)
	nro_secuencia_hastaCP = #accion_p2_BCA.secuenciaConterProgramado
	nro_secuencia_hastaAP = #accion_p2_BCA.secuenciaAtaqueProgramado
	
	
	if t_jugador.ind_ejecuta_counter==0 then
		if v_recibeGolpe == 0  then
			if t_jugador.ind_prepara_counter==1 then
					if (v_inhabilitado == 8 or v_inhabilitado == 0 ) then
					t_jugador.ind_ejecuta_counter=1
					end
			end 
		elseif (v_recibeGolpe == 1 or v_recibeGolpe==18 or v_recibeGolpe==17 ) then
				t_jugador.ind_prepara_counter=1
		end
	
	else
		if  accion_p2_BCA.secuenciaConterProgramado_indice > nro_secuencia_hastaCP then
			accion_p2_BCA.secuenciaConterProgramado_indice=1
			t_jugador.ind_ejecuta_counter=0
			t_jugador.ind_prepara_counter=0
		end
	end
	
	if  t_jugador.ind_ejecuta_counter == 1 then
		
		for i=1 , #accion_p2_BCA.secuenciaConterProgramado  do  
			accion_p2_BCA.secuenciaConvertida[i]={}
			for j=1, #accion_p2_BCA.secuenciaConterProgramado[i] do 
				if accion_p2_BCA.secuenciaConterProgramado[i][j]=="Forward" then
					if v_orientacion == 1 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Left")
					elseif v_orientacion == 0 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Right")
					end
				elseif accion_p2_BCA.secuenciaConterProgramado[i][j]=="Back" then
					if v_orientacion == 1 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Right")
					elseif v_orientacion == 0 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Left")
					end
				else
					table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." "..accion_p2_BCA.secuenciaConterProgramado[i][j])
				end
			end
		end
	
		for x=1 , #accion_p2_BCA.secuenciaConvertida[accion_p2_BCA.secuenciaConterProgramado_indice] do
			t_movimientos[accion_p2_BCA.secuenciaConvertida[accion_p2_BCA.secuenciaConterProgramado_indice][x]]=true
		end
		accion_p2_BCA.secuenciaConterProgramado_indice = accion_p2_BCA.secuenciaConterProgramado_indice+1
		
	else
			nro_secuencia_hastaAP = #accion_p2_BCA.secuenciaAtaqueProgramado
		if accion_p2_BCA.secuenciaAtaqueProgramado_indice > nro_secuencia_hastaAP then
			accion_p2_BCA.secuenciaAtaqueProgramado_indice=1
		end		
		
		for i=1 , #accion_p2_BCA.secuenciaAtaqueProgramado  do  
			accion_p2_BCA.secuenciaConvertida[i]={}
			for j=1, #accion_p2_BCA.secuenciaAtaqueProgramado[i] do 
				if accion_p2_BCA.secuenciaAtaqueProgramado[i][j]=="Forward" then
					if v_orientacion == 1 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Left")
					elseif v_orientacion == 0 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Right")
					end
				elseif accion_p2_BCA.secuenciaAtaqueProgramado[i][j]=="Back" then
					if v_orientacion == 1 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Right")
					elseif v_orientacion == 0 then
						table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." Left")
					end
				else
					table.insert(accion_p2_BCA.secuenciaConvertida[i], j, "P"..t_jugador.nro_jugador.." "..accion_p2_BCA.secuenciaAtaqueProgramado[i][j])
				end
			end
		end
		
		for x=1 , #accion_p2_BCA.secuenciaConvertida[accion_p2_BCA.secuenciaAtaqueProgramado_indice] do
			t_movimientos[accion_p2_BCA.secuenciaConvertida[accion_p2_BCA.secuenciaAtaqueProgramado_indice][x]]=true
		end
		accion_p2_BCA.secuenciaAtaqueProgramado_indice = accion_p2_BCA.secuenciaAtaqueProgramado_indice+1
		
	end 
	
	joypad.set(t_movimientos)

end
t[7]="a"
function inputdisplay2()
	local tabla_inp = {}
	local width,height = emu.screenwidth() ,emu.screenheight()
	--
	for n = 1, 2 do
		tabla_inp[n .. "^"] =  {(n-1)/n*width + 95 , height - 18, "P" .. n .. " Up"}
		tabla_inp[n .. "v"] =  {(n-1)/n*width + 95 , height - 12, "P" .. n .. " Down"}
		tabla_inp[n .. "<"] =  {(n-1)/n*width + 89 , height - 15, "P" .. n .. " Left"}
		tabla_inp[n .. ">"] =  {(n-1)/n*width + 101 , height - 15, "P" .. n .. " Right"}
		
		tabla_inp[n .. "LP"] = {(n-1)/n*width + 55 , height - 19, "P" .. n .. " Weak Punch"}
		tabla_inp[n .. "MP"] = {(n-1)/n*width + 65, height - 19, "P" .. n .. " Medium Punch"}
		tabla_inp[n .. "HP"] = {(n-1)/n*width + 75, height - 19, "P" .. n .. " Strong Punch"}
		
		tabla_inp[n .. "LK"] = {(n-1)/n*width + 55 , height - 11, "P" .. n .. " Weak Kick"}
		tabla_inp[n .. "MK"] = {(n-1)/n*width + 65, height - 11, "P" .. n .. " Medium Kick"}
		tabla_inp[n .. "HK"] = {(n-1)/n*width + 75, height - 11, "P" .. n .. " Strong Kick"}
			
	end
	
	for k,v in pairs(tabla_inp) do
		local color1,color2 = t_color.on1,t_color.on2
		if joypad.get()[v[3]] == false  then
			color1,color2 = t_color.off1,t_color.off2
		end
		gui.text(v[1], v[2], string.sub(k, 2), color1, color2)
	end
	
end

function energiaInfinita()
   valor_minimo_permitido=35
   
   if memory.readbyte(0x00FF83E9)<=valor_minimo_permitido then 
		memory.writebyte(0x00FF83E9,144)
		memory.writebyte(0x00FF857B,144)
   end

   if memory.readbyte(0x00FF86E9)<=valor_minimo_permitido then 
		memory.writebyte(0x00FF86E9,144)
		memory.writebyte(0x00FF887B,144)
   end
end
t[6]="t"
function tiempoInfinito()
	if(  memory.readbyte(0xFF8ABE)<153) then
		 memory.writebyte(0xFF8ABE,153) 
    end
end 

function mareo() 
   valor_maximo_permitido=1
   if memory.readbyte(t_jugador.ind_mareo)>valor_maximo_permitido then 
		memory.writebyte(t_jugador.ind_mareo,0)
   end
end
t[5]="n"

local menuActivo=false
local contadordeentradas=0
function menuHabilitar()
	local inp = joypad.get()
	
	if inp["P1 Coin"] then	
		contadordeentradas=contadordeentradas+1
	else
		contadordeentradas=0
	end
		
	if contadordeentradas == 30 then 
		if menuActivo then
			menuActivo=false
		else
			menuActivo=true
			v=false
		end
	end
end
t[4]="i"
local contadorMenu=0
local menuOpcion={
	  {"Joystick   :",false,{"No","Si"},1}
	 ,{"Energia    :",false,{"Normal","Infinita"},1}
	 ,{"Tiempo     :",false,{"Normal","Infinito"},1}
	 ,{"Mareo  P2  :",false,{"Normal","Sin mareo"},1}
	 ,{"Accion P2  :",false,{"Ninguna","1 Bloquear Contraatacar","2 Patada Abajo chica","3 Patada Abajo Grande","4 Bloquea Combo Abajo","5 Bloque Combo Arriba","6 Salta","7 Salta y Patea"},1}
}
local seleccionMenu={
			 vertical=1
			,horizontal=1
		}
t[3]="d"
function menuElegir()
	local width,height = emu.screenwidth() ,emu.screenheight()
	
	if not menuActivo then return end 
	
	local inp = joypad.get()
	
	if inp["P1 Down"] then	
		contadorMenu=contadorMenu+1
		if contadorMenu == 1 then
			seleccionMenu.vertical=seleccionMenu.vertical+1
		end
	elseif inp["P1 Up"] then
		contadorMenu=contadorMenu+1
		if contadorMenu == 1 then
			seleccionMenu.vertical=seleccionMenu.vertical-1
		end
	elseif inp["P1 Right"] then
		contadorMenu=contadorMenu+1
		if contadorMenu == 1 then
			seleccionMenu.horizontal= menuOpcion[seleccionMenu.vertical][4]
			seleccionMenu.horizontal=seleccionMenu.horizontal+1
			if seleccionMenu.horizontal > #menuOpcion[seleccionMenu.vertical][3] then
				seleccionMenu.horizontal=1 
			end
			menuOpcion[seleccionMenu.vertical][4]=seleccionMenu.horizontal
		end
	elseif inp["P1 Left"] then
		contadorMenu=contadorMenu+1
		if contadorMenu == 1 then
			seleccionMenu.horizontal= menuOpcion[seleccionMenu.vertical][4]
			seleccionMenu.horizontal=seleccionMenu.horizontal-1
			if seleccionMenu.horizontal < 1 then
				seleccionMenu.horizontal= #menuOpcion[seleccionMenu.vertical][3]
			end
			menuOpcion[seleccionMenu.vertical][4]=seleccionMenu.horizontal
		end	
	else
		contadorMenu=0
	end
	
	if seleccionMenu.vertical > #menuOpcion then 
		seleccionMenu.vertical=#menuOpcion
	elseif 	seleccionMenu.vertical < 1 then
		seleccionMenu.vertical=1
	end
	
	for i=1, #menuOpcion do
		if seleccionMenu.vertical == i  then
			menuOpcion[i][2]=true
		else
			menuOpcion[i][2]=false
		end
	end	
	
	if menuActivo then 	
		dibujaMenu()
	end
	
end
t[2]="o"
local menuEstatico={
				cabecera={"-- OPCIONES DE MENU --"}
			 ,  pie		={"SF2CE Modo Entrenamiento v1.0","Para Fightcade 2","Creado por intiMarqo","Sep.21"}
			 ,  titulo  ={"Modo intiMarqo"}
			}
function dibujaMenu()
		local width,height = emu.screenwidth() ,emu.screenheight()
		
		x1 = width/4
		y1 = height/6
		
		x2 = width-x1
		y2 = height-y1
		
		gui.box(x1,y1,x2,y2,K_N,K_R)
		
		separacion_texto_v=8
		separacion_texto_h=10
		
		for x=1, #menuEstatico.cabecera do
			y1=y1+separacion_texto_v
			gui.text(((width/2) - 4*(string.len(menuEstatico.cabecera[x])/2)), y1 , menuEstatico.cabecera[x])
		end
		
		x1=x1+separacion_texto_h
		y1=y1+(2*separacion_texto_v)
		
		for i=1, #menuOpcion do
			
			if menuOpcion[i][2] then
				gui.text(x1, y1 , menuOpcion[i][1],K_R)
			else
				gui.text(x1, y1 , menuOpcion[i][1])
			end
			
			if #menuOpcion[i][3]>0 then
				valorSubmenu = menuOpcion[i][4]
				gui.text(x1+50, y1 , menuOpcion[i][3][valorSubmenu])
			end	
			
			y1=y1+separacion_texto_v
		end
		
		puntoImpresionTexto_y=height-70
		for r=1, #menuEstatico.pie do
			gui.text(((width/2) - 4*(string.len(menuEstatico.pie[r])/2)), puntoImpresionTexto_y , menuEstatico.pie[r],K_A)
			puntoImpresionTexto_y=puntoImpresionTexto_y+separacion_texto_v
		end
		
end
t[1]="m"
function menuEjecutaConfiguracion()
		v_indarena =memory.readbyte(t_juego.ind_arena)
		if menuOpcion[1][4]==2 then inputdisplay2() end	
		if menuOpcion[2][4]==2 then energiaInfinita() end
		if menuOpcion[3][4]==2 then tiempoInfinito() end
		if menuOpcion[4][4]==2 then mareo() end
		if menuOpcion[5][4]==2 then if v_indarena ~= 0 then accion_bloquearContraAtacar() else return end end
		if menuOpcion[5][4]==3 then if v_indarena ~= 0 then accion_patadaAbajoPequena() else return end end
		if menuOpcion[5][4]==4 then if v_indarena ~= 0 then accion_patadaAbajoGrande() else return end end
		if menuOpcion[5][4]==5 then if v_indarena ~= 0 then accion_bloquearComboAbajo() else return end end
		if menuOpcion[5][4]==6 then if v_indarena ~= 0 then accion_bloquearComboArriba() else return end end
		if menuOpcion[5][4]==7 then if v_indarena ~= 0 then accion_salta() else return end end
		if menuOpcion[5][4]==8 then if v_indarena ~= 0 then accion_saltaPatea() else return end end
end	

function inicia()
	local width,height = emu.screenwidth() ,emu.screenheight()
	x = width/2
	y = height/21
	j = t[1]..t[2]..t[3]..t[2]..' '..t[4]..t[5]..t[6]..t[4]..t[1]..t[7]..t[8]..t[9]..t[2]
	gui.text(( x - 4*(string.len(j)/2)), y , j)
end

function instruccionInicio()
	local width,height = emu.screenwidth() ,emu.screenheight()
	x = width/15
	y = height/21
	if v then 
	j = 'Mantener presionado boton -P1 Coin-'
	gui.text(( x - (string.len(j)/2)), y , j)
	end
	
end

gui.register(function() 
    menuHabilitar()
	menuElegir()
	menuEjecutaConfiguracion()
	inicia()
	instruccionInicio()
end) 