Feature: Explore SigarraPay features
  The pages should appear when we click the respective options

  Scenario: Access the "SigarraPay" expenses ordenator
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    And I open the drawer
    And I tap the "key_Sigarra Pay" button
    And I tap the "expenses" button
    And I tap the "Ordenação despesas" button
    And I tap the "Valor a pagar" button
    And I tap the "confirmar ordenação despesa" button
    Then I expect the text "Despesas" to be present

  Scenario: Generate a bank reference to charge the printing account
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    And I open the drawer
    And I tap the "key_Sigarra Pay" button
    And I tap the "prints" button
    And I tap the "carregar cartão" button
    Then I expect the text "Carregar Cartão" to be present

  Scenario: Click a bank reference
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    And I open the drawer
    And I tap the "key_Sigarra Pay" button
    And I tap the "bankReferences" button
    And I tap the "bankRef 0" button
    Then I expect the text "Válido até" to be present