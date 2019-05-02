require "test_helper"

describe HomepageController do
  it "should get index" do
    get homepage_index_url
    value(response).must_be :success?
  end

end
