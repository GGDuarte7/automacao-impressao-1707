chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.type === "SEND_DATA") {
        fetch("http://127.0.0.1:8000/update", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ texto: request.texto })
        })
        .then(response => response.json())
        .then(data => sendResponse({ status: "SUCCESS", data: data }))
        .catch(error => {
            console.error("Erro ao comunicar com o servidor Python:", error);
            sendResponse({ status: "ERROR", error: error.toString() });
        });
        return true; 
    }
});