Feature: Explore third iteration features
  The pages should appear when we click the respective options

  Scenario: Press the notifications button
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    And I tap the "notifications" button
    Then I expect the text "Notifications" to be present

  Scenario: Access the "SigarraPay" expenses ordenator
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    And I pause for 2 seconds
    And I open the drawer
    And I tap the "key_Sigarra Pay" button
    And I tap the "expenses" button
    And I tap the "Ordenação despesas" button
    And I tap the "Valor a pagar" button
    And I tap the "confirmar ordenação despesa" button
    And I pause for 5 seconds
    Then I expect the text "Expenses" to be present

  Scenario: Generate a bank reference to charge the printing account
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    And I pause for 2 seconds
    And I open the drawer
    And I tap the "key_Sigarra Pay" button
    And I tap the "prints" button
    And I tap the "carregar cartão" button
    Then I expect the text "Charge card" to be present

  Scenario: Click a bank reference
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    And I pause for 2 seconds
    And I open the drawer
    And I tap the "key_Sigarra Pay" button
    And I tap the "bankReferences" button
    Then I expect the text "Bank References" to be present


  Scenario: Access the "SigarraPay" page
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    And I pause for 2 seconds
    And I open the drawer
    And I tap the "key_Sigarra Pay" button
    Then I expect the text "Sigarra Pay" to be present

  Scenario: Open the filter menu
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    And I pause for 2 seconds
    And I open the drawer
    And I tap the "key_Sigarra Pay" button
    And I tap the "expenses" button
    Then I expect the text "Expenses" to be present

  Scenario: Know my active bank references
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    And I pause for 2 seconds
    And I open the drawer
    And I tap the "key_Sigarra Pay" button
    And I tap the "bankReferences" button
    Then I expect the text "Entity" to be present

  Scenario: Know my printouts
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    And I pause for 2 seconds
    And I open the drawer
    And I tap the "key_Sigarra Pay" button
    And I tap the "prints" button
    Then I expect the text "Prints" to be present

  Scenario: Know my printing quotas
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    And I pause for 2 seconds
    And I open the drawer
    And I tap the "key_Sigarra Pay" button
    And I tap the "printingQuotas" button
    Then I expect the text 'Printing quotas attribution history' to be present