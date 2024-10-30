# frozen_string_literal: true

class Game < ApplicationRecord
  validates :code, presence: true
  validates :status, presence: true
  validates :day, presence: true
  validates :phase, presence: true

  enum :status, [:waiting, :playing, :finished]
  enum :phase, [:dawn, :discussion, :voting, :action, :night]

  has_many :players

  before_validation :generate_unique_code

  def begin
    raise "Game has already begun" if playing?
    raise "Game has already finished" if finished?

    update(status: :playing, day: 1, phase: :dawn)
  end

  def progress
    raise "Game has not begun" if waiting?
    raise "Game has already finished" if finished?

    case phase
    when "dawn"
      update(phase: :discussion)
    when "discussion"
      update(phase: :voting)
    when "voting"
      update(phase: :action)
    when "action"
      update(phase: :night)
    when "night"
      update(day: day + 1, phase: :dawn)
    end
  end

  def finish
    raise "Game has not begun" if waiting?
    raise "Game has already finished" if finished?

    update(status: :finished)
  end

  private

  def generate_unique_code
    return unless code.nil? || unfinished_game_with_code_exists?
    loop do
      self.code = SecureRandom.hex(4)
      break unless unfinished_game_with_code_exists?
    end
  end

  def unfinished_game_with_code_exists?
    Game.where(code:).where(status: [:waiting, :playing]).exists?
  end
end

# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  admin_uid  :string(255)
#  code       :string(255)
#  day        :integer          default(0)
#  phase      :integer          default("dawn")
#  status     :integer          default("waiting")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
