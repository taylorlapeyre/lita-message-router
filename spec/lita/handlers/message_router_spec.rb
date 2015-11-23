require "spec_helper"

describe Lita::Handlers::MessageRouter, lita_handler: true do
  before do
    registry.config.handlers.message_router.robot_mention_names = ['!', '%']
  end

  it 'routes correctly' do
    send_message('! hello world')
    send_message('% hello world')
  end
end
