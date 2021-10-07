class ClientsController < ApplicationController
    def index
        @clients = Client.all
        render json: @clients, include: [:person => {include:[:country, :role, :project]}]
    end

    def show
        @client = Client.find(params[:id])
        render json: @client, include: [:person => {include:[:country, :role, :project]}]
    end

    def create
        @person = person(params.except(:client_doc_number,:fantasy_name,:client,:controller,:action,:project,:role,:country))
        
        if !params[:project].empty? 
            @person.project = tag('project', params[:project]) 
        end
        if !params[:role].empty? 
            @person.role = tag('role', params[:role])
        end
        if !params[:country].empty? 
            @person.country = tag('country', params[:country])
        end
        if @person.save
            @client = @person.clients.create(client_params)
            if @client.save
                render json: @client, include: [:person => {include:[:country, :role, :project]}]
            else
                render json: @client.errors, status: :unprocessable_entity
            end
        else
            render json: @person.errors, status: :unprocessable_entity
        end
        
    end

    def update
        @client = client.find(params[:id])

        if !params[:project].empty? 
            @client.person.project = tag('project', params[:project]) 
        else
            @client.person.project = nil
        end
        if !params[:role].empty? 
            @client.person.role = tag('role', params[:role])
        else
            @client.person.role = nil
        end
        if !params[:country].empty? 
            @client.person.country = tag('country', params[:country])
        else
            @client.person.country = nil
        end
        
        if !@client.person.update(params.except(:start_date,:salary,:section,:client,:controller,:action,:project,:role,:country))
            render json: @person.errors, status: :unprocessable_entity
        else
            if @client.update(client_params)
                render json: @client, include: [:person => {include:[:country, :role, :project]}]
            else
                render json: @client.errors, status: :unprocessable_entity
            end
        end
    end

    def destroy
        @client = client.find(params[:id])
        @client.destroy
        render json: @client
    end
    
    private
        def client_params
            params.require(:client)
                  .permit(:first_name,:last_name,:birth_date,:doc_number,:phone_number,:address,:sex,:project,:role,:country,:client_doc_number,:fantasy_name)
        end

    private
        def tag(type, tag_name)
            case type
            when 'country'
                @tag = Country.find_or_create_by(name: tag_name)
            
            when 'role'
                @tag = Role.find_or_create_by(name: tag_name)
                
            when 'project'
                @tag = Project.find_or_create_by(name: tag_name)
            
            end
            @tag
        end
    private 
        def person(data)
            data.permit!
            @person = Person.find_by(doc_number: data[:doc_number])
            if @person.nil? 
                @person = Person.new(data)
            end
            @person
        end
end
