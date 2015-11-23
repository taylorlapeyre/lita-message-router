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
          real_message = Lita::Message.new(robot, match, Lita::Source.new(user: chat.user))
          robot.receive(real_message)
        end
      end

      def match(message)
        regex = Regexp.new('^(' + config.robot_mention_names.join('|') + ') (.+)')
        matches = message.match(regex)
        matches[2] if matches
      end

      Lita.register_handler(self)
    end
  end
end
