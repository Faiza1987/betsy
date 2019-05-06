require "test_helper"

describe ReviewsController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
end

# brought over from products controller, adapt for reviews

# describe "review" do
#   it "should check for user log in" do
#     user = users(:new_user)
#     perform_login(user)
#     session[:user_id] = user.id
#     product = products(:glitter_bomb)

#     new_review = {
#       rating: 5,
#       description: "glitter is gr8t",
#     }

#     expect {
#       post review_path(product.id), params: new_review
#     }.must_change("Review.count", +1)

#     must_respond_with :redirect
#     expect(flash[:success]).must_equal "Review posted!"
#     must_redirect_to product_path(product.reviews.last.product_id)
#   end

#   it "should not allow merchant to review own product" do
#     # add sample data for glitter_bomb and associated merchant
#     # change user to one w/ glitter_bomb
#     user = User.all.sample
#     perform_login(user)
#     session[:user_id] = user.id
#     product = products(:glitter_bomb)

#     new_review = {
#       rating: 5,
#       comment: "glitter is gr8t",
#     }

#     expect {
#       post review_path(product.id), params: new_review
#     }.wont_change("Review.count")

#     must_respond_with :redirect
#     expect(flash[:error]).must_equal "Cannot review own product."
#     must_redirect_to product_path(@review.product_id)
#   end

#   it "should not save review if not logged in" do
#     product = products(:chair)

#     new_review = {
#       rating: 5,
#       comment: "glitter is gr8t",
#     }

#     expect {
#       post review_path(product.id), params: new_review
#     }.wont_change("Review.count")

#     must_respond_with :redirect
#     expect(flash[:error]).must_equal "Must be logged in."
#     must_redirect_to product_path(product.id)
#   end
# end
