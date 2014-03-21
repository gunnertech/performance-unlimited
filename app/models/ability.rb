class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    if user.has_role? 'admin'
      can :manage, :all
    elsif user.is_an_admin?
      can :manage, AssignedDivision,      :id => AssignedDivision.with_role('admin', user).pluck('assigned_divisions.id')
      can :manage, AssignedDivision,      :id => Organization.with_role('admin', user).joins{ divisions.assigned_divisions }.pluck('assigned_divisions.id')
      can :manage, PointRange,            :id => Organization.with_role('admin', user).joins{ point_ranges }.pluck('point_ranges.id')
      can :create, AssignedDivision
      can :manage, Division,              :id => Organization.with_role('admin', user).joins{ divisions }.pluck('divisions.id')
      can :create, Division
      can :manage, CompletedSurvey,       :id => Organization.with_role('admin', user).joins{ completed_surveys }.pluck('completed_surveys.id')
      can :create, CompletedSurvey
      can :manage, User,                  :id => Organization.with_role('admin', user).joins{ users }.pluck('users.id')
      can :manage, User,                  :id => user.id
      can :create, User
      can :manage, RecordedMetric,        :id => Organization.with_role('admin', user).joins{ recorded_metrics }.pluck('recorded_metrics.id')
      can :create, RecordedMetric
      can :manage, Metric,                :id => Organization.with_role('admin', user).joins{ metrics }.pluck('metrics.id')
      can :create, Metric
      can :manage, Alert,                 :id => Organization.with_role('admin', user).map(&:alerts).flatten.map(&:id)
      can :create, Alert
      can :read, Alert
      can :manage, AssignedAlert,         :id => Organization.with_role('admin', user).joins{ assigned_alerts }.pluck('assigned_alerts.id')
      can :create, AssignedAlert
      can :manage, Organization,          :id => Organization.with_role('admin', user).pluck('organizations.id')
      can :manage, Survey,                :id => Organization.with_role('admin', user).joins{ surveys }.pluck('surveys.id')
      can :create, Survey
      can :manage, AssignedSurvey,        :id => Organization.with_role('admin', user).joins{ assigned_surveys }.pluck('assigned_surveys.id')
      can :create, AssignedSurvey
      can :manage, AssignedQuestionSet,   :id => Organization.with_role('admin', user).joins{ assigned_question_sets }.pluck('assigned_question_sets.id')
      can :create, AssignedQuestionSet
      can :manage, AssignedQuestionSet,   :id => Organization.with_role('admin', user).joins{ assigned_question_sets }.pluck('assigned_question_sets.id')
      can :create, AssignedQuestion
      can :manage, AssignedQuestion,      :id => Organization.with_role('admin', user).joins{ assigned_question_sets.assigned_questions }.pluck('assigned_questions.id')
      can :create, Response
      can :manage, Response,              :id => Organization.with_role('admin', user).joins{ responses }.pluck('responses.id')
      can :create, Group
      can :manage, Comment,               :id => Organization.with_role('admin', user).joins{ comments }.pluck('comments.id')
      can :create, Comment
      can :manage, Group,                 :id => Organization.with_role('admin', user).joins{ groups }.pluck('groups.id')
      can :create, Authentication
      can :manage, Authentication,        :id => Organization.with_role('admin', user).joins{ authentications }.pluck('authentications.id')
      can :create, PointRange
      can :manage, PointRange,            :id => Organization.with_role('admin', user).joins{ point_ranges }.pluck('point_ranges.id')
    elsif user.is_a_participant?
      can :read, Division, :id => Division.with_role('athlete', user).pluck('divisions.id')
      can :read, Organization, :id => Division.with_role('athlete', user).joins{ organization }.pluck('organizations.id')
      can :read, User, :id => user.id
      can :create, CompletedSurvey
    end
  end
end
