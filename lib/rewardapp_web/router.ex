defmodule RewardappWeb.Router do
  use RewardappWeb, :router
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RewardappWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RewardappWeb do
    pipe_through :browser


    #get "/", PageController, :index
    #NEW ROUTES
    #get "/users", GrantController, :login
    get "/admin", GrantController, :admin
    get "/main", GrantController, :main
    get "/", GrantController, :index
    post "/", GrantController, :login
    get "/add", GrantController, :add
    post "/add/:id", GrantController, :update
    get "/admin/delete/:id", GrantController, :delete
    get "/admin/edit/:id", GrantController, :edit
    post "/admin/edit/:id", GrantController, :adminUpdate
    get "/", GrantController, :logout
  end

  if Mix.env == :dev do
    forward "/mailbox", Bamboo.EmailPreviewPlug
  end

  # Other scopes may use custom stacks.
  # scope "/api", RewardappWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RewardappWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      #forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
