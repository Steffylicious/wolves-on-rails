# spec/controllers/games_controller_spec.rb

require "rails_helper"

RSpec.describe GamesController, type: :controller do
  describe "GET #show" do
    let(:game) { Game.create(code: "testcode", status: :waiting, day: 1, phase: :dawn) }

    it "retrieves the game and renders the show template" do
      get :show, params: {id: game.id}
      expect(response).to have_http_status(:success)
      expect(assigns(:game)).to eq(game)
      expect(response.body).to eq(game.to_json)
    end
  end

  describe "POST #create" do
    it "creates a new game and redirects to the game show page" do
      expect {
        post :create
      }.to change(Game, :count).by(1)
      expect(response).to redirect_to(Game.last)
    end
  end
end
