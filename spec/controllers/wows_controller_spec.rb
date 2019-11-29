require 'rails_helper'

RSpec.describe WowsController, type: :controller do
  describe "wows#destroy action" do
    it "shouldn't allow users who didn't create the wow to destroy it" do
      wow = FactoryBot.create(:wow)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: wow.id }
      expect(response).to have_http_status(:forbidden)
    end


    it "shouldn't let unauthenticated users destroy a wow" do
      wow = FactoryBot.create(:wow)
      delete :destroy, params: { id: wow.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow a user to destroy wows" do
      wow = FactoryBot.create(:wow)
      sign_in wow.user
      delete :destroy, params: { id: wow.id }
      expect(response).to redirect_to root_path
      wow = Wow.find_by_id(wow.id)
      expect(wow).to eq nil
    end

    it "should return a 404 message if we cannot find a wow with the id that is specified" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'SPACEDUCK' }
      expect(response).to have_http_status(:not_found)
    end
  end
  
  describe "wows#update action" do
    it "shouldn't let users who didn't create the wow update it" do
      wow = FactoryBot.create(:wow)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: wow.id, wow: { comment: "Beautiful!", address: "21 Saturn Court, Sudbury, Ontario, Canada P3E 6B8"} }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users update a wow" do
      wow = FactoryBot.create(:wow)
      patch :update, params: { id: wow.id, wow: { comment: "Beautiful!", address: "21 Saturn Court, Sudbury, Ontario, Canada P3E 6B8"} }
      expect(response).to redirect_to new_user_session_path
    end

    it "should allow users to successfully update wows" do
      wow = FactoryBot.create(:wow, comment: "Beautifuls!", address: "22 Saturn Court, Sudbury, Ontario, Canada P3E 6B8")
      sign_in wow.user
      patch :update, params: { id: wow.id, wow: { comment: "Beautiful!", address: "21 Saturn Court, Sudbury, Ontario, Canada P3E 6B8"} }
      expect(response).to redirect_to root_path
      wow.reload
      expect(wow.comment).to eq ("Beautiful!")
      expect(wow.address).to eq ("21 Saturn Court, Sudbury, Ontario, Canada P3E 6B8")
    end

    it "should have http 404 error if the wow cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: "YOLOSWAG", wow: { comment: "Beautiful!", address: "21 Saturn Court, Sudbury, Ontario, Canada P3E 6B8"} }
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      wow = FactoryBot.create(:wow, comment: "Beautifuls", address: "22 Saturn Court, Sudbury, Ontario, Canada P3E 6B8")
      sign_in wow.user
      patch :update, params: { id: wow.id, wow: { comment: " ", address: "22 Saturn Court, Sudbury, Ontario, Canada P3E 6B8"} }
      expect(response).to have_http_status(:unprocessable_entity)
      wow.reload
      expect(wow.comment).to eq "Beautifuls"
      expect(wow.address).to eq "22 Saturn Court, Sudbury, Ontario, Canada P3E 6B8"
    end
  end

  describe "wows#edit action" do
    it "shouldn't let a user who did not create the wow edit a wow" do
      wow = FactoryBot.create(:wow)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: wow.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users edit a wow" do
      wow = FactoryBot.create(:wow)
      get :edit, params: { id: wow.id }
      expect(response).to redirect_to new_user_session_path
    end


    it "should successfully show the edit form if the wow is found" do
      wow = FactoryBot.create(:wow)
      sign_in wow.user
      get :edit, params: { id: wow.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the wow is not found" do
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: 'SWAG' }
      expect(response).to have_http_status(:not_found)
    end
  end


  describe "wows#show action" do
    it "should successfully show the page if the wow is found" do
       wow = FactoryBot.create(:wow)
       get :show, params: { id: wow.id }
       expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the wow is not found" do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
    end
  end

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

      post :create, params: {
        wow: {
        comment: 'Beautiful!', address: '21 Saturn Court, Sudbury, Ontario, Canada P3E 6B8',
        picture: fixture_file_upload("/picture.png", 'image/png')
        }
      }    

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
