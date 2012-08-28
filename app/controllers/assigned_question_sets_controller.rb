class AssignedQuestionSetsController < InheritedResources::Base
  belongs_to :survey
  
  def new
    @assigned_question_set = parent.assigned_question_sets.build
    @assigned_question_set.question_set = QuestionSet.new
  end
  
  # def edit
  #   resource.organization.locales.each do |locale|
  #     resource.question_set.translations.build locale: locale.code
  #   end
  #   
  #   edit!
  # end
  
  def create
    create!{ parent }
  end
  
  def destroy
    destroy!{ parent }
  end
end
