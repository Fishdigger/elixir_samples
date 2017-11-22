defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create_deck makes 20 cards" do
    deck = Cards.create_deck
    assert length(deck) == 20
  end

  test "save file - overwrite" do
    deck = Cards.create_deck
    Cards.save(deck, "test_deck")
    deck = Cards.shuffle(deck)
    assert :ok == Cards.save(deck, "test_deck")
  end
end
