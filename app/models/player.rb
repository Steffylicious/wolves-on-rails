# frozen_string_literal: true

class Player < ApplicationRecord
  belongs_to :game
  validates :name, presence: true, uniqueness: {scope: :game_id}
  validates :uid, presence: true, uniqueness: {scope: :game_id}
  validates :role, presence: true

  # Expandable for future custom roles
  enum :role, [:villager, :werewolf]

  before_validation :generate_unique_uid

  private

  def generate_unique_uid
    return unless uid.nil? || player_with_uid_exists?
    loop do
      self.uid = SecureRandom.hex(4)
      break unless player_with_uid_exists?
    end
  end

  def player_with_uid_exists?
    Player.where(uid:).exists?
  end
end

# == Schema Information
#
# Table name: players
#
#  id         :bigint           not null, primary key
#  alive      :boolean          default(TRUE)
#  name       :string(255)      not null
#  role       :integer          default("villager")
#  uid        :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#
# Indexes
#
#  index_players_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#
