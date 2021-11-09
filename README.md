# Buddies
Um aplicativo em flutter que ajuda as pessoas a encontrar atividades sociais em sua área.

# Planejamento

## Funcionalidades para a G1 (06/10/2021)
- [x] Tela de mapa (puro, apenas com navegação)
- [x] Modelagem de dados
- [x] Tela de eventos (com eventos mockados criados direto no banco)
  - [x] Tela de detalhes o evento
  - [x] Listagem de eventos
  - [x] Busca ~~simples~~ completa
- [x] Tela de próximos eventos (~~com dados mockados~~ com dados dinâmicos)
- [x] Participação simples em eventos

## Funcionalidades para a G2
- [x] Gerenciamento de eventos
  - [x] Criação de eventos
  - [x] Edição de eventos
  - [x] Remoção de eventos
- [ ] Participação de eventos
  - [x] Confirmação de participação
  - [ ] Formulário após o evento para informar quem realmente participou
  - [ ] Sistema de avaliação dos usuários baseada na participação dos eventos
- [x] Lógica para exibir eventos destacados
- [x] Validação das regras de negócio

### Funcionalidades Extra (podem não ser implementadas)
- [x] Google Analytics
- [x] Tratamento de erros para o usuário
- [ ] Histórico de eventos participados e criados
- [ ] Armazenamento dos interesses do usuário
- [ ] Scheduler de notificações de eventos

### Mudanças de Design adicionais
- [x] Trocar ícones de categorias na Home por imagens com títulos
- [x] Exibir eventos destacados na Home em um carrossel
- [ ] Tornar AppBar mais elegante com transparência e animações
- [ ] Alterar palheta de cores com a ajuda de designers

---

## Funcionalidades obrigatórias para a G1 (pelo menos 6)
1. [x] Widgets ListTile ou Card  (contendo um ícone ou imagem, e título)
2. [x] Criar um layout mais complexo usando widgets Row/Column aninhados, Grid ou stack
3. [x] Widget Container: para alterar os espaçamentos de borda de um widget filho
4. [x] Navegação entre telas usando named routes: pelo menos 3 níveis de push/pop
5. [x] Uso de Theme e TextTheme: para customizar o look&feel do seu app 
6. [x] Usar HTTP para acesso de alguma API para buscar uma coleção de dados ou imagens de um servidor backend (*) e apresentação em uma ListView
7. [ ] ~~Uso do GestureDetection para redefinir uma gesture diferente sobre algum widget “acionável”~~
8. [ ] ~~Usar o image_picker~~

## Funcionalidades obrigatórias para a G2 (pelo menos 5)
1. [x] Gerenciamento de um estado global do seu app usando BLOC/Streams, MobX ou Provider 
2. [ ] Banco de dados local usando sqflite **[Dúvida!]**
3. [ ] ~~Captura de Imagem ou de audio~~
4. [ ] Uso de Method ou Event Channel (para acessar algum sensor ou bateria do dispositivo) **[Dúvida!]**
5. [x] Streams e widget StreamBuilder
6. [x] Uso do Plugin Local Notifications
7. [ ] Internacionalização em pelo menos 2 línguas (BR/ENG/ES)