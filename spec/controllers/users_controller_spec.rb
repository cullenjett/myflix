require "rails_helper"

describe UsersController do
  describe "GET new" do
    it "sets @user as a new User" do
      get :new
      expect(assigns(:user)).to be_a(User)
    end
  end # GET new

  describe "POST create" do

    context "successful user sign up" do
      it "redirects to the home page" do
        result = double(:sign_up_result, successful?: true)
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to home_path
      end
    end

    context "failed user sign up" do
      it "renders the new template" do
        result = double(:sign_up_result, successful?: false, error_message: "error")
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: 'irrelevant token'
        expect(response).to render_template :new
      end

      it "sets the flash danger message" do
        result = double(:sign_up_result, successful?: false, error_message: "error")
        allow_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: 'irrelevant token'
        expect(flash[:danger]).to be_present
      end
    end
  end # POST create

  describe "GET show" do
    it_behaves_like "require sign in" do
      let(:action) { get :show, id: 3 }
    end

    it "sets @user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end #GET show

  describe "GET new_with_invitation_token" do
    it "renders the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired token path for invalid tokens" do
      get :new_with_invitation_token, token: 'asjasg'
      expect(response).to redirect_to expired_token_path
    end
  end #GET new_with_invitation_token
end
