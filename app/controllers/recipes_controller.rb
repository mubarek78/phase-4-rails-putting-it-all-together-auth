class RecipesController < ApplicationController
    def index
       if session[:user_id]
            recipes = Recipe.all
            render json: recipes, include: :user
       else
            create_blank_user_to_return
        end
    end
    def create
        # Verify user is logged in
        if session[:user_id]
            recipe = Recipe.new(title: params[:title], instructions: params[:instructions], minutes_to_complete: params[:minutes_to_complete], user_id: session[:user_id])
            #Verify that the recipe user id is the same as the user id
            if session[:user_id] == recipe.user_id
                # Validate recipe
                if recipe.valid?
                    recipe.save
                    recipe.validate
                    render json: recipe, include: :user, status: :created
                else
                    render json: {errors: recipe.errors.messages.to_a}, status: :unprocessable_entity
                end
            else
                # Users id does not match
                render json: {error: "User in recipe doesn't match user looged in"}, status: :unauthorized
            end
        else
          # User not logged in  
          create_blank_user_to_return
        end
    end

    private 

    def create_blank_user_to_return
        user = User.new
        user.validate
        render json: {errors: user.errors.full_messages}, status: :unauthorized
    end
end