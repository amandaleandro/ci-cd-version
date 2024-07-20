Construir e Implantar Imagem Docker
Este repositório contém um fluxo de trabalho automatizado para construir e implantar uma imagem Docker em um servidor Droplet. O processo é gerenciado usando GitHub Actions, permitindo uma integração contínua simples e eficaz.

Como Funciona
O fluxo de trabalho é acionado automaticamente quando um push é feito para a branch main. Aqui está uma visão geral das etapas realizadas:

Verificação do Repositório: O repositório é verificado para garantir que todas as alterações necessárias estão presentes.

Construção da Imagem Docker: A imagem Docker é construída a partir de um arquivo Dockerfile presente na pasta my-app. Isso garante que a aplicação seja encapsulada em um ambiente controlado.

Salvando a Imagem Docker em um Arquivo TAR: A imagem Docker é salva em um arquivo TAR para facilitar o transporte.

Copiando a Imagem Docker para o Droplet: O arquivo TAR contendo a imagem Docker é copiado para o servidor Droplet usando a ação scp-action.

Carregando a Imagem Docker do Arquivo TAR: A imagem Docker é carregada no Droplet a partir do arquivo TAR.

Verificação da Imagem Docker: É verificado se a imagem Docker foi carregada corretamente no Droplet.

Como Usar
Para usar este fluxo de trabalho em seu próprio projeto, siga estas etapas:

Configure as Variáveis de Ambiente: Defina as variáveis de ambiente necessárias em suas configurações do GitHub, incluindo DROPLET_HOST, DROPLET_USERNAME e DROPLET_SSH_KEY. Essas variáveis são usadas para se conectar ao Droplet.

Atualize o Dockerfile: Certifique-se de que seu Dockerfile esteja configurado corretamente para construir sua aplicação.

Personalize o Arquivo YAML do Fluxo de Trabalho: Se necessário, personalize o arquivo YAML do fluxo de trabalho para atender às necessidades específicas do seu projeto.

Ative o Fluxo de Trabalho: Depois de configurar tudo, ative o fluxo de trabalho em seu repositório e faça um push para a branch main para iniciar a integração contínua.

Contribuindo
Se você encontrar problemas ou tiver sugestões para melhorar este fluxo de trabalho, sinta-se à vontade para abrir uma issue ou enviar um pull request. Sua contribuição é muito bem-vinda!

