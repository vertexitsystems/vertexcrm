require 'test_helper'

class AccountManagersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account_manager = account_managers(:one)
  end

  test "should get index" do
    get account_managers_url
    assert_response :success
  end

  test "should get new" do
    get new_account_manager_url
    assert_response :success
  end

  test "should create account_manager" do
    assert_difference('AccountManager.count') do
      post account_managers_url, params: { account_manager: { name: @account_manager.name, profile_id: @account_manager.profile_id } }
    end

    assert_redirected_to account_manager_url(AccountManager.last)
  end

  test "should show account_manager" do
    get account_manager_url(@account_manager)
    assert_response :success
  end

  test "should get edit" do
    get edit_account_manager_url(@account_manager)
    assert_response :success
  end

  test "should update account_manager" do
    patch account_manager_url(@account_manager), params: { account_manager: { name: @account_manager.name, profile_id: @account_manager.profile_id } }
    assert_redirected_to account_manager_url(@account_manager)
  end

  test "should destroy account_manager" do
    assert_difference('AccountManager.count', -1) do
      delete account_manager_url(@account_manager)
    end

    assert_redirected_to account_managers_url
  end
end
