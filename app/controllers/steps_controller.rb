class StepsController < ApplicationController
  before_filter :find_site
  before_filter :find_health_check
  
  def index
    @steps = @health_check.steps
  end

  def new
    @step = "#{params[:type]}_step".classify.constantize.new
    render :partial => '/steps/form', :locals => { :step => @step } if request.xhr?
  end
  
  def edit
    @step = Step.find(params[:id])
    render :partial => '/steps/form', :locals => { :step => @step } if request.xhr?
  end
  
  def create
    type_name = "#{params[:type]}_step"
    @step = type_name.classify.constantize.new(params[type_name])
    @step.health_check = @health_check
    if @step.save
      redirect_to :back
    end
  end
  
  def update
    @step = Step.find(params[:id])
    if @step.update_attributes(params[@step.class.name.underscore])
      redirect_to :back
    end
  end
  
  def destroy
    @step = @health_check.steps.find(params[:id])
    @step.destroy
    redirect_to :back
  end
  
  def sort
    params[:step].each_with_index do |id, i|
      Step.find(id).update_attribute(:position, i)
    end
    render :nothing => true
  end

protected
  def find_site
    @site = Site.find_by_permalink!(params[:site_id])
  end

  def find_health_check
    @health_check = @site.health_checks.find_by_permalink!(params[:health_check_id])
  end
end
