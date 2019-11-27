require 'rails_helper'

RSpec.describe WowsController, type: :controller do
  describe "wows#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "wows#new action" do
    it "should require users to be logged in" do
       get :new
       expect(response).to redirect_to new_user_session_path
    end



    it "should successfully show the new form" do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  

  describe "wows#create action" do
    it "should require users to be logged in" do
      post :create, params: { wow: { comment: 'Beautiful!', address: '21 Saturn Court, Sudbury, Ontario, Canada P3E 6B8' } }
      expect(response).to redirect_to new_user_session_path
    end


    it "should successfully create a new wow in our database" do
      user = FactoryBot.create(:user)
      sign_in user


      post :create, params: { wow: { comment: 'Beautiful!', address: '21 Saturn Court, Sudbury, Ontario, Canada P3E 6B8' } }
      expect(response).to redirect_to root_path
      wow = Wow.last
      expect(wow.comment).to eq ("Beautiful!")
      expect(wow.address).to eq ("21 Saturn Court, Sudbury, Ontario, Canada P3E 6B8")
      expect(wow.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      wow_count = Wow.count
      post :create, params: { wow: { comment: '', address: '21 Saturn Court, Sudbury, Ontario, Canada P3E 6B8' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Wow.count).to eq Wow.count
    end

  end
end
