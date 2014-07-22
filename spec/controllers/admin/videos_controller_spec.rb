require "rails_helper"

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end
    it_behaves_like "require admin" do
      let(:action) { get :new }
    end

    it "sets @video to a new Video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of(Video)
      expect(assigns(:video)).to be_new_record
    end

    it "sets the flash[:danger] message for regular user" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end
  end #GET new

  describe "POST create" do
    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end
    it_behaves_like "require admin" do
      let(:action) { post :new }
    end

    context "with valid inputs" do
      it "redirects to the add new video page" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: 'Monk', category_id: category.id, description: "We writtin' tests!" }
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: 'Monk', category_id: category.id, description: "We writtin' tests!" }
        expect(category.videos.count).to eq(1)
      end

      it "sets the flash[:success] message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { title: 'Monk', category_id: category.id, description: "We writtin' tests!" }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      it "does not create a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id, description: "We writtin' tests!" }
        expect(category.videos.count).to eq(0)
      end

      it "renders the new template" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id, description: "We writtin' tests!" }
        expect(response).to render_template :new
      end

      it "sets @video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id, description: "We writtin' tests!" }
        expect(assigns(:video)).to be_present
      end

      it "sets the flash[:danger] message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id, description: "We writtin' tests!" }
        expect(flash[:danger]).to be_present
      end
    end
  end #POST create
end