# Hanami::Authentication
[![Gem Version](https://badge.fury.io/rb/hanami-authentication.svg)](https://badge.fury.io/rb/hanami-authentication)
![](http://ruby-gem-downloads-badge.herokuapp.com/hanami-authentication?type=total)


`Hanami::Authentication` is simple authentication helpers for [hanami-controller](https://github.com/hanami/controller)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hanami-authentication'
```

## Usage

### Setup
```ruby
# application.rb
controller.prepare do
  include Hanami::Authentication

  before authenticate  # This will use callbacks if authentication is failed.  
  before authenticate! # This will force to halt by 401 if authentication is failed.
  
  after_session_expired do # This will be called if authenticate method is called when session is expired.
    flash[:error] = 'The session is expired.'
    redirect_to routes.root_path
  end

  after_authentication_failed do # This will be called if authenticate method is called when user has not logged in.
    flash[:error] = 'Please login'
    redirect_to routes.root_path
  end
end
```


### Methods

#### Login example
```ruby
# in_your_login_action.rb
def call(params)
  email = params[:email]
  password = params[:password]
  remember_me = params[:remember_me]

  @current_user = @repository.find_by_email(email)

  if match_password?(@current_user, password)
    login(@current_user, remember_me: remember_me)
    flash[:success] = 'Successful logged in'
    redirect_to routes.root_path
  else
    flash[:error] = 'Email or password is incorrect'
    redirect_to routes.root_path
  end
end
```

#### Logout example
```ruby
# in_your_login_action.rb
def call(params)
  logout
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/legalforce/hanami-auth. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Hanami::Auth project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/unhappychoice/hanami-authentication/blob/master/CODE_OF_CONDUCT.md).
