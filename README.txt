=======================================================================================
PASSO A PASSO PARA CONFIGURAÇÃO E USO DO SCRIPT AHK (IMPRESSÃO AUTOMÁTICA 1707)
=======================================================================================

1. Pré-requisitos e Instalações Necessárias.
Para que todo o ecossistema de automação funcione perfeitamente, certifique-se de ter instalado no computador:
- **Python (Versão 3.x):** Baixe e instale no site oficial (https://www.python.org/downloads/), marcando obrigatoriamente a opção "Add Python to PATH" durante a instalação.
- **AutoHotkey (v2.0):** Baixe e instale a versão v2.0 ou superior em (https://www.autohotkey.com/). O AutoHotkey é indispensável para a automação de interface.
- **Navegador Web (Google Chrome ou Microsoft Edge):** Necessário para rodar a extensão e manter a sincronização de notas do Google Keep.
- **Google Keep:** Acesse pelo navegador em (https://keep.google.com/) ou utilize a aplicação vinculada no telemóvel/celular.


2. Configuração de Caminho e Calibração Inicial do Ponteiro (Painel Control).
Não é necessário alterar arquivos de código manualmente. Para configurar caminhos e telas:
- Dê um duplo clique no arquivo **"Configurar Painel.bat"** para abrir o painel de gerenciamento.
- **Caminho do Projeto:** Clique em "Selecionar Pasta..." e indique a pasta exata onde os arquivos do projeto foram extraídos (ex: `AutImpAntigo - Copia`).
- **Nome da Impressora:** Digite a identificação da impressora padrão (ex: `WMS2`).
- **Calibração de Coordenadas (Ponteiro 1 ao 8):** Clique em "Configurar Localização do Ponteiro", escolha o ponto desejado na lista, clique em "Ativar Captura por Botão Direito" e vá até a tela do WinThor 1707. Clique com o **BOTÃO DIREITO** do mouse em cima do campo/botão correto. Um sinal sonoro (beep) confirmará a captura das coordenadas $X$ e $Y$.
- Clique em **"💾 Salvar Configurações no Projeto"** para atualizar automaticamente o arquivo `config.json`.


3. Instalação e Atualização da Extensão no Navegador (`extension_winthor`).
No seu navegador (Chrome ou Edge):
- Acesse o menu de opções > **Extensões** > **Gerenciar Extensões** (ou digite `chrome://extensions` na barra de endereços).
- Ative a opção **"Modo do desenvolvedor"** no canto superior direito.
- Clique em **"Carregar sem compactação"** (Load unpacked) e selecione a pasta `extension_winthor` localizada dentro do diretório do projeto.
- *Nota de Atualização:* Se mover a pasta do projeto de local ou renomeá-la (ex: adicionar `- Copia`), remova a extensão do navegador e recarregue-a apontando para o novo diretório.


4. Execução Simplificada no Dia a Dia ("Iniciar Tudo").
Para facilidade operacional e início rápido da rotina diária sem janelas desnecessárias:
- Dê um duplo clique no arquivo **"Iniciar tudo.bat"**.
- O sistema iniciará automaticamente o servidor Python (`servidor_keep.py`) em segundo plano de forma 100% invisível (`pythonw`), além do script do AutoHotkey (`impressao_1707.ahk`).
- Uma janela discreta de monitoramento nativo surgirá no canto da tela informando o status da impressão sem roubar o foco das suas aplicações.


5. Encerramento Completo de Processos em Segundo Plano ("Encerrar Tudo").
Caso precise reiniciar o sistema, recarregar atualizações ou limpar instâncias presas na memória:
- Dê um duplo clique no arquivo **"Encerrar tudo.bat"**.
- Este utilitário encerra de forma forçada todas as tarefas do `python.exe`, `pythonw.exe`, `AutoHotkey.exe` e limpa o arquivo temporário de status para evitar divergências.


=======================================================================================
📌 REGRAS E FUNCIONAMENTO DA NOTA NO GOOGLE KEEP
=======================================================================================

Para que a captura e o envio automático dos códigos funcionem perfeitamente, siga estas regras obrigatórias:

1. **Título Obrigatório da Nota:** 
   A nota criada no Google Keep DEVE ter exatamente o título **WinThor** (respeitando maiúsculas e minúsculas).

2. **Manter a Aba Aberta no Navegador:**
   Para que a extensão consiga extrair os dados e enviar via API local, a aba do Google Keep no navegador precisa estar aberta.

3. **Formatos de Entrada de Código Aceitos:**
   - Digitação direta de código por linha (ex: `103423`, `137726`).
   - Listas de verificação (checkboxes) ou texto livre. O sistema identifica e extrai automaticamente apenas a sequência numérica dos códigos de produto.

4. **Sincronização em Tempo Real (Celular ou PC):**
   Qualquer alteração feita no conteúdo da nota — seja editando diretamente pelo computador ou adicionando/removendo códigos pelo telemóvel/celular na aplicação do Google Keep — fará o envio automático dos novos códigos atualizados para o arquivo local `codigos.txt`.

5. **Indicadores Visuais de Status no Keep:**
   - **`🟢 WinThor Sync: Ativo`** — Extensão conectada e operando normalmente.
   - **`✅ Enviados X códigos p/ TXT`** — Sucesso na transmissão para o servidor Python.
   - **`🔴 Servidor Python desligado!`** — O servidor local não está em execução ou foi bloqueado. Execute o `Iniciar tudo.bat` e pressione `F5` na aba do Keep.


=======================================================================================
⌨️ CONTROLES E ATALHOS DE TECLADO (F1, F2, F3, F4)
=======================================================================================

O script utiliza teclas de atalho dedicadas para controlar a execução na rotina 1707 do WinThor:

- **F1:** Pausa ou retoma o script temporariamente caso precise verificar algo na tela.
- **F2:** Inicia o processo de automação de inserção e impressão em lote com base na lista do arquivo `codigos.txt`.
- **F3:** Interrompe/encerra imediatamente a execução do script em caso de emergência.
- **F4:** Processar texto da área de transferência (Clipboard). Caso copie uma lista de códigos manualmente (Ctrl+C), aperte F4 para extrair e salvar diretamente em `codigos.txt`.


=======================================================================================
🎯 GUIA DE SOLUÇÃO DE PROBLEMAS RÁPIDOS (TROUBLESHOOTING)
=======================================================================================

1. **Mensagem "Servidor Python desligado!" na extensão do Keep:**
   - Execute o arquivo `Encerrar tudo.bat`.
   - Em seguida, execute o `Iniciar tudo.bat`.
   - Vá para a aba do Google Keep no navegador e pressione **`F5`** para atualizar o contexto da extensão.

2. **O Script cola o código no WinThor mas não avança para a impressão:**
   - Certifique-se de que a janela da rotina 1707 do WinThor está maximizada e em primeiro plano.
   - Verifique no `config.json` se as coordenadas do "Campo de Código do Produto" e do "Botão Imprimir / F5" foram capturadas corretamente no monitor ativo.

3. **Erro ao carregar a extensão no Chrome ("Manifest is not valid JSON"):**
   - Garanta que está utilizando os arquivos da pasta `extension_winthor` sem alterações estruturais de sintaxe.
   - Na página `chrome://extensions`, remova a versão antiga e utilize "Carregar sem compactação" apontando para a pasta atualizada do projeto.

4. **Cliques ocorrendo fora do lugar correto:**
   - A automação utiliza coordenadas absolutas de tela. Se alterar a resolução do Windows, mudar a escala de DPI (ex: de 100% para 125%) ou usar um monitor diferente, abra o `Configurar Painel.bat` e refaça a calibração do ponteiro.


=======================================================================================
🛑 AVISO CRÍTICO: USO EXCLUSIVO DO COMPUTADOR DURANTE A EXECUÇÃO
=======================================================================================

⚠️ **NÃO MEXA NO MOUSE OU NO TECLADO ENQUANTO O SCRIPT ESTIVER A RODAR!**
Nesta versão, a automação simula cliques e digitação diretamente na interface gráfica do WinThor. Se você mover o mouse, clicar em outra janela ou tentar usar o computador enquanto o script executa, o foco será perdido, o script poderá clicar no lugar errado, corromper dados ou inserir códigos incorretos na rotina. 

*Recomendação:* Deixe o computador totalmente livre e aguarde o término do lote de impressão antes de voltar a utilizá-lo.


=======================================================================================
⚠️ AVISOS IMPORTANTES, RISCOS E TERMOS DE UTILIZAÇÃO
=======================================================================================

📌 PROJETO EM DESENVOLVIMENTO CONTÍNUO
Este script e o ecossistema de automação encontram-se em FASE DE TESTES E MELHORIA CONTÍNUA, estando sujeitos a otimizações e correções frequentes por parte do desenvolvedor.

⚠️ POSSIBILIDADE DE ERROS
Por se tratar de uma automação baseada em scripts que interage com a interface do WinThor, O SISTEMA PODE COMETER ERROS DURANTE A EXECUÇÃO devido a variações de velocidade do sistema ou perda de sincronia.

🔥 RISCOS ASSOCIADOS E RECOMENDAÇÕES
1. **RISCO DE IMPRESSÃO INCORRETA OU DUPLICADA:** Se o script perder o foco ou sincronismo, podem ser impressas etiquetas com dados incorretos ou em quantidade indevida.
2. **SUPERVISÃO OBRIGATÓRIA:** Não deixe a automação rodando sem supervisão direta em lotes grandes.
3. **PARADA DE EMERGÊNCIA (F3):** Utilize a tecla **F3** ou feche o ícone do AutoHotkey na barra de tarefas para interromper a execução imediatamente se notar qualquer comportamento anômalo.