# Creates an ingredient for the ingredients array in recipe.rb
class Ingredient
  attr_reader :name
  def initialize(ingredient)
    @name = ingredient['name']
    @id = ingredient['id']
  end
end
