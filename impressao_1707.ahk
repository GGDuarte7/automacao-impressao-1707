; =====================================================================
;  AUTOMAÇÃO DE IMPRESSÃO EM LOTE - WinThor / Função 1707 (MODO ULTRARRÁPIDO F5)
; =====================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force
SetTitleMatchMode(2)
CoordMode("Mouse", "Screen")

; --------------------- CONFIGURAÇÃO DE TÍTULOS ---------------------

TituloPrincipal          := "1707" 
TitulosVisualizacao      := ["Visualizando Impressão (Remoto)", "Visualizando Impressão", "Visualiz", "Preview", "Print Preview"]     
TitulosImpressora        := ["Imprimir", "Print"]                    
TitulosInformacao        := ["Informação", "Information", "Inform"]
TitulosUniversal         := ["Imprimir", "Print"]                    
TitulosProgresso         := ["Imprimindo", "Printing"]

; --------------------- COORDENADAS PADRÃO ---------------------

CampoCodigo_X            := 2255
CampoCodigo_Y            := 76

BotaoImprimir2_X         := 1937           
BotaoImprimir2_Y         := 35

BotaoTrocarImpressora_X  := 2773        
BotaoTrocarImpressora_Y  := 314

ImpressoraWMS2_X         := 2822           
ImpressoraWMS2_Y         := 448

BotaoOK_X                := 2996           
BotaoOK_Y                := 657

BotaoOK_Informacao_X     := 2883
BotaoOK_Informacao_Y     := 554

BotaoImprimirUniversal_X := 880
BotaoImprimirUniversal_Y := 404

BotaoFechar_X            := 2410
BotaoFechar_Y            := 35

Timeout                  := 15

ArquivoCodigos           := A_ScriptDir "\codigos.txt"
impressoraPadrao         := ""
global PastaProjetoGlobal := ""

; Variáveis da Janela de Monitoramento
global MonitorGui := ""
global TextStatus := ""
global TextProgresso := ""
global TextErro := ""

; Inicializa a janela de monitoramento e carrega configurações do config.json
CriarJanelaMonitorAHK()
CarregarConfiguracao()


; --------------------- TECLAS DE ATALHO ---------------------
F1::AlternarPausa()             
F2::IniciarProcessamento()      
F3::ExitApp()                    
F4::ProcessarTextoClipboard()  


; =====================================================================
;  INTERFACE GRÁFICA NATIVA DE MONITORAMENTO (JANELA NORMAL)
; =====================================================================

CriarJanelaMonitorAHK() {
    global MonitorGui, TextStatus, TextProgresso, TextErro
    
    ; Janela normal sem +AlwaysOnTop para não sobrepor outras aplicações
    MonitorGui := Gui("+Resize", "Painel de Monitoramento - WinThor 1707")
    MonitorGui.SetFont("s10 bold", "Segoe UI")
    
    MonitorGui.Add("Text", "cGray", "🖨️ Status da Impressão:")
    TextStatus := MonitorGui.Add("Text", "w360 r2 c0056b3", "Aguardando início no WinThor (F2)...")
    
    MonitorGui.SetFont("s9 norm", "Segoe UI")
    TextProgresso := MonitorGui.Add("Text", "w360", "Códigos Processados: 0 / 0")
    
    MonitorGui.SetFont("s9 bold", "Segoe UI")
    TextErro := MonitorGui.Add("Text", "w360 r2 cRed Hidden", "")
    
    ; Exibe a janela de forma normal e sem tomar o foco ativo
    MonitorGui.Show("x10 y10 w390 h160 NoActivate")
}

