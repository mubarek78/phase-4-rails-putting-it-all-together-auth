class SessionsController < ApplicationController
    def create
        user = User.find_by(username: params[:username])
        if User.exists?(username: params[:username])
            if user&.authenticate(params[:password])
                session[:user_id] = user.id
                render json: user, status: :created
            else
                render json: {errors: user.errors.full_messages}, status: :unauthorized
            end
        else
            create_blank_user_to_return    
        end
        
    end
    def destroy 
        if session[:user_id]
            session.delete :user_id
            head :no_content
        else
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