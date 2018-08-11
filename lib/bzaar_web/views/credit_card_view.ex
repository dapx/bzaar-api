defmodule BzaarWeb.CreditCardView do
  use Bzaar.Web, :view

  def render("index.json", %{credit_cards: credit_cards}) do
    %{data: render_many(credit_cards, BzaarWeb.CreditCardView, "credit_card.json")}
  end

  def render("show.json", %{credit_card: credit_card}) do
    %{data: render_one(credit_card, BzaarWeb.CreditCardView, "credit_card.json")}
  end

  def render("credit_card.json", %{credit_card: credit_card}) do
    %{id: credit_card.id,
      name: credit_card.name,
      number: credit_card.number,
      cvc: credit_card.cvc,
      expire: credit_card.expire,
      active: credit_card.active,
      user_id: credit_card.user_id}
  end
end
