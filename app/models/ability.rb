class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    if user.has_role? 'admin'
      can :manage, :all
    end
    
    
    
    can :manage, AssignedDivision, :id => AssignedDivision.with_role('admin', user).pluck('assigned_divisions.id')
    can :manage, AssignedDivision, :id => Organization.with_role('admin', user).joins{ divisions.assigned_divisions }.pluck('assigned_divisions.id')
    can :manage, Division, :id => Organization.with_role('admin', user).joins{ divisions }.pluck('divisions.id')
    
    [Metric, AssignedGroup, AssignedQuestion, AssignedQuestionSet, AssignedSurvey, CompletedSurvey, Group, PointRange, Question, QuestionSet, Response, SelectedResponse, Survey].each do |clazz|
      can :manage, clazz do |resource|
        user.has_role? 'admin', resource.organization
      end
    end
    
    can :manage, User, :id => Organization.with_role('admin', user).pluck('organizations.id')
    
    can :manage, RecordedMetric do |rm|
      !user.new_record? && (rm.new_record? ||  rm.user.organizations.any? { |organization| user.has_role? 'admin', organization })
    end
    
    can :manage, Authentication do |authentication|
      if authentication.authenticationable.isa?(Organization)
        user.has_role? 'admin', authentication.authenticationable
      else
        user.has_role? 'admin', authentication.authenticationable.organization
      end
    end
    
    can :manage, Organization, :id => Organization.with_role('admin', user).map{ |organization| organization.id }
    
    can :create, CompletedSurvey do |completed_survey|
      completed_survey.new_record? || (user.has_role?('athlete', completed_survey.organization))
    end
    
    can :create, SelectedResponse do |selected_response|
      user.has_role? 'athlete', selected_response.organization
    end
      
    can :read, :all unless user.new_record?
  end
end
