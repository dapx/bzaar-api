defmodule BzaarWeb.DispatcherView do
  use Bzaar.Web, :view

  def render("index.json", %{dispatchers: dispatchers}) do
    %{data: render_many(dispatchers, BzaarWeb.DispatcherView, "dispatcher.json")}
  end

  def render("show.json", %{dispatcher: dispatcher}) do
    %{data: render_one(dispatcher, BzaarWeb.DispatcherView, "dispatcher.json")}
  end

  def render("dispatcher.json", %{dispatcher: dispatcher}) do
    %{id: dispatcher.id,
      company: dispatcher.company,
      email: dispatcher.email,
      distance_limit: dispatcher.distance_limit,
      time_to_deliver: dispatcher.time_to_deliver,
      store_id: dispatcher.store_id}
  end
end
