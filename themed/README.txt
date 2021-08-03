===========
 DESCRIÇÃO
===========

O themed, inicialmente, é apenas um daemon para o XFCE que mantém atualizado o tema ou o papel de parede de acordo com o turno diário: manhã, tarde e noite.

Por ser uma versão muito imatura, é preciso alterar à mão o código do script para que ele funcione com outros temas além do WhiteSur.

===============
 COMO UTILIZAR
===============

O themed pode ser utilizado com o conjunto de temas WhiteSur:
* Tema GTK e ícones(1);
* [Opcionalmente] Cor de fundo do painel (somente painel com índice 1); e
* [Opcionalmente] papel de parede(2).

EXEMPLOS:
1. Para manter apenas o tema WhiteSur atualizado:
        $ ./themed.sh T "/ignorar"

2. Manter tema e cor de fundo do painel atualizados:
        $ ./themed.sh TP "/ignorar"

3. Manter o tema e o papel de parede atualizados:
        $ ./themed.sh TW "/home/meu_usuario/Imagens/WhiteSur"

    Perceba a necessidade de indicar o endereço onde estão os papéis de parede. Esse endereço pode ser diferente, o que importa são os arquivos dentro do diretório.

4. Manter o tema, as cores do painel e o papel de parede atualizados:
        $ ./themed.sh A "/home/meu_usuario/Imagens/WhiteSur"


============
 INSTALAÇÃO
============

Você precisa copiar os scripts para o endereço "/home/meu_usuario/opt/themed". Todos devem ter permissão de execução!

Por fim, abra as configurações de Sessão e Inicialização e crie uma entrada de aplicativo com o endereço absoluto do themed, por exemplo:
    /home/meu_usuario/opt/themed/themed.sh TW "/home/meu_usuario/Imagens/WhiteSur"

Você pode editar o comando para especificar o quê o themed vai atualizar.

NOTA: o painel do XFCE ganha artefatos visuais quando é alterado o seu fundo via xfconf, então não recomendo deixar que o themed altere a cor do painel.


==============
 CUSTOMIZANDO
==============

O themed não funciona com outros temas "out-the-box", mas pode ser modificado facilmente para funcionar com temas e papéis de parede desde que sigam a conformidade explicada logo abaixo.


USANDO O THEMED COM TEMA OU PAPÉIS DE PAREDE DE NOMES DIFERENTES

É preciso definir o nome do conjunto de temas diretamente no arquivo themed.sh: há uma variável THEME que recebe o nome "WhiteSur", você deve modificar esta variável para o nome do seu tema ("MeuTema", por exemplo).

O themed funciona com temas que possuem variantes "light" e "dark". Se você instalou um tema MeuTema, o diretório com este nome deve ter um diretório irmão chamado "MeuTema-dark", e ambos devem suportar o gerenciador de janelas do XFCE, respeitando esta estrutura de diretórios:
    (/home/meu_usuario/.)themes:
        ./MeuTema/xfwm4
        ./MeuTema-dark/xfwm4
    (/home/meu_usuario/.)icons:
        ./MeuTema
        ./MeuTema-dark

O trecho "/home/meu_usuario/." também pode ser um dos seguintes endereços:
    /usr/share
    /usr/share/local


(1) Não é possível usar tema GTK e tema de ícones com nomes diferenes. Os nomes dos temas GTK devem ser os mesmos do tema de ícones!

(2) O diretório com os papéis de parede não é importante, mas os nomes dos arquivos devem seguir o exemplo:
    ./MeuTema.formato
    ./MeuTema-light.formato
    ./MeuTema-dark.formato

O arquivo MeuTema.formato é o papel de parede aplicado no turno da tarde (entre 12 e 18 horas), enquanto MeuTema-light.formato é aplicado no turno da manhã (entre 6 e 12 horas). E, obviamente, MeuTema-dark.formato é aplicado a partir das 18 horas.

Por enquanto, é preciso fazer uma cópia do themed para forçá-lo trabalhar com temas e papéis de parede de nomes diferentes, a menos que você altere os nomes dos papéis de parede para coincidir com o nome do tema.


==============
 SOBRE E ETC.
==============

As minhas extensões para o tema WhiteSur são uma tentativa de tornar o ambiente XFCE com um aspecto moderno e inteligente. Faço isso por pura diversão. Mas se você quiser apoiar e ajudar, sinta-se à vontade.

Relate erros ou sugira melhorias neste repositório:
https://github.com/cledsupper/whitesur-xfce-extensions

Apóie esta e outras contribuições à comunidade XFCE, bem como toda a comunidade de software livre, com doações diretas:
* PicPay: @cleds.upper
* PayPal: https://www.paypal.com/donate?hosted_button_id=4FAGT3HK6RRVQ

Veja condições na página do aplicativo Leshto Batt:
https://gitlab.com/cledsupper/leshto-batt/-/blob/master/README.md

by cleds.upper
