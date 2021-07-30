# WhiteSur Xfce Extensions

## SCRIPTS E CONFIGURAÇÕES PARA O TEMA WHITESUR NO XFCE

Estes scripts ajudam a tornar o seu ambiente Xfce parecido com o tema Big Sur e minimalismo do antigo Unity (Ubuntu):

![Prévia de WhiteSur Xfce Extensions](https://cdn.mastodon.technology/media_attachments/files/106/671/101/963/689/471/original/51c3f8958cc6d257.png "Captura de tela do ambiente Xfce")

Ainda estou "portando" minhas configurações específicas para cá. Você pode verificar o tema original no [repositório oficial][1].


## RESOLVENDO PROBLEMAS

Assumindo que você está instalando o conjunto de software e temas mencionado neste [toot](https://mastodon.technology/@cledson_cavalcanti/106671133699093784), alguns problemas simples vão acontecer e causar artefatos visuais no seu pseudoMac baseado em Xfce.

Esta seção traz algumas alternativas (ou "gambiarras") para esses problemas.

### Texto e ícones brancos no painel com o tema claro

Você pode sugerir uma correção abrindo uma issue no [repositório oficial][1]. Por hora, prefira usar a variante escura do tema que não causa esses problemas.

### Opacidade do plugin Windowck estragando a beleza do painel

O plugin Windowck fica com o fundo opaco ao usar o tema WhiteSur no painel do Xfce. Uma alternativa é manualmente aplicar a transparência no painel.

Para o **tema claro**: altere o fundo do painel para a cor branca (\#FFFFFF) e ajuste a opacidade em 50%. Um clique direito na barra de ajuste abre um campo para digitar o percentual desejado.

Para o **tema escuro**: altere o fundo do painel para a cor cinza escuro (\#373737) e ajuste a opacidade em 50%. Um clique direito na barra de ajuste abre um campo para digitar o percentual desejado.

### Botões de janela duplicados em alguns aplicativos quando uso o Windowck

Em alguns softwares, como o navegador Firefox, você pode ativar a barra de título nativa do gerenciador de janelas e assim esconder essa duplicata de botões.

Em outros, como a calculadora do GNOME, é necessário instalar a biblioteca **gtk3-nocsd** e reiniciar a sessão.

No caso de softwares Flatpak ou Snap com decorações no lado cliente, tente substituir por versões APT quando possível. Se não houver, vide caso do aplicativo Spot, resta chorar mesmo se você é um humilde programador. Ou faça como um digno macOS user e nunca maximize suas janelas!

by cleds.upper

[1]: https://github.com/vinceliuice/WhiteSur-gtk-theme/
