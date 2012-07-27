class AssignedQuestionsController < InheritedResources::Base
  belongs_to :assigned_question_set
  
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
end
