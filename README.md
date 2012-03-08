![Lightrail](https://github.com/lightness/lightrail/raw/master/logo.png)
============

# Lightrail::ActionController::Metal

`Lightrail::ActionController::Metal` provides a lightweight `ActionController::Base` without several modules that are not used when your controller main concern is to handle APIs.

`Lightrail::ActionController::Metal` also provides three new behaviors:

* `param` is a method that can handle with nested params hashes. For instance, `param("user.id")` is the same as `params[:user].is_a?(Hash) && params[:user][:id]`;

* `halt` provides an ability to halt the rendering at any point using Ruby's throw/catch mechanism. Any option passed to `halt` is forwarded to the `render` method;

* `render :errors` is a renderer extension that allows you to easily render an error as JSON. It is simply a convenience method for `render :json => errors, :status => 422`. With the `halt` mechanism above, this ends up being a common pattern in the source code: `halt :errors => { :request => "invalid" }`.

# config.lightrail.*

Lightrail adds a config.lightrail namespace to your application with two main methods:

* `remove_session_middlewares!` removes `ActionDispatch::Cookies`,
`ActionDispatch::Session::CookieStore` and `ActionDispatch::Flash` middlewares;

* `remove_browser_middlewares!` removes the `ActionDispatch::BestStandardsSupport` middleware.

# Lightrail::Encryptor

Provides an encrypt/decrypt facility used across Lightrail projects;

# Lightrail::Wrapper

Lightrail::Wrapper provides a wrapper functionality to make it easier to generate JSON responses. It is divided in three main parts:

### Creating a wrapper

Each model needs to have a wrapper in order to be rendered as JSON. Instead of using several options (like `:only`, `:method` and friends), it expects you to explicitly define the hash to returned through the `view` method. Here is an example:

    class AccountWrapper < Lightrail::Wrapper::Model
      has_one :credit_card
      has_one :subscription

      def view
        attrs = [:id, :name, :user_id]

        if owner?
          attrs.concat [:billing_address, :billing_country]
        end

        # Shortcut for account.attributes.slice()
        hash = account.slice(*attrs)
        hash[:owner] = owner?
        hash
      end

      # Whenever an association method is defined explicitly
      # it is given higher preference. That said, whenever
      # including a credit_card, it will invoke this method
      # instead of calling account.credit_card directly.
      def credit_card
        account.credit_card if owner?
      end

      protected

      def owner?
        account.owners.include?(scope)
      end
    end

A wrapper is initialized with two arguments: the `resource`, which is the `account` in this case, and a `scope`. In most cases, the scope is the `current_user`. The idea of having a scope inside the wrapper is to be able to properly handle permissions when exposing a resource. In the example above, you can notice that a `credit_card` is only exposed if the user actually owns the account being showed. Billing information is also hidden except when the user is an `owner?`.

Another convenience is that the wrapper can automatically handle associations. Associations, when exposed, are not nested exposed but rather flat in the JSON, here is an example:

    {
      "account": {
        "id": 1,
        "name": "Main",
        "user_id": null,
        "credit_card_id": 1
      },

      "credit_cards": {
        "id": 1,
        "last_4": "3232"
      }
    }

In order to render a wrapper with its associations, you can use the `render` method and pass the associations explicitly:

    AccountWrapper.new(@account, current_user).render :include => [:credit_card]

Although most of the times, this will be done automatically by the controller.

### Using the wrapper in the controller

`Lightrail::Wrapper::Controller` provides several facilities to use wrappers from the controller:

* `json(resources)` is the main method. Given a resource (or an array of resources), it will find the proper wrapper and render it. Any include given at `params[:include]` will be validated and passed to the underlying wrapper. Consider the following action:

        def last
          json Account.last
        end

  When accessed as `/accounts/last`, it won't return any credit card or subscription resource in the JSON, unless it is given explicitly as `/accounts/last?include=credit_cards,subscriptions` (in plural).

  In order for the `json` method to work, a `wrapper_scope` needs to be defined. You can usually define it in your `ApplicationController` as follow:

        def wrapper_scope
          current_user
        end

* `errors(resource)` is a method that makes pair with `json(resource)`. It basically receives a resource and render its errors. For instance, `errors(account)` will return `:errors => { :account => account.errors }`;

* `wrap_array(resources)` as the `json` method accepts extra associations to be included through `params[:include]`, we need to be careful to not end up doing `N+1` queries in the database. This can be fixed by using the `wrap_array` method that will automatically wrap the given array and preload all associations. For instance, you want will to do this in your `index` actions:

        def index
          json wrap_array(current_user.accounts.active.all)
        end

### Active Record extensions

Lightrail::Wrapper provides one Active Record extension method called `slice`. In order to understand what it does, it is easier to look at the source:

    def slice(*attrs)
      attrs.map! { |a| a.to_s }
      attributes.slice(*attrs)
    end

This method was used in the example showed above.
