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

describe PointRangesController do

  # This should return the minimal set of attributes required to create a valid
  # PointRange. As you add validations to PointRange, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PointRangesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all point_ranges as @point_ranges" do
      point_range = PointRange.create! valid_attributes
      get :index, {}, valid_session
      assigns(:point_ranges).should eq([point_range])
    end
  end

  describe "GET show" do
    it "assigns the requested point_range as @point_range" do
      point_range = PointRange.create! valid_attributes
      get :show, {:id => point_range.to_param}, valid_session
      assigns(:point_range).should eq(point_range)
    end
  end

  describe "GET new" do
    it "assigns a new point_range as @point_range" do
      get :new, {}, valid_session
      assigns(:point_range).should be_a_new(PointRange)
    end
  end

  describe "GET edit" do
    it "assigns the requested point_range as @point_range" do
      point_range = PointRange.create! valid_attributes
      get :edit, {:id => point_range.to_param}, valid_session
      assigns(:point_range).should eq(point_range)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new PointRange" do
        expect {
          post :create, {:point_range => valid_attributes}, valid_session
        }.to change(PointRange, :count).by(1)
      end

      it "assigns a newly created point_range as @point_range" do
        post :create, {:point_range => valid_attributes}, valid_session
        assigns(:point_range).should be_a(PointRange)
        assigns(:point_range).should be_persisted
      end

      it "redirects to the created point_range" do
        post :create, {:point_range => valid_attributes}, valid_session
        response.should redirect_to(PointRange.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved point_range as @point_range" do
        # Trigger the behavior that occurs when invalid params are submitted
        PointRange.any_instance.stub(:save).and_return(false)
        post :create, {:point_range => {}}, valid_session
        assigns(:point_range).should be_a_new(PointRange)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        PointRange.any_instance.stub(:save).and_return(false)
        post :create, {:point_range => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested point_range" do
        point_range = PointRange.create! valid_attributes
        # Assuming there are no other point_ranges in the database, this
        # specifies that the PointRange created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        PointRange.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => point_range.to_param, :point_range => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested point_range as @point_range" do
        point_range = PointRange.create! valid_attributes
        put :update, {:id => point_range.to_param, :point_range => valid_attributes}, valid_session
        assigns(:point_range).should eq(point_range)
      end

      it "redirects to the point_range" do
        point_range = PointRange.create! valid_attributes
        put :update, {:id => point_range.to_param, :point_range => valid_attributes}, valid_session
        response.should redirect_to(point_range)
      end
    end

    describe "with invalid params" do
      it "assigns the point_range as @point_range" do
        point_range = PointRange.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        PointRange.any_instance.stub(:save).and_return(false)
        put :update, {:id => point_range.to_param, :point_range => {}}, valid_session
        assigns(:point_range).should eq(point_range)
      end

      it "re-renders the 'edit' template" do
        point_range = PointRange.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        PointRange.any_instance.stub(:save).and_return(false)
        put :update, {:id => point_range.to_param, :point_range => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested point_range" do
      point_range = PointRange.create! valid_attributes
      expect {
        delete :destroy, {:id => point_range.to_param}, valid_session
      }.to change(PointRange, :count).by(-1)
    end

    it "redirects to the point_ranges list" do
      point_range = PointRange.create! valid_attributes
      delete :destroy, {:id => point_range.to_param}, valid_session
      response.should redirect_to(point_ranges_url)
    end
  end

end
