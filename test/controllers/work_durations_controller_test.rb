require 'test_helper'

class WorkDurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @work_duration = work_durations(:one)
  end

  test "should get index" do
    get work_durations_url
    assert_response :success
  end

  test "should get new" do
    get new_work_duration_url
    assert_response :success
  end

  test "should create work_duration" do
    assert_difference('WorkDuration.count') do
      post work_durations_url, params: { work_duration: { employee_id: @work_duration.employee_id, hours: @work_duration.hours, work_day: @work_duration.work_day } }
    end

    assert_redirected_to work_duration_url(WorkDuration.last)
  end

  test "should show work_duration" do
    get work_duration_url(@work_duration)
    assert_response :success
  end

  test "should get edit" do
    get edit_work_duration_url(@work_duration)
    assert_response :success
  end

  test "should update work_duration" do
    patch work_duration_url(@work_duration), params: { work_duration: { employee_id: @work_duration.employee_id, hours: @work_duration.hours, work_day: @work_duration.work_day } }
    assert_redirected_to work_duration_url(@work_duration)
  end

  test "should destroy work_duration" do
    assert_difference('WorkDuration.count', -1) do
      delete work_duration_url(@work_duration)
    end

    assert_redirected_to work_durations_url
  end
end
