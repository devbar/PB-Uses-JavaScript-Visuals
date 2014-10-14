HA$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type st_1 from statictext within w_main
end type
type cb_reload from commandbutton within w_main
end type
type dw_links from datawindow within w_main
end type
type dw_nodes from datawindow within w_main
end type
type ole_browser from olecustomcontrol within w_main
end type
end forward

global type w_main from window
integer width = 5957
integer height = 2280
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
st_1 st_1
cb_reload cb_reload
dw_links dw_links
dw_nodes dw_nodes
ole_browser ole_browser
end type
global w_main w_main

type prototypes
FUNCTION ulong GetModuleFileName (ulong hinstModule, ref string lpszPath, ulong cchPath )  &
   LIBRARY "KERNEL32.DLL" &
   ALIAS FOR "GetModuleFileNameW"
end prototypes

forward prototypes
public subroutine loadmolecule ()
public subroutine addatom (string as_type)
end prototypes

public subroutine loadmolecule ();long row, rowCount
string nodes = ""
string links = ""
string source = ""

rowCount = dw_nodes.rowCount()
for row = 1 to rowCount
	if not len(nodes) = 0 then
		nodes += ","
	end if
	
	nodes += dw_nodes.getItemString(row, "c_json_set")
next

nodes = '"nodes":[' + nodes + ']'

rowCount = dw_links.rowCount()
for row = 1 to rowCount
	if not len(links) = 0 then
		links += ","
	end if
	
	links += dw_links.getItemString(row, "c_json_set")
next

links = '"links":[' + links + ']'

source = "{" + nodes + "," + links + "}"

ole_browser.object.JsInject("window.loadMoleculeFromPB = function(){loadMoleculeText('" + source + "');}")
ole_browser.object.JsInvoke("loadMoleculeFromPB")

return
end subroutine

public subroutine addatom (string as_type);ole_browser.object.JsInject("window.addAtomFromPB = function(){addAtom('" + as_type + "');}")
ole_browser.object.JsInvoke("addAtomFromPB")

return 
end subroutine

on w_main.create
this.st_1=create st_1
this.cb_reload=create cb_reload
this.dw_links=create dw_links
this.dw_nodes=create dw_nodes
this.ole_browser=create ole_browser
this.Control[]={this.st_1,&
this.cb_reload,&
this.dw_links,&
this.dw_nodes,&
this.ole_browser}
end on

on w_main.destroy
destroy(this.st_1)
destroy(this.cb_reload)
destroy(this.dw_links)
destroy(this.dw_nodes)
destroy(this.ole_browser)
end on

event open;// Make a stunt to know what's the current location is
ClassDefinition  lcd

String ls_fullpath 
ulong lul_handle, lul_length = 512

IF handle(getapplication()) = 0 THEN
    // running from the IDE
    lcd=getapplication().classdefinition
    ls_fullpath = lcd.libraryname
ELSE
    // running from EXE
    lul_handle = handle( getapplication() )
    ls_fullpath=space(lul_length) 
    GetModuleFilename( lul_handle, ls_fullpath, lul_length )
END IF

