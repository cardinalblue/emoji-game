class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string      :question
      t.string      :answer

      t.string      :last_guess
      t.integer     :guesses_count,       default: 0

      t.text        :board

      t.boolean     :is_guessed,          default: false
      t.timestamps
    end
  end
end
