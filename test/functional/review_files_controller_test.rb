require File.dirname(__FILE__) + '/../test_helper'
require 'review_files_controller'
require 'fileutils'



# Re-raise errors caught by the controller.
class ReviewFilesController; def rescue_action(e) raise e end; end

class ReviewFilesControllerTest < ActionController::TestCase

  fixtures :all

  def setup
    @controller = ReviewFilesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session[:user] = User.find(users(:student1).id )
    roleid = User.find(users(:student1).id).role_id
    Role.rebuild_cache

    Role.find(roleid).cache[:credentials]
    @request.session[:credentials] = Role.find(roleid).cache[:credentials]
    @request.session[:credentials] = nil if @request.session[:credentials].is_a? YAML::Object
    @settings = SystemSettings.find(:first)

    AuthController.set_current_role(roleid,@request.session)
    @participantId = participants(:par1).id
    @reviewFileId = review_files(:one).id
    @reviewFileWithNewVersionId = review_files(:three).id
    @file_not_zip = fixture_file_upload('files/dummyfile', 'multipart/form-data')
    @file_zip = fixture_file_upload('files/dummy.zip', 'multipart/form-data')

  end

  def teardown
    # delete the temporary folder
    FileUtils.rm_rf (Dir.pwd + "/pg_data")
  end

  def test_submit_review_file_for_non_zip_files
    post :submit_review_file, :participant_id  => @participantId,
         :uploaded_review_file => @file_not_zip
    assert_equal "Uploaded file is not a zip file. Please upload zip files only.",
                 flash[:error]
    assert_redirected_to :action => "show_all_submitted_files"
  end


  def test_submit_review_file_for_zip_files_for_htm_request
    assigns(:review_file)
    assert assigns(:success)
    post :submit_review_file,   :participant_id  => @participantId,
         :uploaded_review_file => @file_zip, :format => "html"

    assert_redirected_to :action => "show_all_submitted_files",
                         :params => {:participant_id => @participantId}
  end

  def test_submit_review_file_for_zip_files_for_xml_request
    post :submit_review_file,   :participant_id  => @participantId,
         :uploaded_review_file => @file_zip, :format => "xml"
    assigns(:review_file)
    assert assigns(:success)
    assert_select 'author-participant-id' , /#{@participantId}/
    assert_response :success
  end

  def test_show_all_submitted_files
    #TODO this method has a "stage" param which is never used???
    post :show_all_submitted_files , :participant_id  => @participantId,
         :stage => nil
    #positive test cases
    assigns(:participant)
    assigns(:file_version_map)
    assigns(:file_id_map)
    assigns(:latest_version_number)
    # check if the correct file is there in the list
    assert_not_nil assigns(:file_version_map)['dummyfile']
    assert_response 200
  end

  def test_show_code_files

    post :show_code_file, :participant_id => @participantId,
         :review_file_id => @reviewFileId, :versions => [1]
    # test for the file content
    assert_equal ["some random dummy text."], assigns(:shareObj)['linearray2']
    assigns(:version_fileId_map )
    assigns(:current_review_file)
    assigns(:shareObj )
    assigns(:highlight_cell_right_file)
    assert_response 200
  end

  def test_show_code_file_diff
    post :show_code_file_diff, :participant_id => @participantId,
         :current_version_id =>  @reviewFileId,
         :diff_with_file_id => @reviewFileWithNewVersionId,
         :versions => [1,2]
    assigns(:version_fileId_map)
    assigns(:highlight_cell_right_file)
    assigns(:shareObj)
    assert_response 200
  end

  def test_submit_comments

    assert_difference('ReviewComment.count') do
      get :submit_comment, :file_id => @reviewFileId,
           :file_offset => 5, :comment_content => "some comment"
    end

  end

  def test_get_comments
    post :get_comments, :file_id =>review_files(:review_file_for_comment).id,
         :file_offset => review_comments(:one).file_offset, :format => "js"
    puts @response.body
    result = @response.body
    # response should have the comment
    assert_not_nil result.match /Comment 1:/

  end

end