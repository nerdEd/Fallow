Given /^I am logged in$/ do
  steps %Q{
    Given I follow "sign in with Twitter" 
    And   I fill in 
  }
end 
