# WhiteSur Xfce Extensions

## SCRIPTS E CONFIGURAÇÕES PARA O TEMA WHITESUR NO XFCE

Estes scripts ajudam a tornar o seu ambiente Xfce parecido com o tema Big Sur e minimalismo do antigo Unity (Ubuntu):

### Variante clara

![Versão clara de WhiteSur Xfce Extensions](https://cdn.mastodon.technology/media_attachments/files/106/700/184/877/833/845/original/a149b98c1bab4040.png "Captura de tela do ambiente Xfce")

### Variante escura

![Versão escura de WhiteSur Xfce Extensions](https://cdn.mastodon.technology/media_attachments/files/106/700/184/864/607/130/original/13d4156349d1900f.png "Captura de tela do ambiente Xfce")

Ainda estou "portando" minhas configurações específicas para cá. Você pode verificar o tema original no [repositório oficial][1].


## RESOLVENDO PROBLEMAS

Assumindo que você está instalando o conjunto de software e temas mencionado neste [toot](https://mastodon.technology/@cledson_cavalcanti/106671133699093784), alguns problemas simples vão acontecer e causar artefatos visuais no seu pseudoMac baseado em XFCE.

Esta seção traz algumas alternativas (ou "gambiarras") para esses problemas.

### Texto e ícones brancos no painel com o tema claro

A nova versão da configuração do painel do XFCE contém truques que "driblam" a falta de compatibilidade do tema original.

### Opacidade do plugin Windowck estragando a beleza do painel

O plugin Windowck fica com o fundo opaco ao usar o tema WhiteSur no painel do Xfce. Uma alternativa é manualmente aplicar a transparência no painel.

Para o **tema claro**: altere o fundo do painel para a cor branca (\#FFFFFF) e ajuste a opacidade em 50%. Um clique direito na barra de ajuste abre um campo para digitar o percentual desejado.

Para o **tema escuro**: altere o fundo do painel para a cor cinza escuro (\#373737) e ajuste a opacidade em 50%. Um clique direito na barra de ajuste abre um campo para digitar o percentual desejado.

### Botões de janela duplicados em alguns aplicativos quando uso o Windowck

Em alguns softwares, como o navegador Firefox, você pode ativar a barra de título nativa do gerenciador de janelas e assim esconder essa duplicata de botões.

Em outros, como a calculadora do GNOME, é necessário instalar a biblioteca **gtk3-nocsd** e reiniciar a sessão.

No caso de softwares Flatpak ou Snap com decorações no lado cliente, tente substituir por versões APT quando possível. Se não houver, vide caso do aplicativo Spot, resta chorar mesmo se você é um humilde programador. Ou faça como um digno macOS user e nunca maximize suas janelas!


## NOTA DE AUTORIA

Os temas (incluso ícones) e papéis de parede NÃO SÃO de minha autoria. Todo esse repositório apenas combina temas existentes para que fiquem "coesos" no XFCE, complementando o sistema com alguma inteligência.

by cleds.upper

[1]: https://github.com/vinceliuice/WhiteSur-gtk-theme/
