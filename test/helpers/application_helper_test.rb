require "test_helper"

describe ApplicationHelper do
  describe "render_date" do
    it "shows a readable date in the Month, Day, Year format with the month name spelled out" do
      # Arrange
      date = Date.today - 2

      # Act
      formatted_date = render_date(date)

      # Assert
      expect(formatted_date).must_include date.to_s
      expect(formatted_date).must_include "3 days ago"
    end

    it "gives back the string [unknown] when date is nil" do
      invalid_date = render_date(nil)
      expect(invalid_date).must_equal "[unknown]"
    end
  end
end