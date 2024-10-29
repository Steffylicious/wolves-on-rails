# spec/models/game_spec.rb

require "rails_helper"

RSpec.describe Game, type: :model do
  it "automatically generates a code if not present" do
    game = Game.new(code: nil)
    expect(game).to be_valid
    expect(game.code).to_not be_nil
  end

  it "is not valid without a status" do
    game = Game.new(status: nil)
    expect(game).to_not be_valid
  end

  it "is not valid without a day" do
    game = Game.new(day: nil)
    expect(game).to_not be_valid
  end

  it "is not valid without a phase" do
    game = Game.new(phase: nil)
    expect(game).to_not be_valid
  end

  it "will generate new code if attempting to create duplicate" do
    initial_game = Game.create
    game = Game.new(code: initial_game.code)
    expect(game).to be_valid

    expect(game.code).to_not eq(initial_game.code)
  end

  it "can create a game with a duplicate if game exists with code in finished status" do
    initial_game = Game.create(code: "abcdefg", status: :finished)
    game = Game.new(code: initial_game.code)
    expect(game).to be_valid
    expect(game.code).to eq(initial_game.code)
  end

  describe "#begin" do
    it "can begin a game" do
      game = Game.create(status: :waiting)
      game.begin
      expect(game).to be_playing
      expect(game.day).to eq(1)
      expect(game.phase).to eq("dawn")
    end

    it "cannot begin a game that has already begun" do
      game = Game.create(status: :playing)
      expect { game.begin }.to raise_error("Game has already begun")
    end

    it "cannot begin a game that has already finished" do
      game = Game.create(status: :finished)
      expect { game.begin }.to raise_error("Game has already finished")
    end
  end

  describe "#progress" do
    it "can progress a game" do
      game = Game.create(status: :playing, phase: :dawn)
      game.progress
      expect(game).to be_discussion
    end

    it "cannot progress a game that has not begun" do
      game = Game.create(status: :waiting)
      expect { game.progress }.to raise_error("Game has not begun")
    end

    it "cannot progress a game that has already finished" do
      game = Game.create(status: :finished)
      expect { game.progress }.to raise_error("Game has already finished")
    end

    it "can progress a game from discussion to voting" do
      game = Game.create(status: :playing, phase: :discussion)
      game.progress
      expect(game).to be_voting
    end

    it "can progress a game from voting to action" do
      game = Game.create(status: :playing, phase: :voting)
      game.progress
      expect(game).to be_action
    end

    it "can progress a game from action to night" do
      game = Game.create(status: :playing, phase: :action)
      game.progress
      expect(game).to be_night
    end

    it "can progress a game from night to dawn" do
      game = Game.create(status: :playing, phase: :night)
      game.progress
      expect(game).to be_dawn
    end
  end
end
