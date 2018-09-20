require "spec_helper"

describe Lita::Handlers::MessageRouter, lita_handler: true do
  let(:greetings) do
    Class.new(Lita::Handler) do
      def self.name
        'Greetings'
      end

      route(/^hello world/, :hello, command: true)

      def hello(response)
        response.reply('hi')
      end
    end
  end

  before do
    registry.register_handler(greetings)
    # Includes one regexp match with a sub-group to ensure that the suffix of
    # the message is always selected for forwarding.
    registry.config.handlers.message_router.robot_mention_names = ['!', '%', '.', /(fooba[rz])\s/i]
  end

  it 'routes configured mention names correctly' do
    send_message('!hello world')
    send_message('% hello world')
    send_message('foobar hello world')
    send_message('FOOBAZ hello world')
    expect(replies.count).to eq 4
  end

  it 'does not route unspecified mention names' do
    send_message('/ hello world')
    send_message('hello world')
    send_message('foobat hello world')
    send_message('foobarhello world')
    send_message('FOOBAZhello world')
    expect(replies.count).to eq 0
  end

  it 'routes configured mention names containing special regex characters' do
    send_message('.hello world')
    expect(replies.count).to eq 1
  end
end
