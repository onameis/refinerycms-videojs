require 'spec_helper'

module Refinery
  module Videos
    describe VideoFile do
      before(:each) do
        file = File.new(File.join(Rails.root, 'spec/support/fixtures/video.flv'))
        @video_file = FactoryGirl.create(:video_file, :file => file)
      end

      it 'should be invalid' do
        @video_file.file = nil
        expect(@video_file).to be_invalid
      end

      it 'should be invalid again' do
        @video_file.file = nil
        @video_file.use_external = true
        expect(@video_file).to be_invalid
      end

      it 'should be valid' do
        expect(@video_file).to be_valid
      end

      it 'should be valid again' do
        @video_file.file = nil
        @video_file.use_external = true
        @video_file.external_url = 'file.mp4'
        expect(@video_file).to be_valid
      end

      it 'should return true when file exist' do
        expect(@video_file.exist?).to be_truthy
      end

      it 'should return false when file does not exist' do
        @video_file.file = nil
        expect(@video_file.exist?).to be_falsey
      end

      it 'should determine mime_type from url' do
        @video_file = VideoFile.create(:use_external => true, :external_url => 'www')
        expect(@video_file.file_mime_type).to eq('video/mp4')
        @video_file.update_attributes(:external_url => 'www.site.com/video.mp4')
        expect(@video_file.file_mime_type).to eq('video/mp4')
        @video_file.update_attributes(:external_url => 'www.site.com/video.flv')
        expect(@video_file.file_mime_type).to eq('video/flv')
        @video_file.update_attributes(:external_url => 'www.site.com/video.ogg')
        expect(@video_file.file_mime_type).to eq('video/ogg')
        @video_file.update_attributes(:external_url => 'www.site.com/video.webm')
        expect(@video_file.file_mime_type).to eq('video/webm')
      end

    end
  end
end
