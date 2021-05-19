require "application_system_test_case"

class AccountManagersTest < ApplicationSystemTestCase
  setup do
    @account_manager = account_managers(:one)
  end

  test "visiting the index" do
    visit account_managers_url
    assert_selector "h1", text: "Account Managers"
  end

  test "creating a Account manager" do
    visit account_managers_url
    click_on "New Account Manager"

    fill_in "Name", with: @account_manager.name
    fill_in "Profile", with: @account_manager.profile_id
    click_on "Create Account manager"

    assert_text "Account manager was successfully created"
    click_on "Back"
  end

  test "updating a Account manager" do
    visit account_managers_url
    click_on "Edit", match: :first

    fill_in "Name", with: @account_manager.name
    fill_in "Profile", with: @account_manager.profile_id
    click_on "Update Account manager"

    assert_text "Account manager was successfully updated"
    click_on "Back"
  end

  test "destroying a Account manager" do
    visit account_managers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Account manager was successfully destroyed"
  end
end
