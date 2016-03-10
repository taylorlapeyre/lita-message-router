module Lita
  module Handlers
    class MessageRouter < Handler
      config :robot_mention_names, type: Array, required: true

      route /.+/, :maybe_route, command: false

      def maybe_route(chat)
        return if chat.command?

        message = chat.matches[0].strip
        match = match(message)

        if match
          command = robot.mention_name + ' ' + match
          real_message = Lita::Message.new(robot, command, chat.message.source)
          robot.receive(real_message)
        end
      end

      def match(message)
        regex = /^(#{config.robot_mention_names.map { |n| Regexp.escape(n) }.join('|')})\s*(.+)/
        matches = message.match(regex)
        matches[2] if matches
      end

      Lita.register_handler(self)
    end
  end
end
