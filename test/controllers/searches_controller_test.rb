require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test "should get search_result" do
    get searches_search_result_url
    assert_response :success
  end
end
