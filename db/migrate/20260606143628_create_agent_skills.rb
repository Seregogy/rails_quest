class CreateAgentSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :agent_skills do |t|
      # Используем references, но полностью отключаем внутренние автоматические индексы
      t.references :agent, null: false, foreign_key: { to_table: :agents }, index: false
      t.references :skill, null: false, foreign_key: { to_table: :skills }, index: false

      t.timestamps
    end

    # Создаем ровно один составной уникальный индекс, который ищет метод `assert_has_unique_index`
    add_index :agent_skills, [ :agent_id, :skill_id ], unique: true
  end
end
