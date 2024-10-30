# spec/models/player_spec.rb

require "rails_helper"

RSpec.describe Player, type: :model do
  it "automatically generates a uid if not present" do
    player = FactoryBot.create(:player, uid: nil)
    expect(player).to be_valid
    expect(player.uid).to_not be_nil
  end

  it "is not valid without a name" do
    expect { FactoryBot.create(:player, name: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end

  it "is not valid without a game" do
    expect { FactoryBot.create(:player, game: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Game must exist")
  end

  it "is not valid without a role" do
    expect { FactoryBot.create(:player, role: nil) }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Role can't be blank")
  end

  it "is not valid if name is not unique to game" do
    player_1 = FactoryBot.create(:player)
    player_2 = FactoryBot.build(:player, game: player_1.game, name: player_1.name)
    expect(player_2).to_not be_valid
  end

  it "generates new uid if not unique to game" do
    player_1 = FactoryBot.create(:player)
    player_2 = FactoryBot.create(:player, game: player_1.game, uid: player_1.uid)
    expect(player_1.uid).to_not eq(player_2.uid)
  end
end
