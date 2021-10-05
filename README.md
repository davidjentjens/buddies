# Buddies
Um aplicativo em flutter que ajuda as pessoas a encontrar atividades sociais em sua área.

# Planejamento

## Funcionalidades para a G1 (06/10/2021)
- [x] Tela de mapa (puro, apenas com navegação)
- [x] Modelagem de dados
- [ ] Tela de eventos (com eventos mockados criados direto no banco)
  - [x] Tela de detalhes o evento
  - [x] Listagem de eventos
  - [ ] Busca simples
- [x] Tela de próximos eventos (~~com dados mockados~~ com dados dinâmicos)
- [x] Participação simples em eventos

## Funcionalidades para a G2
- [ ] Criação de eventos
- [ ] Edição de eventos
- [ ] Participação de eventos
  - [ ] Confirmação de participação
  - [ ] Formulário após o evento para informar quem realmente participou
  - [ ] Sistema de avaliação dos usuários baseada na participação dos eventos
- [ ] Lógica para exibir eventos destacados
- [ ] Validação das regras de negócio

### Funcionalidades Extra (podem não ser implementadas)
- [ ] Histórico de eventos participados e criados
- [ ] Tratamento de erros para o usuário
- [ ] Google Analytics

### Mudanças de Design adicionais
- [ ] Tornar AppBar mais elegante com transparência e animações
- [ ] Trocar ícones de categorias na Home por imagens com títulos
- [ ] Alterar palheta de cores com a ajuda de designers
- [ ] Exibir eventos destacados na Home em um carrossel

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