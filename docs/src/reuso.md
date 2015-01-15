# Reuso

## Propriedades do reuso
1. Os itens que estiverem reusando terceiros aparecem em itálico.
2. No formulário os inputs dos itens que estiverem reusando terceiros aparecem com fundo preto.
3. Source da expressão que está reusando
    1. Torna-se o source da expressão reusada se a expressão possuir source.
		    2. Caso contrário, torna-se o email do criador da expressão reusada.

## Atualização da expressão reusada
Se uma expressão é atualizada após ser reusada, nada ocorre com as expressões que a reusaram.

## Atualização de uma expressão que reusou outra
Caso uma expressão que tenha reusado outra seja atualizada com um texto que não foi reusado, então ela perderá suas propriedades de reuso.


## Formulários
### ICS-234
Neste formulário só temos o reuso de estratégias e táticas.

### ICS-202
Neste formulário só temos reuso de objetivos.

#### Limitações
Por questões internas de implementação, o reuso no ICS-202 é puramente textual. Ou seja, internamente o sistema não registra com as propriedades de reuso.


# Reuso de hierarquia
O reuso de hierarquia é exclusivo para estratégias e deve ser ativado através do menu "Tools Config". Quando esta funcionalidade está ativada, o reuso de uma estratégia automáticamente traz as táticas da mesma.

## Táticas reusadas automaticamente
Quando as táticas são criadas automaticamente no reuso de uma estratégia, então elas são marcadas com um azul mais claro, indicando que elas não foram digitadas por um usuário no contexto do incidente atual e por esse motivo, provavelmente precisarão ser alteradas.

Após ser alterada, aprovada ou rejeitada, a tática perde esta coloração, pois consideramos que o usuário responsável pela ação revisou a expressão em questão.

## Barra de sugestões
É comum existirem expressões com textos iguais, quando a opção de reuso de hierarquia está desativada, é irrelevante para o usuário qual expressão ele está utilizando, basta que a mesma tenha o texto que ele precisa. Por isso, quando o reuso de hierarquia está **desativado** o usuário escolhe o texto à ser reusado e o sistema busca a expressão mais antiga com aquele texto para usar no reuso.

Porém, quando o reuso de hierarquia está ativo, o reuso traz não só o texto, como também as táticas desta estratégia, portanto o usuário precisa escolher exatamente qual estratégia será reusada. Para conceber isto, a barra de sugestões adota um sistema multinível.  
Neste modo, os textos que possuem mais de uma estratégia de origem são marcados à direita com um quadrado oco. Ao selecionar esta opção, é mostrada uma nova barra com os incidentes que possuem estratégias com esse texto, e caso o usuário selecione um incidente que tenha mais de uma estratégia com o texto selecionado, então o sistema mostra mais uma barra com a data de criação de cada expressão. Dessa maneira o usuário pode escolher exatamente a estratégia que ele deseja reusar.
