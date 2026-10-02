console.log("WinThor Keep AutoSync v7.0 - Modo Estrito Visível");

function criarIndicador() {
    if (document.getElementById("winthor-status-badge")) return;
    const badge = document.createElement("div");
    badge.id = "winthor-status-badge";
    badge.style.position = "fixed";
    badge.style.bottom = "12px";
    badge.style.left = "12px";
    badge.style.padding = "6px 14px";
    badge.style.background = "#1e293b";
    badge.style.color = "#38bdf8";
    badge.style.borderRadius = "20px";
    badge.style.fontSize = "12px";
    badge.style.fontWeight = "bold";
    badge.style.zIndex = "99999";
    badge.style.boxShadow = "0 2px 8px rgba(0,0,0,0.3)";
    badge.style.fontFamily = "sans-serif";
    badge.innerText = "🟢 WinThor Sync: Ativo";
    document.body.appendChild(badge);
}

function atualizarStatus(texto, corBg, corTexto) {
    const badge = document.getElementById("winthor-status-badge");
    if (badge) {
        badge.innerText = texto;
        badge.style.background = corBg;
        badge.style.color = corTexto;
    }
}

window.ultimosCodigosEnviados = "";
window.mostrarSucesso = false;

function obterTextoCorpoNota() {
    // 1. Tenta ler se a nota estiver aberta no meio do ecrã (pop-up)
    let dialog = document.querySelector('div[role="dialog"]');
    if (dialog && dialog.innerText.toLowerCase().includes("winthor")) {
        return dialog.innerText || "";
    }

    // 2. Se estiver fechada, lê os "cards" (grelha) da página inicial SEM PRECISAR CLICAR
    let cards = document.querySelectorAll('div[role="button"], div.IZ65hb-TB32B, div.RNfche');
    for (let card of cards) {
        let textoCard = card.innerText || "";
        if (textoCard.toLowerCase().includes("winthor")) {
            return textoCard;
        }
    }

    return "";
}

function verificarKeep() {
    // ====================================================================
    // TRAVA DE SEGURANÇA: Só executa se a aba do Google Keep estiver
    // aberta e visível no ecrã. Se minimizar o Chrome, ele não faz NADA.
    // ====================================================================
    if (document.visibilityState !== "visible") {
        return; 
    }

    criarIndicador();
    let textoCorpo = obterTextoCorpoNota();

    if (!textoCorpo || textoCorpo.trim() === "") {
        if (!window.mostrarSucesso) atualizarStatus("🟡 Nota 'WinThor' não encontrada", "#ca8a04", "#ffffff");
        return;
    }

    let linhas = textoCorpo.split('\n');
    let codigosEncontrados = [];

    linhas.forEach(linha => {
        let linhaLimpa = linha.replace(/[\u200B-\u200D\uFEFF]/g, '').trim();
        // Ignora datas/horas de edição
        if (/editad|modificad|criad|edited|created|\b\d{1,2}:\d{2}\b/i.test(linhaLimpa)) return;

        // Extrai apenas os números
        let match = linhaLimpa.match(/^[-*•☑☐\s]*(\d{2,6})(?!\d)/);
        if (match) {
            codigosEncontrados.push(match[1]);
        }
    });

    codigosEncontrados = [...new Set(codigosEncontrados)];

    if (codigosEncontrados.length > 0) {
        let chaveCodigos = codigosEncontrados.join(",");

        if (chaveCodigos === window.ultimosCodigosEnviados) {
            if (!window.mostrarSucesso) {
                atualizarStatus(`🟢 Lendo: ${codigosEncontrados.length} códigos`, "#1e293b", "#38bdf8");
            }
            return;
        }

        let textoParaPython = codigosEncontrados.join("\n");

        chrome.runtime.sendMessage({ type: "SEND_DATA", texto: textoParaPython }, (response) => {
            if (chrome.runtime.lastError || !response || response.status !== "SUCCESS") {
                atualizarStatus("🔴 Servidor Python desligado!", "#991b1b", "#ffffff");
            } else {
                window.ultimosCodigosEnviados = chaveCodigos;
                window.mostrarSucesso = true;
                atualizarStatus(`✅ Enviados ${codigosEncontrados.length} códigos p/ TXT`, "#15803d", "#ffffff");
                setTimeout(() => { window.mostrarSucesso = false; }, 2500);
            }
        });
    } else {
        if (!window.mostrarSucesso) atualizarStatus("🟡 Nenhum código detetado", "#ca8a04", "#ffffff");
    }
}

// Verifica a cada 1 segundo (mas apenas se a aba estiver visível)
setInterval(verificarKeep, 1000);