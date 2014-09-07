# Creates a recipe for the webpage to latch onto
class Recipe
  attr_reader :id, :name, :description, :instructions, :ingredients
  def initialize(recipe)
    @id = recipe['id']
    @name = recipe['name']
    @instructions = get_initial_instructions(recipe['instructions'])
    @description = get_initial_description(recipe['description'])
    @ingredients = build_ingredients_list(id)
  end

  def build_ingredients_list(recipe_id)
    array = db_connection do |conn|
      conn.exec_params('SELECT name, id FROM ingredients
        WHERE $1 = recipe_id;', [recipe_id])
    end
    ingredients = []
    array.each do |ingredient|
      ingredients << Ingredient.new(ingredient)
    end
    ingredients
  end

  def get_initial_instructions(instruction)
    if instruction.nil?
      return 'This recipe doesn\'t have any instructions.'
    else
      instruction
    end
  end

  def get_initial_description(description)
    if description.nil?
      return 'This recipe doesn\'t have a description.'
    else
      description
    end
  end

  def self.all
    @recipes = []
    raw_recipe_db = db_connection do |conn|
      conn.exec('SELECT * FROM recipes;')
    end
    raw_recipe_db.each do |recipe|
      @recipes << Recipe.new(recipe)
    end
    @recipes
  end

  def self.find(id)
    sql = 'SELECT * FROM recipes WHERE recipes.id = $1'
    result = db_connection do |conn|
      conn.exec(sql, [id])
    end
    Recipe.new(result.first)
  end
end
