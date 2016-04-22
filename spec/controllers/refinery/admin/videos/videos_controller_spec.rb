require 'spec_helper'

describe Refinery::Videos::Admin::VideosController do

  let(:logged_in_user) { Refinery::Core::NilUser.new }
  describe 'insert video' do
    before do
      @video = FactoryGirl.create(:valid_video, :title => "TestVideo")
    end
    it 'should get videos html' do
      get :insert, :app_dialog => true, :dialog => true
      expect(response).to be_success
      expect(response.body).to match(/TestVideo/)
    end

    it 'should get preview' do
      get :dialog_preview, :id => "video_#{@video.id}", :format => :js
      expect(response).to be_success
      expect(response.body).to match(/iframe/)
    end

    it 'should get preview' do
      post :append_to_wym, :video_id => @video.id, 'video' => {'height' => '100'}, :format => :js
      expect(response).to be_success
      expect(response.body).to match(/iframe/)
    end

  end

end
