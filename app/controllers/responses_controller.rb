class ResponsesController < InheritedResources::Base
  belongs_to :question
  before_filter :set_parents
  
  def create
    if @assigned_question_set && @assigned_question
      create!{ [@assigned_question_set, @assigned_question] }
    else
      create!
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
end
