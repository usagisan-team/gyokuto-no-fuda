# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "csv"

CSV.foreach('db/card_category.csv', headers: true) do |row|
  Category.create(
    language: row['language'],
  )
end

CSV.foreach('db/card_word.csv', headers: true) do |row|
  Question.create(
    word: row['word'],
    explain: row['explain'],
    category_id: row['category_id'],
  )
end