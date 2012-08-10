class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    can :manage, :all if user.has_role? :admin
    
    can :create, CompletedSurvey do |completed_survey|
      completed_survey.survey.organization.users.include?(user)
    end
    
    can :create, SelectedResponse do |selected_response|
      selected_response.completed_survey.survey.organization.users.include?(user)
    end
      
    can :read, :all unless user.new_record?
  end
end
