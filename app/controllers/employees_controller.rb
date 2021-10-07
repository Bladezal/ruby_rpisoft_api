class EmployeesController < ApplicationController
    def index
        @employees = Employee.all
        render json: @employees, include: [:person => {include:[:country, :role, :project]}]
    end

    def show
        @employee = Employee.find(params[:id])
        render json: @employee, include: [:person => {include:[:country, :role, :project]}]
    end

    def create
        @person = person(params.except(:start_date,:salary,:section,:employee,:controller,:action,:project,:role,:country))
        
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
            @employee = @person.employees.create(employee_params)
            if @employee.save
                render json: @employee, include: [:person => {include:[:country, :role, :project]}]
            else
                render json: @employee.errors, status: :unprocessable_entity
            end
        else
            render json: @person.errors, status: :unprocessable_entity
        end
        
    end

    def update
        @employee = Employee.find(params[:id])

        if !params[:project].empty? 
            @employee.person.project = tag('project', params[:project]) 
        else
            @employee.person.project = nil
        end
        if !params[:role].empty? 
            @employee.person.role = tag('role', params[:role])
        else
            @employee.person.role = nil
        end
        if !params[:country].empty? 
            @employee.person.country = tag('country', params[:country])
        else
            @employee.person.country = nil
        end
        
        if !@employee.person.update(params.except(:start_date,:salary,:section,:employee,:controller,:action,:project,:role,:country))
            render json: @person.errors, status: :unprocessable_entity
        else
            if @employee.update(employee_params)
                render json: @employee, include: [:person => {include:[:country, :role, :project]}]
            else
                render json: @employee.errors, status: :unprocessable_entity
            end
        end
    end

    def destroy
        @employee = Employee.find(params[:id])
        @employee.destroy
        render json: @employee
    end
    
    private
        def employee_params
            params.require(:employee)
                  .permit(:first_name,:last_name,:birth_date,:doc_number,:phone_number,:address,:sex,:project,:role,:country,:start_date,:salary,:section)
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
