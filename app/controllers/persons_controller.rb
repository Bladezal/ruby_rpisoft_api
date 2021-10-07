class PersonsController < ApplicationController
    def index
        @persons = Person.all
        render json: @persons
    end

    def show
        @person = Person.find(params[:id])
        render json: @person
    end
end
