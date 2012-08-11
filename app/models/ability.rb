class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    can :manage, :all if user.has_role? 'admin'
    
    can :manage, AssignedDivision, :id => AssignedDivision.with_role('admin', user).map{ |assigned_division| assigned_division.id }
    
    [AssignedDivision, AssignedGroup, AssignedQuestion, AssignedQuestionSet, AssignedSurvey, CompletedSurvey, Division, Group, PointRange, Question, QuestionSet, Response, SelectedResponse, Survey].each do |clazz|
      can :manage, clazz do |resource|
        user.has_role 'admin', resource.organization
      end
    end
    
    can :manage, User do |u|
      u.new_record? ||  u.organizations.any? { |organization| user.has_role 'admin', organization }
    end
    
    can :manage, Authentication do |authentication|
      if authentication.authenticationable.isa?(Organization)
        user.has_role 'admin', authentication.authenticationable
      else
        user.has_role 'admin', authentication.authenticationable.organization
      end
    end
    
    can :manage, Organization, :id => Organization.with_role('admin', user).map{ |organization| organization.id }
    
    can :create, CompletedSurvey do |completed_survey|
      user.has_role? 'athlete', completed_survey.organization
    end
    
    can :create, SelectedResponse do |selected_response|
      user.has_role? 'athlete', selected_response.organization
    end
      
    can :read, :all unless user.new_record?
  end
end
