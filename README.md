# lita-message-router

Ever wanted to use many different names for your robot? This handler allows you to specify as many "mention names" as you want for your Lita robot.

## Installation

Add lita-message-router to your Lita instance's Gemfile:

``` ruby
gem "lita-message-router"
```

## Configuration

Add the following config variable to your lita_config:

```ruby
config.handlers.message_router.robot_mention_names = ['!', 'whatever you want']
```
