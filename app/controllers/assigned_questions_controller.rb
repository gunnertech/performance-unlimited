class AssignedQuestionsController < InheritedResources::Base
  belongs_to :assigned_question_set
  
  respond_to :json, only: [:update]
  
  def new
    @assigned_question = parent.assigned_questions.build
    @assigned_question.question = Question.new
  end
  
  def create
    create!{ [parent.survey, parent] }
  end
  
  def destroy
    destroy!{ [parent.survey, parent] }
  end
  
  protected
  def collection
    return @assigned_questions if @assigned_questions
    
    @assigned_questions = end_of_association_chain.accessible_by(current_ability)
  end
  
end
