require 'spec_helper'

describe Folder do
  before(:all) do
    @user = User.create(:login => "testuser", 
                        :email => "testuser@example.com", 
                        :password => "password", 
                        :password_confirmation => "password")
    @file = GenericFile.create
    # Attempted to do this in a .create one-liner, but that throws:
    #      Failure/Error: @folder = Folder.create(:title => "test collection",
    #      ActiveFedora::UnregisteredPredicateError: Unregistered predicate: nil
    f = Folder.create(:title => "test collection",
                      :creator => @user.login,
                      :has_part => @file.pid)
    @gf = GenericFile.create
    f.has_part = @gf
    f.save
    @folder = Folder.find(f.pid)
  end
  after(:all) do
    @user.delete
    @file.delete
    @folder.delete
  end
  it "should have rightsMetadata" do
    @folder.rightsMetadata.should be_instance_of Hydra::RightsMetadata
  end
  it "should have apply_depositor_metadata" do
    @folder.apply_depositor_metadata(@user.login)
    @folder.rightsMetadata.edit_access.should == [@user.login]
  end
  it "should have dc desc metadata" do
    @folder.descMetadata.should be_kind_of FolderRDFDatastream
  end
  it "should belong to testuser" do
    @folder.creator.should == [@user.email]
  end
  it "should be titled 'test collection'" do
    @folder.title.should == ["test collection"]
  end
  it "should have generic_files defined" do
    @folder.should respond_to(:generic_files)
  end
  it "should contain one generic file" do
    @folder.has_part.should == [@file.pid]
  end
  it "should be able to 'have' more than one file" do
    @folder.has_part.should include(@file.pid)
    @folder.has_part.should include(@gf.pid)
  end
  it "should be accessible via file object?" 
  it "should be accessible via user object?"
end