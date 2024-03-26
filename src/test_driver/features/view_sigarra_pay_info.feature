Feature: Open SigarraPay
  The pages should appear when we click on the respective menu options

  Scenario: login and access the main page
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    Then I expect the text "Área Pessoal" to be present

  Scenario: Access the "SigarraPay" page
    When I fill the "usernameinput" field with "up201906159"
    And  I fill the "passwordinput" field with "Eduardo2347!!"
    And I tap the "entrar" button
    And I open the drawer
    And I tap the "key_Sigarra Pay" button
    Then I expect the text "Sigarra Pay" to be present

    Scenario: Open the filter menu
      When I fill the "usernameinput" field with "up201906159"
      And  I fill the "passwordinput" field with "Eduardo2347!!"
      And I tap the "entrar" button
      And I open the drawer
      And I tap the "key_Sigarra Pay" button
      And I tap the "0" button
      And I tap the
      Then I expect the text "Despesas" to be present

    Scenario: Know my active bank references
      When I fill the "usernameinput" field with "up201906159"
      And  I fill the "passwordinput" field with "Eduardo2347!!"
      And I tap the "entrar" button
      And I open the drawer
      And I tap the "key_Sigarra Pay" button
      And I tap the "1" button
      Then I expect the text "Entidade" to be present

    Scenario: Know my printouts
      When I fill the "usernameinput" field with "up201906159"
      And  I fill the "passwordinput" field with "Eduardo2347!!"
      And I tap the "entrar" button
      And I open the drawer
      And I tap the "key_Sigarra Pay" button
      And I tap the "2" button
      Then I expect the text "Impressões" to be present

    Scenario: Know my printing quotas
      When I fill the "usernameinput" field with "up201906159"
      And  I fill the "passwordinput" field with "Eduardo2347!!"
      And I tap the "entrar" button
      And I open the drawer
      And I tap the "key_Sigarra Pay" button
      And I tap the "3" button
      Then I expect the text 'Histórico de atribuição' to be present


