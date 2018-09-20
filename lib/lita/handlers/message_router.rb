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

      def route_prefix
        @prefix ||= /^(?:#{
          config.robot_mention_names.map do |p|
            case p
            when Regexp then "(?:#{p.to_s})"
            else Regexp.escape(p.to_s)
            end
          end.join('|')
          })\s*(.+)/
      end

      def match(message)
        matches = message.match(route_prefix)
        matches[-1] if matches
      end

      Lita.register_handler(self)
    end
  end
end
