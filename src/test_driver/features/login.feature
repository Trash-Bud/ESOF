Feature: Open pages
  The pages should appear when we click on the respective menu options

#  Scenario: login and access the main page
#   When I fill the "usernameinput" field with "up200802821"
#    And  I fill the "passwordinput" field with "************"
#    And I tap the "entrar" button
#    Then I expect the text "Área Pessoal" to be present


 # Scenario: login and access the "Horário" page
  Scenario: Access the "Horário" page
    Given I am logged in
    And I open the drawer
    And I tap the "key_Horário" button
    Then I expect the text "Horário" to be present

  Scenario: Access the "SigarraPay" page
    Given I am logged in
    And I open the drawer
    And I tap the "key_Sigarra Pay" button
    Then I expect the text "Expenses" to be present

  Scenario: Access the "Mapa de Exames" page
    Given I am logged in
    And I open the drawer
    And I tap the "key_Mapa de Exames" button
    Then I expect the text "Exames" to be present

  Scenario: Access the "Autocarros" page
    Given I am logged in
    And I open the drawer
    And I tap the "key_Autocarros" button
    Then I expect the text "Autocarros" to be present

