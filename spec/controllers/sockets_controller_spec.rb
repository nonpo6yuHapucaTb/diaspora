require File.dirname(__FILE__) + '/../spec_helper'

describe 'SocketsController' do
  render_views  
  before do
    @user = Factory.create(:user)
    @user.person.save 
    SocketsController.unstub!(:new)
    #EventMachine::WebSocket.stub!(:start)
    @controller = SocketsController.new
    stub_sockets_controller
  end

  it 'should unstub the websockets' do
      WebSocket.initialize_channel
      @controller.class.should == SocketsController
  end
  
  it 'should add a new subscriber to the websockets channel' do
      WebSocket.initialize_channel
      @controller.new_subscriber.should == 1
  end
  describe 'actionhash' do
    before do
      @message = Factory.create(:status_message, :person => @user)
    end

    it 'should actionhash posts' do
      json = @controller.action_hash(@message)
      json.include?(@message.message).should be_true
      json.include?('status_message').should be_true
    end

    it 'should actionhash retractions' do
      retraction = Retraction.for @message
      json = @controller.action_hash(retraction)
      json.include?('retraction').should be_true
      json.include?("html\":null").should be_true
    end
  end
end
