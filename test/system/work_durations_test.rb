require "application_system_test_case"

class WorkDurationsTest < ApplicationSystemTestCase
  setup do
    @work_duration = work_durations(:one)
  end

  test "visiting the index" do
    visit work_durations_url
    assert_selector "h1", text: "Work Durations"
  end

  test "creating a Work duration" do
    visit work_durations_url
    click_on "New Work Duration"

    fill_in "Employee", with: @work_duration.employee_id
    fill_in "Hours", with: @work_duration.hours
    fill_in "Work day", with: @work_duration.work_day
    click_on "Create Work duration"

    assert_text "Work duration was successfully created"
    click_on "Back"
  end

  test "updating a Work duration" do
    visit work_durations_url
    click_on "Edit", match: :first

    fill_in "Employee", with: @work_duration.employee_id
    fill_in "Hours", with: @work_duration.hours
    fill_in "Work day", with: @work_duration.work_day
    click_on "Update Work duration"

    assert_text "Work duration was successfully updated"
    click_on "Back"
  end

  test "destroying a Work duration" do
    visit work_durations_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Work duration was successfully destroyed"
  end
end
