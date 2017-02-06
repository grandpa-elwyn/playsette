require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:testuser)
  end

  test "login accept validation" do
    get login_path
    post login_path, params: { session:  { username: @user.username, password: 'TestPassword1' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test "login reject validation" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session:  { username: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

end