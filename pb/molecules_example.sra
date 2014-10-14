HA$PBExportHeader$molecules_example.sra
$PBExportComments$Generated Application Object
forward
global type molecules_example from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global type molecules_example from application
string appname = "molecules_example"
end type
global molecules_example molecules_example

on molecules_example.create
appname="molecules_example"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on molecules_example.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;open ( w_main )
end event