ls_fullpath = "file:///" + mid(ls_fullpath, 0, lastpos(ls_fullpath, "\")) + "www\index.html"

// load JS
ole_browser.object.ScrollBarsEnabled = false
ole_browser.object.Navigate(ls_fullpath)

return 0
end event

event resize;ole_browser.height = newheight -120
ole_browser.width = (newwidth * 1/2) -20

dw_nodes.x = ole_browser.width + 20
dw_nodes.height = (newheight / 2) -20
dw_nodes.width = (newwidth * 1/2) -20

dw_links.x = dw_nodes.x
dw_links.height = dw_nodes.height
dw_links.width = dw_nodes.width
dw_links.y = dw_nodes.height + 20

return 0
end event

type st_1 from statictext within w_main
integer x = 37
integer y = 64
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 16777215
string text = "Graphic"
boolean focusrectangle = false
end type

type cb_reload from commandbutton within w_main
integer x = 37
integer y = 160
integer width = 402
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Reload"
end type

event clicked;loadMolecule()

return 0
end event

type dw_links from datawindow within w_main
integer x = 2999
integer y = 1056
integer width = 2853
integer height = 1056
integer taborder = 30
string title = "none"
string dataobject = "d_links"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

type dw_nodes from datawindow within w_main
integer x = 2999
integer y = 32
integer width = 2853
integer height = 992
integer taborder = 20
string title = "none"
string dataobject = "d_nodes"
boolean hscrollbar = true
boolean vscrollbar = true
boolean border = false
boolean livescroll = true
end type

event buttonclicked;string button = ""
string atom = ""

button = lower(dwo.name)

if button = "b_oxygen" then
	atom = "O"
elseif button = "b_nitrogen" then
	atom = "N"
elseif button = "b_carbon" then
	atom = "C"
end if

if len(atom) > 0 then
	addAtom(atom)
end if
end event

type ole_browser from olecustomcontrol within w_main
event jstriggered ( string arguments )
integer x = 37
integer y = 288
integer width = 2926
integer height = 1824
integer taborder = 10
boolean border = false
boolean focusrectangle = false
string binarykey = "w_main.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

event jstriggered(string arguments);string method = ""
string args = ""
string symbol = ""
string id = ""
string x_ = ""
string y_ = ""
string size = ""
string bonds = ""
string source = ""
string target = ""
string bondType = ""
long row = 0
long newRow = 0

method = mid(arguments,1,pos(arguments, "->")-1)
args = mid(arguments, len(method)+3)

choose case lower(method)
	case "atomclicked"
		row = dw_nodes.find("id='" + args + "'", 1, dw_nodes.rowCount() +1)
		dw_nodes.setRow(row)
		dw_nodes.selectRow(0, false)
		dw_nodes.selectRow(row, true)
		
	case "boundclicked"
		row = dw_links.find("id='" + args + "'", 1, dw_links.rowCount() +1)
		dw_links.setRow(row)
		dw_links.selectRow(0, false)
		dw_links.selectRow(row, true)
		
	case "atomadded"
		symbol = mid(args, pos(args,'"symbol":"') + 10, 1)
		
		id = mid(args, pos(args,'"id":"') + 6)
		id = left(id, pos(id,'",') -1)
		
		x_ = mid(args, pos(args,'"x":') + 4)
		x_ = left(x_, pos(x_,',') -1)
		x_ = replace(x_, pos(x_,'.'), 1, ',')
		
		y_ = mid(args, pos(args,'y":') + 4)
		y_ = left(y_, pos(y_,',') -1)
		y_ = replace(y_, pos(y_,'.'), 1, ',')
		
		size = mid(args, pos(args,'size":') + 7)
		size = left(size, pos(size,',')-1)
		
		bonds = mid(args, pos(args,'bonds":') + 7)
		bonds = left(bonds, pos(bonds,'}') -1)


		newRow = dw_nodes.insertRow(0)
		dw_nodes.setItem(newRow, "symbol", symbol)
		dw_nodes.setItem(newRow, "id", id)
		dw_nodes.setItem(newRow, "x", dec(x_))
		dw_nodes.setItem(newRow, "y", dec(y_))
		dw_nodes.setItem(newRow, "size", long(size))
		dw_nodes.setItem(newRow, "bounds", long(bonds))
		
	case "boundadded"
		id = mid(args, pos(args,'"id":"') + 7)
		id = left(id, pos(id,'"}') -1)
		
		source = mid(args, pos(args,'"source":"') + 10)
		source = left(source, pos(source,'",') -1)
		
		target = mid(args, pos(args,'"target":"') + 10)
		target = left(target, pos(target,'",') -1)
		
		bondType = mid(args, pos(args,'"bondType":') + 11)
		bondType = left(bondType, pos(bondType,',')-1)
		
		if not isNumber(source) then source = '"' + source + '"'
		if not isNumber(target) then target = '"' + target + '"'
		
		newRow = dw_links.insertRow(0)
		dw_links.setItem(newRow, "id", '"' + id + '"')
		dw_links.setItem(newRow, "source", source)
		dw_links.setItem(newRow, "target", target)
		dw_links.setItem(newRow, "boundType", long(bondType))
end choose



end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
02w_main.bin 
2400000e00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff000000010000000000000000000000000000000000000000000000000000000095d7194001cfe7c100000003000004800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000020700000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff0000000329d729984aca87344eef5dadb4a66f560000000095d6f23001cfe7c195d7194001cfe7c1000000000000000000000000006f00430049006d0074006e007200650070006f0065005700620062006f007200730077007200650057002e00620065007200620077006f006500730000007201020040ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000900000207000000000000000100000002000000030000000400000005000000060000000700000008fffffffe0000000a0000000b0000000c0000000d0000000e0000000f0000001000000011fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
20ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000100ffffff00000001ff0000000000010400531c0000657473796f432e6d63656c6c6e6f697461482e736174687307656c620a00000064616f4c746361465607726f6973726543086e6f61706d6f107265726873614865646f43766f725072656469736148087a695368654b04655606737965756c610300007305050003531c080b657473796f432e6d63656c6c6e6f697443492e7361706d6f2472657274737953432e6d65656c6c6f6f697463492e736e6873614865646f43766f7250726564693851ec0800000c3f170a0a0009000000000000020000030900021000000b0000040600000f0000006b636142756f72676f43646e06726f6c000000056261540865646e49000606784c0800007461636f066e6f69000000076d614e040008066556070000626973690906656c04000000657a695300000a066e450700656c6261000b066442090000436b6361726f6c6f00000c066f4609006f43657206726f6c0000000d72635311426c6c6f457372616c62616e0e0664650f00000065726f46756f72676f43646e10726f6c000000030000000b00000f063631080032373737100635310100000000110630300400000630202c000000126265570a776f72620672657300000013757254040014066536080000202c3034093635340000001300001606685705000665746900000017616c420513096b630600000000000019000b3001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100ffffff00000001ff0000000000010400531c0000657473796f432e6d63656c6c6e6f697461482e736174687307656c620a00000064616f4c746361465607726f6973726543086e6f61706d6f107265726873614865646f43766f725072656469736148087a695368654b04655606737965756c610300007305050003531c080b657473796f432e6d63656c6c6e6f697443492e7361706d6f2472657274737953432e6d65656c6c6f6f697463492e736e6873614865646f43766f7250726564693851ec0800000c3f170a0a0009000000000000020000030900021000000b0000040600000f0000006b636142756f72676f43646e06726f6c000000056261540865646e49000606784c0800007461636f066e6f69000000076d614e040008066556070000626973690906656c04000000657a695300000a066e450700656c6261000b066442090000436b6361726f6c6f00000c066f4609006f43657206726f6c0000000d72635311426c6c6f457372616c62616e0e0664650f00000065726f46756f72676f43646e10726f6c000000030000000b00000f063631080032373737100635310100000000110630300400000630202c000000126265570a776f72620672657300000013757254040014066536080000202c3034093635340000001300001606685705000665746900000017616c420513096b630600000000000019000b300100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12w_main.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
