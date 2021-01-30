#TEMPLATE (SDigitalesVentAvance, 'Templates de SDigitales - Ventana de Avance'), FAMILY('ABC')
#EXTENSION(SDVentanaAvance,'Arma ventana de espera con avance'),PROCEDURE
#BOXED
#PROMPT('Primer Linea', @s50), %PrimerLinea,DEFAULT('Preparando Datos')
#PROMPT('Segunda Linea', @s50), %SegundaLinea,DEFAULT('Aguarde... Procesando...')
#PROMPT('Avance cada', @n5), %AvanceEspera,DEFAULT(20)
#DISPLAY('')
#Display('Para abrir la ventana:')
#Display('    DO AbrirVentanaEsperaAvance')
#DISPLAY('')
#Display('Para Cerrar la ventana:')
#Display('    DO CerrarVentanaEsperaAvance')
#DISPLAY('')
#Display('Para Avanzar:')
#Display('    DO AvanceEspera')
#DISPLAY('')
#Display('Ajustar el avance a gusto para')
#DISPLAY('dar sensaci¢n de avance...')
#ENDBOXED

#LOCALDATA
ContaAvance     USHORT
#ENDLOCALDATA

#AT(%DataSection), PRIORITY(5001)
VentanaEsperaAvance WINDOW,AT(,,166,92),CENTER,GRAY
          STRING(''),AT(8,7,150),USE(?Lineauno),FONT(,,,FONT:bold),CENTER
          STRING(''),AT(8,20,150),USE(?Lineados),CENTER
          STRING(''),AT(8,33,150,10),USE(?AvanceEspera),FONT('Wingdings'),CENTER
          PROMPT('El proceso puede demorar, e indicar que el Sistema "no responde", per' & |
            'o está trabajando. No fuerze el cierre del Sistema. En lo posible, no mini' & |
            'mize ni utilize la Terminal hasta el fin del proceso.'),AT(8,46,150,43),USE(?PROMPT1), |
            FONT(,,,FONT:bold),CENTER
        END
    #ENDAT

    #At(%ProcessedCode), WHERE(%ProcedureTemplate = 'Source') ,Priority(9999), Description('Rutinas AbrirVentana y CerrarVentana para la ventana de espera')
    #Insert(%VentanaEsperaAvanceRoutines), NOINDENT
    #EndAt
    #At(%ProcedureRoutines) , WHERE(%ProcedureTemplate <> 'Source'), Priority(9999),  Description('Rutinas AbrirVentana y CerrarVentana para la ventana de espera')
    #Insert(%VentanaEsperaAvanceRoutines), NOINDENT
#EndAt

#Group(%VentanaEsperaAvanceRoutines), Preserve
AbrirVentanaEsperaAvance Routine
    SETCURSOR(Cursor:Wait)
    GLO:AgendaDetenida = 1
    Open(VentanaEsperaAvance)
    ?LineaUno{Prop:Text} = '%PrimerLinea'
    ?LineaDos{Prop:Text} = '%SegundaLinea'
    Display

CerrarVentanaEsperaAvance Routine
    Close(VentanaEsperaAvance)
    GLO:AgendaDetenida = 0
    SETCURSOR(Cursor:Arrow)

AvanceEspera              Routine
    ContaAvance+= 1
    LargoEspera# = Int(ContaAvance / %AvanceEspera)
    if LargoEspera# > 35 Then ContaAvance = 1.
    ?AvanceEspera{PROP:Text} = All('n',LargoEspera#)
    Display()

