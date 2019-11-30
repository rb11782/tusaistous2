require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  describe "ratings#create action" do
      it "should allow users to create ratings on wows" do
        wow = FactoryBot.create(:wow)
        user = FactoryBot.create(:user)
        sign_in user

        post :create, params: { wow_id: wow.id, rating: {comment: 'awesome wow'}}
        expect(response).to redirect_to root_path
        expect(wow.ratings.length).to eq 1
        expect(wow.ratings.first.comment).to eq "awesome wow"
      end

      it "should require a user to be logged in to rate on a wow" do
        wow = FactoryBot.create(:wow)
        post :create, params: { wow_id: wow.id, rating: { comment: 'awesome wow' }}
        expect(response).to redirect_to new_user_session_path
      end

      it "should return http status code of not found if the wow isn't found" do
        user = FactoryBot.create(:user)
        sign_in user
        post :create, params: { wow_id: 'YOLOSWAG', rating: { comment: 'awesome wow' }}
        expect(response).to have_http_status :not_found
      end
  end
end