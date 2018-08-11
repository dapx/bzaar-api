defmodule BzaarWeb.CreditCardControllerTest do
  use BzaarWeb.ConnCase

  alias Bzaar.CreditCard
  @valid_attrs %{active: true, cvc: "some content", expire: "some content", name: "some content", number: "120.5"}
  @invalid_attrs %{}

  @tag :logged_in
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, credit_card_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  @tag :logged_in
  test "shows chosen resource", %{conn: conn} do
    credit_card = Repo.insert! %CreditCard{}
    conn = get conn, credit_card_path(conn, :show, credit_card)
    assert json_response(conn, 200)["data"] == %{"id" => credit_card.id,
      "name" => credit_card.name,
      "number" => credit_card.number,
      "cvc" => credit_card.cvc,
      "expire" => credit_card.expire,
      "active" => credit_card.active,
      "user_id" => credit_card.user_id}
  end

  @tag :logged_in
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, credit_card_path(conn, :show, -1)
    end
  end

  @tag :logged_in
  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, credit_card_path(conn, :create), credit_card: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(CreditCard, @valid_attrs)
  end

  @tag :logged_in
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, credit_card_path(conn, :create), credit_card: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag :logged_in
  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    credit_card = Repo.insert! %CreditCard{}
    conn = put conn, credit_card_path(conn, :update, credit_card), credit_card: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(CreditCard, @valid_attrs)
  end

  @tag :logged_in
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    credit_card = Repo.insert! %CreditCard{}
    conn = put conn, credit_card_path(conn, :update, credit_card), credit_card: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag :logged_in
  test "deletes chosen resource", %{conn: conn} do
    credit_card = Repo.insert! %CreditCard{}
    conn = delete conn, credit_card_path(conn, :delete, credit_card)
    assert response(conn, 204)
    refute Repo.get(CreditCard, credit_card.id)
  end
end
