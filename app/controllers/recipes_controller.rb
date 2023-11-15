class RecipesController < ApplicationController
  before_action :set_recipe, only: %i[show update destroy]
  before_action :authenticate_user!, except: %i[public show]

  # GET /recipes or /recipes.json
  def index
    @recipes = Recipe.all
  end

  # GET /recipes/new
  def new
    @recipe = Recipe.new
  end

  # GET /recipes/1 or /recipes/1.json
  def show
    @recipe = Recipe.find(params[:id])
    @recipe_foods = @recipe.recipe_foods.includes(:food)
  end

  # GET /recipes/public
  def public
    @recipes = Recipe.all.where(public: true)
  end

  # POST /recipes or /recipes.json
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to recipe_url(@recipe), notice: 'Recipe was successfully created.' }
        redirect_to recipes_path
      else
        format.html { render :new, status: :unprocessable_entity }
        redirect_to new_recipe_path
      end
    end
  end

  # PATCH/PUT /recipes/1 or /recipes/1.json
  def update
    @recipe = Recipe.find(params[:id])
    @public = @recipe.public != true
    @recipe.update(public: @public)

    respond_to do |format|
      if @recipe.update(recipe_params)
        format.html { redirect_to recipe_url(@recipe), notice: 'Recipe was successfully updated.' }
        redirect_to recipes_path
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipes/1 or /recipes/1.json
  def destroy
    respond_to do |format|
      if @recipe.destroy
        format.html { redirect_to recipes_url, notice: 'Recipe was successfully destroyed.' }
      else
        format.html { redirect_to recipes_url, alert: 'Failed to destroy the recipe.' }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description, :public)
  end
end
