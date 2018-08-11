defmodule Bzaar do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Bzaar.Repo, []),
      # Start the endpoint when the application starts
      supervisor(BzaarWeb.Endpoint, []),
      # Start your own worker by calling: Bzaar.Worker.start_link(arg1, arg2, arg3)
      # worker(Bzaar.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bzaar.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BzaarWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
