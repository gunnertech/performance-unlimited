class ResponsesController < InheritedResources::Base
  belongs_to :question
  before_filter :set_parents
  
  load_resource :question
  load_and_authorize_resource :response, through: :question, except: [:index]
  
  def create
    if @assigned_question_set && @assigned_question
      create!{ [@assigned_question_set, @assigned_question] }
    else
      create!
    end
    
  end
  
  def update
    if @assigned_question_set && @assigned_question
      update!{ [@assigned_question_set, @assigned_question] }
    else
      update!
    end
  end
  
  def destroy
    if @assigned_question_set && @assigned_question
      destroy!{ [@assigned_question_set, @assigned_question] }
    else
      destroy!
    end
  end
  
  protected
  def set_parents
    @assigned_question = AssignedQuestion.find(params[:assigned_question_id]) if params[:assigned_question_id]
    @assigned_question_set = AssignedQuestionSet.find(params[:assigned_question_set_id]) if params[:assigned_question_set_id]
  end
  
  def collection
    return @responses if @responses
    
    @responses = end_of_association_chain.accessible_by(current_ability)
  end
end