AtualizarMonitorAHK(status, codigoAtual:="-", contador:=0, total:=0, msgErro:="") {
    global TextStatus, TextProgresso, TextErro
    
    if (status = "imprimindo") {
        TextStatus.Value := "Imprimindo Código: " codigoAtual
        TextStatus.Opt("c0056b3")
        TextProgresso.Value := "Progresso: " contador " de " total " processados"
        TextErro.Visible := false
    } 
    else if (status = "concluido") {
        TextStatus.Value := "✅ Impressão Finalizada com Sucesso!"
        TextStatus.Opt("c28a745")
        TextProgresso.Value := "Total Processado: " total " de " total " códigos"
        TextErro.Visible := false
    } 
    else if (status = "erro") {
        TextStatus.Value := "⚠️ OCORREU UM ERRO!"
        TextStatus.Opt("cCc0000")
        TextProgresso.Value := "Parado no código " contador " de " total
        TextErro.Value := "Erro no Código: " codigoAtual "`nDetalhe: " msgErro
        TextErro.Visible := true
    }
}


; =====================================================================
;  FUNÇÕES DE INTEGRAÇÃO COM A INTERFACE GRÁFICA (CONFIG E STATUS JSON)
; =====================================================================

CarregarConfiguracao() {
    global ArquivoCodigos, Timeout, PastaProjetoGlobal
    global CampoCodigo_X, CampoCodigo_Y, BotaoImprimir2_X, BotaoImprimir2_Y
    global BotaoTrocarImpressora_X, BotaoTrocarImpressora_Y, ImpressoraWMS2_X, ImpressoraWMS2_Y
    global BotaoOK_X, BotaoOK_Y, BotaoOK_Informacao_X, BotaoOK_Informacao_Y
    global BotaoImprimirUniversal_X, BotaoImprimirUniversal_Y, BotaoFechar_X, BotaoFechar_Y

    caminhoConfig := A_ScriptDir "\config.json"
    if FileExist(caminhoConfig) {
        try {
            txt := FileRead(caminhoConfig, "UTF-8")
            
            GetCoord(chave, valorPadrao) {
                if RegExMatch(txt, '"' chave '"\s*:\s*(\d+)', &m)
                    return Integer(m[1])
                return valorPadrao
            }

            ; 1. Atualização das 8 Coordenadas da Tela (X e Y)
            CampoCodigo_X            := GetCoord("CampoCodigo_X", CampoCodigo_X)
            CampoCodigo_Y            := GetCoord("CampoCodigo_Y", CampoCodigo_Y)
            BotaoImprimir2_X         := GetCoord("BotaoImprimir2_X", BotaoImprimir2_X)
            BotaoImprimir2_Y         := GetCoord("BotaoImprimir2_Y", BotaoImprimir2_Y)
            BotaoTrocarImpressora_X  := GetCoord("BotaoTrocarImpressora_X", BotaoTrocarImpressora_X)
            BotaoTrocarImpressora_Y  := GetCoord("BotaoTrocarImpressora_Y", BotaoTrocarImpressora_Y)
            ImpressoraWMS2_X         := GetCoord("ImpressoraWMS2_X", ImpressoraWMS2_X)
            ImpressoraWMS2_Y         := GetCoord("ImpressoraWMS2_Y", ImpressoraWMS2_Y)
            BotaoOK_X                := GetCoord("BotaoOK_X", BotaoOK_X)
            BotaoOK_Y                := GetCoord("BotaoOK_Y", BotaoOK_Y)
            BotaoOK_Informacao_X     := GetCoord("BotaoOK_Informacao_X", BotaoOK_Informacao_X)
            BotaoOK_Informacao_Y     := GetCoord("BotaoOK_Informacao_Y", BotaoOK_Informacao_Y)
            BotaoImprimirUniversal_X := GetCoord("BotaoImprimirUniversal_X", BotaoImprimirUniversal_X)
            BotaoImprimirUniversal_Y := GetCoord("BotaoImprimirUniversal_Y", BotaoImprimirUniversal_Y)
            BotaoFechar_X            := GetCoord("BotaoFechar_X", BotaoFechar_X)
            BotaoFechar_Y            := GetCoord("BotaoFechar_Y", BotaoFechar_Y)

            ; 2. Atualização dos Caminhos e Parâmetros
            if RegExMatch(txt, '"PASTA_PROJETO"\s*:\s*"([^"]+)"', &m) {
                PastaProjetoGlobal := StrReplace(m[1], "\\", "\")
                ArquivoCodigos := PastaProjetoGlobal "\codigos.txt"
            }

            if RegExMatch(txt, '"TIMEOUT"\s*:\s*(\d+)', &m) {
                Timeout := Integer(m[1])
            }
        }
    }
}

AtualizarStatus(status, codigoAtual:="-", totalProcessados:=0, temErro:=false, codErro:="", msgErro:="") {
    global PastaProjetoGlobal
    
    codigoAtual := StrReplace(StrReplace(codigoAtual, '"', '\"'), "`n", " ")
    codErro := StrReplace(StrReplace(codErro, '"', '\"'), "`n", " ")
    msgErro := StrReplace(StrReplace(msgErro, '"', '\"'), "`n", " ")

    txtJson := '{"status": "' status '", "codigo_atual": "' codigoAtual '", "total_processados": ' totalProcessados ', "erro": ' (temErro ? "true" : "false") ', "codigo_erro": "' codErro '", "mensagem_erro": "' msgErro '"}'
    
    EscreverArquivoJSON(A_ScriptDir "\status.json", txtJson)
    
    if (PastaProjetoGlobal != "" && DirExist(PastaProjetoGlobal) && PastaProjetoGlobal != A_ScriptDir) {
        EscreverArquivoJSON(PastaProjetoGlobal "\status.json", txtJson)
    }
}

EscreverArquivoJSON(caminho, conteudo) {
    try {
        fileObj := FileOpen(caminho, "w", "UTF-8")
        if IsObject(fileObj) {
            fileObj.Write(conteudo)
            fileObj.Close()
        }
    }
}


; --------------------- PAUSA E LIMPEZA DE TEXTO ---------------------

AlternarPausa() {
    static pausado := false
    pausado := !pausado
    Pause(pausado)
    ToolTip(pausado ? "Script PAUSADO (Pressione F1 para voltar)" : "Script ATIVO")
    SetTimer(() => ToolTip(), -2000)
}

ProcessarTextoClipboard() {
    global ArquivoCodigos
    textoBruto := A_Clipboard

    if (Trim(textoBruto) = "") {
        ToolTip("A área de transferência está vazia! Copie o texto primeiro.")
        SetTimer(() => ToolTip(), -2500)
        return
    }

    codigosUnicos := Map()
    resultado := ""

    loop parse, textoBruto, "`n", "`r" {
        if RegExMatch(A_LoopField, "^\s*(\d+)", &match) {
            codigo := match[1]
            if !codigosUnicos.Has(codigo) {
                codigosUnicos[codigo] := true
                resultado .= codigo "`n"
            }
        }
    }

    resultadoLimpo := Trim(resultado, "`n`r")

    if (resultadoLimpo != "") {
        if FileExist(ArquivoCodigos)
            FileDelete(ArquivoCodigos)
            
        FileAppend(resultadoLimpo, ArquivoCodigos, "UTF-8")
        
        ToolTip("Sucesso! Códigos salvos em 'codigos.txt'. Pressione F2.")
        SetTimer(() => ToolTip(), -3500)
    } else {
        ToolTip("Nenhum código válido encontrado.")
        SetTimer(() => ToolTip(), -2500)
    }
}


; --------------------- FUNÇÕES AUXILIARES ---------------------

EhJanelaValida(t) {
    if !WinExist(t)
        return false
    
    tituloEncontrado := WinGetTitle(t)
    if (t = "Print" || t = "Imprimir") {
        if InStr(tituloEncontrado, "Preview") || InStr(tituloEncontrado, "Visualiz")
            return false
    }
    return true
}

ExisteAlgumaJanela(listaTitulos) {
    for t in listaTitulos {
        if EhJanelaValida(t)
            return true
    }
    return false
}

AtivarAlgumaJanela(listaTitulos) {
    for t in listaTitulos {
        if EhJanelaValida(t) {
            WinActivate(t)
            return true
        }
    }
    return false
}

JanelaAtiva(listaTitulos) {
    for t in listaTitulos {
        if EhJanelaValida(t) && WinActive(t)
            return true
    }
    return false
}


; --------------------- FUNÇÃO PRINCIPAL ---------------------

IniciarProcessamento() {
    global impressoraPadrao, ArquivoCodigos

    CarregarConfiguracao()

    if !FileExist(ArquivoCodigos) {
        MsgBox("Arquivo 'codigos.txt' não encontrado em:`n" ArquivoCodigos)
        AtualizarStatus("erro", "-", 0, true, "-", "Arquivo codigos.txt nao encontrado.")
        AtualizarMonitorAHK("erro", "-", 0, 0, "Arquivo codigos.txt nao encontrado.")
        return
    }

    escolha := MsgBox("Selecionar impressora redirecionada ou universal printer:`n`n[Sim]  → Impressora Redirecionada (WMS 2)`n[Não]  → Universal Printer", "Seleção de Impressora", "YesNo Icon?")
    if (escolha = "Yes") {
        impressoraPadrao := "WMS2"
    } else {
        impressoraPadrao := "Universal"
    }

    conteudo := FileRead(ArquivoCodigos)
    codigos := StrSplit(conteudo, "`n", "`r")

    total := 0
    for codigo in codigos {
        if (Trim(codigo) != "")
            total++
    }

    contador := 0
    for codigo in codigos {
        codigo := Trim(codigo)
        if (codigo = "")
            continue

        contador++
        ToolTip("Imprimindo " contador " de " total " — Código: " codigo)

        ; Atualiza a interface gráfica nativa e o arquivo de status
        AtualizarStatus("imprimindo", codigo, contador - 1)
        AtualizarMonitorAHK("imprimindo", codigo, contador, total)

        if !ProcessarCodigo(codigo) {
            ToolTip()
            MsgBox("Falha no código " codigo ". Verifique a tela e reinicie.")
            
            AtualizarStatus("erro", codigo, contador - 1, true, codigo, "Falha na execução ou timeout na rotina 1707.")
            AtualizarMonitorAHK("erro", codigo, contador - 1, total, "Falha na execução ou timeout na rotina 1707.")
            return
        }

        AtualizarStatus("imprimindo", codigo, contador)
        Sleep(400)
    }

    ToolTip()
    AtualizarStatus("concluido", "Concluído", contador)
    AtualizarMonitorAHK("concluido", "-", contador, total)
    MsgBox("Concluído! " contador " códigos processados.")
}


; --------------------- PROCESSA UM ÚNICO CÓDIGO ---------------------

ProcessarCodigo(codigo) {
    global impressoraPadrao, TituloPrincipal, TitulosVisualizacao, TitulosImpressora, TitulosInformacao, TitulosUniversal, TitulosProgresso
    global CampoCodigo_X, CampoCodigo_Y, BotaoImprimir2_X, BotaoImprimir2_Y
    global BotaoTrocarImpressora_X, BotaoTrocarImpressora_Y, ImpressoraWMS2_X, ImpressoraWMS2_Y
    global BotaoOK_X, BotaoOK_Y, BotaoOK_Informacao_X, BotaoOK_Informacao_Y
    global BotaoImprimirUniversal_X, BotaoImprimirUniversal_Y, BotaoFechar_X, BotaoFechar_Y
    global Timeout

    ; 1) Digita o código via Clipboard e Ctrl+V com limpeza total (Ctrl+A -> Backspace)
    if WinExist(TituloPrincipal) {
        WinActivate(TituloPrincipal)
        WinWaitActive(TituloPrincipal,, 2)
    }

    MouseMove(CampoCodigo_X, CampoCodigo_Y)
    Sleep(100)
    Click(CampoCodigo_X, CampoCodigo_Y)
    Sleep(200)

    Send("^a")
    Sleep(100)
    Send("{Backspace}")
    Sleep(100)

    A_Clipboard := ""
    A_Clipboard := codigo
    ClipWait(1)
    
    Send("^v")
    Sleep(200)

    ; 2) Pesquisa (F4) e Imprime (F5)
    Send("{F4}")
    Sleep(400)

    if WinExist(TituloPrincipal) {
        WinActivate(TituloPrincipal)
        Sleep(100)
    }
    Send("{F5}")

    ; 3) ESPERA A TELA DE VISUALIZAÇÃO ABRIR
    tempoEsperado := 0
    loop {
        tempoEsperado++
        if (tempoEsperado > Timeout * 2) {
            ToolTip()
            return false
        }

        if ExisteAlgumaJanela(TitulosInformacao) {
            AtivarAlgumaJanela(TitulosInformacao)
            Sleep(150)
            Click(BotaoOK_Informacao_X, BotaoOK_Informacao_Y)
            
            for t in TitulosInformacao {
                if EhJanelaValida(t)
                    WinWaitClose(t,, 2)
            }
            Sleep(300)
            return true 
        }

        if ExisteAlgumaJanela(TitulosVisualizacao) {
            break
        }

        nomeJanelaAtual := WinGetTitle("A")
        ToolTip("Aguardando tela...`nO que o script vê agora: " nomeJanelaAtual)
        Sleep(500)
    }
    ToolTip()
    AtivarAlgumaJanela(TitulosVisualizacao)
    Sleep(300)

    ; 4) LOOP PARA CLICAR NA IMPRESSORA
    tentativas := 0
    loop {
        tentativas++
        if (tentativas > 30)
            return false

        if JanelaAtiva(TitulosImpressora)
            break

        if ExisteAlgumaJanela(TitulosImpressora)
            break

        if ExisteAlgumaJanela(TitulosVisualizacao) {
            AtivarAlgumaJanela(TitulosVisualizacao)
            Sleep(150)
            MouseMove(BotaoImprimir2_X, BotaoImprimir2_Y)
            Sleep(100)
            SendEvent("{Click " BotaoImprimir2_X " " BotaoImprimir2_Y "}")
        }

        Sleep(500)
    }
    Sleep(200)

    ; 5) CONFIRMAR IMPRESSORA
    AtivarAlgumaJanela(TitulosImpressora)
    
    if (impressoraPadrao = "WMS2" || impressoraPadrao = "WMS 2") {
        Click(BotaoTrocarImpressora_X, BotaoTrocarImpressora_Y)
        Sleep(300)
        Click(ImpressoraWMS2_X, ImpressoraWMS2_Y)
        Sleep(250)
        Click(BotaoOK_X, BotaoOK_Y)
    } else {
        Click(BotaoOK_X, BotaoOK_Y)
        Sleep(1200)

        for t in TitulosImpressora {
            if EhJanelaValida(t)
                WinWaitClose(t,, 4)
        }

        janelaUniversalEncontrada := false
        loop 20 { 
            Sleep(800)
            for t in TitulosUniversal {
                if EhJanelaValida(t) {
                    WinActivate(t)
                    WinWaitActive(t,, 3)
                    janelaUniversalEncontrada := true
                    break 2
                }
            }
        }

        if (!janelaUniversalEncontrada)
            return false

        Sleep(400)
        MouseMove(BotaoImprimirUniversal_X, BotaoImprimirUniversal_Y)
        Sleep(200)
        SendEvent("{Click " BotaoImprimirUniversal_X " " BotaoImprimirUniversal_Y "}")
    }

    ; 5.5) AGUARDAR PROGRESSO DA IMPRESSÃO
    loop 10 {
        Sleep(300)
        if ExisteAlgumaJanela(TitulosProgresso)
            break
    }

    for t in TitulosProgresso {
        if EhJanelaValida(t) {
            WinWaitClose(t,, 15)
        }
    }
    Sleep(400)

    ; 6) FECHAR VISUALIZAÇÃO
    while ExisteAlgumaJanela(TitulosVisualizacao) {
        AtivarAlgumaJanela(TitulosVisualizacao)
        Sleep(200)
        MouseMove(BotaoFechar_X, BotaoFechar_Y)
        Sleep(100)
        SendEvent("{Click " BotaoFechar_X " " BotaoFechar_Y "}")
        
        for t in TitulosVisualizacao {
            if EhJanelaValida(t) {
                WinWaitClose(t,, 2)
            }
        }
        Sleep(300)
    }

    if WinExist(TituloPrincipal) {
        WinActivate(TituloPrincipal)
        WinWaitActive(TituloPrincipal,, 2)
    }

    Sleep(200)
    return true
}