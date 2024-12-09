require 'rails_helper'

RSpec.describe InformationsController, type: :controller do
  describe "GET #terms_of_service" do
    it "returns a successful response" do
      get :terms_of_service
      expect(response).to be_successful
    end

    it "renders the terms_of_service template" do
      get :terms_of_service
      expect(response).to render_template(:terms_of_service)
    end
  end

  describe "GET #privacy_policy" do
    it "returns a successful response" do
      get :privacy_policy
      expect(response).to be_successful
    end

    it "renders the privacy_policy template" do
      get :privacy_policy
      expect(response).to render_template(:privacy_policy)
    end
  end

  describe "GET #how_to_used" do
    it "returns a successful response" do
      get :how_to_used
      expect(response).to be_successful
    end

    it "renders the how_to_used template" do
      get :how_to_used
      expect(response).to render_template(:how_to_used)
    end
  end
end
