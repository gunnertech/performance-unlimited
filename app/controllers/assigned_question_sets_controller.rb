class AssignedQuestionSetsController < InheritedResources::Base
  belongs_to :survey
  
  load_resource :survey
  load_and_authorize_resource :assigned_question_set, through: :survey, except: [:index]
  
  respond_to :json, only: [:update]
  
  def new
    @assigned_question_set = parent.assigned_question_sets.build
    @assigned_question_set.question_set = QuestionSet.new(organization: parent.organization)
  end
  
  def create
    create!{ parent }
  end
  
  def destroy
    destroy!{ parent }
  end
  
  protected
  def collection
    return @assigned_question_sets if @assigned_question_sets
    
    @assigned_question_sets = end_of_association_chain.accessible_by(current_ability)
  end
end
