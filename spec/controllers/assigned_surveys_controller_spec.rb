require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe AssignedSurveysController do

  # This should return the minimal set of attributes required to create a valid
  # AssignedSurvey. As you add validations to AssignedSurvey, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AssignedSurveysController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all assigned_surveys as @assigned_surveys" do
      assigned_survey = AssignedSurvey.create! valid_attributes
      get :index, {}, valid_session
      assigns(:assigned_surveys).should eq([assigned_survey])
    end
  end

  describe "GET show" do
    it "assigns the requested assigned_survey as @assigned_survey" do
      assigned_survey = AssignedSurvey.create! valid_attributes
      get :show, {:id => assigned_survey.to_param}, valid_session
      assigns(:assigned_survey).should eq(assigned_survey)
    end
  end

  describe "GET new" do
    it "assigns a new assigned_survey as @assigned_survey" do
      get :new, {}, valid_session
      assigns(:assigned_survey).should be_a_new(AssignedSurvey)
    end
  end

  describe "GET edit" do
    it "assigns the requested assigned_survey as @assigned_survey" do
      assigned_survey = AssignedSurvey.create! valid_attributes
      get :edit, {:id => assigned_survey.to_param}, valid_session
      assigns(:assigned_survey).should eq(assigned_survey)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new AssignedSurvey" do
        expect {
          post :create, {:assigned_survey => valid_attributes}, valid_session
        }.to change(AssignedSurvey, :count).by(1)
      end

      it "assigns a newly created assigned_survey as @assigned_survey" do
        post :create, {:assigned_survey => valid_attributes}, valid_session
        assigns(:assigned_survey).should be_a(AssignedSurvey)
        assigns(:assigned_survey).should be_persisted
      end

      it "redirects to the created assigned_survey" do
        post :create, {:assigned_survey => valid_attributes}, valid_session
        response.should redirect_to(AssignedSurvey.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved assigned_survey as @assigned_survey" do
        # Trigger the behavior that occurs when invalid params are submitted
        AssignedSurvey.any_instance.stub(:save).and_return(false)
        post :create, {:assigned_survey => {}}, valid_session
        assigns(:assigned_survey).should be_a_new(AssignedSurvey)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        AssignedSurvey.any_instance.stub(:save).and_return(false)
        post :create, {:assigned_survey => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested assigned_survey" do
        assigned_survey = AssignedSurvey.create! valid_attributes
        # Assuming there are no other assigned_surveys in the database, this
        # specifies that the AssignedSurvey created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        AssignedSurvey.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => assigned_survey.to_param, :assigned_survey => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested assigned_survey as @assigned_survey" do
        assigned_survey = AssignedSurvey.create! valid_attributes
        put :update, {:id => assigned_survey.to_param, :assigned_survey => valid_attributes}, valid_session
        assigns(:assigned_survey).should eq(assigned_survey)
      end

      it "redirects to the assigned_survey" do
        assigned_survey = AssignedSurvey.create! valid_attributes
        put :update, {:id => assigned_survey.to_param, :assigned_survey => valid_attributes}, valid_session
        response.should redirect_to(assigned_survey)
      end
    end

    describe "with invalid params" do
      it "assigns the assigned_survey as @assigned_survey" do
        assigned_survey = AssignedSurvey.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AssignedSurvey.any_instance.stub(:save).and_return(false)
        put :update, {:id => assigned_survey.to_param, :assigned_survey => {}}, valid_session
        assigns(:assigned_survey).should eq(assigned_survey)
      end

      it "re-renders the 'edit' template" do
        assigned_survey = AssignedSurvey.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AssignedSurvey.any_instance.stub(:save).and_return(false)
        put :update, {:id => assigned_survey.to_param, :assigned_survey => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested assigned_survey" do
      assigned_survey = AssignedSurvey.create! valid_attributes
      expect {
        delete :destroy, {:id => assigned_survey.to_param}, valid_session
      }.to change(AssignedSurvey, :count).by(-1)
    end

    it "redirects to the assigned_surveys list" do
      assigned_survey = AssignedSurvey.create! valid_attributes
      delete :destroy, {:id => assigned_survey.to_param}, valid_session
      response.should redirect_to(assigned_surveys_url)
    end
  end

end
