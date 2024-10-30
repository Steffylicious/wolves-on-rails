# spec/controllers/players_controller_spec.rb

require "rails_helper"

RSpec.describe PlayersController, type: :controller do
  describe "GET #show" do
    let(:player) { FactoryBot.create(:player) }

    it "retrieves the player and returns as json" do
      get :show, params: {id: player.id}
      expect(response).to have_http_status(:success)
      expect(assigns(:player)).to eq(player)
      expect(response.body).to eq(player.to_json)
    end
  end

  describe "POST #create" do
    let(:game) { FactoryBot.create(:game) }
    context "with valid attributes" do
      it "creates a new player and redirects to the player show page" do
        expect {
          post :create, params: {player: {name: "test", game_code: game.code}}
        }.to change(Player, :count).by(1)
        expect(response).to redirect_to(Player.last)
      end
    end

    context "with invalid attributes" do
      it "returns a json error when name is not provided" do
        post :create, params: {player: {name: nil, game_code: game.code}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("name" => ["can't be blank"])
      end

      it "does not create a new player when name is not provided" do
        expect {
          post :create, params: {player: {name: nil, game_code: game.code}}
        }.to change(Player, :count).by(0)
      end

      it "returns a json error when game is not provided" do
        post :create, params: {player: {name: "player 1", game_code: nil}}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include("game" => ["must exist"])
      end

      it "does not create a new player when game is not provided" do
        expect {
          post :create, params: {player: {name: "player 1", game_code: nil}}
        }.to change(Player, :count).by(0)
      end
    end
  end
end
