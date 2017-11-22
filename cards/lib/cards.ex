defmodule Cards do
  @moduledoc """
    Creates a standard deck of cards and has methods for using the deck
  """

  @doc """
    Combines create_deck/0, shuffle/1, and deal/2
  """
  def create_hand(hand_size) do
    create_deck()
    |> shuffle()
    |> deal(hand_size)
  end

  @doc """
    Creates a list of strings representing cards
  """
  def create_deck do
    values = [:ace, :two, :three, :four, :five]
    suits = [:spades, :clubs, :hearts, :diamonds]
    for suit <- suits, val <- values do
      "#{val} of #{suit}"
    end
  end

  @doc """
    Shuffles a list
  """
  def shuffle(deck) do
     Enum.shuffle(deck)
  end

  @doc """
  Checks if deck contains a given card

  ## Example

      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "two of hearts")
      true
  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
  Divides a deck into a hand and the rest of the dec, returns tuple `{hand, rest_of_deck}`

  ## Example

      iex> deck = Cards.create_deck
      iex> {hand, deck} = Cards.deal(deck, 1)
      iex> hand
      ["ace of spades"]
  """
  def deal(deck, num_cards) do
    Enum.split(deck, num_cards)
  end

  @doc """
    saves a given deck to file
  """
  def save(deck, filename) do
    deck_to_save = Enum.map(deck, fn(d) -> "#{d}\n" end)
    File.write(filename, deck_to_save)
  end

  @doc """
    loads a file containing a deck, with each card separated by newlines `"\\n"`
  """
  def load(filename) do
    case File.read(filename) do
      {:ok, cards} -> String.split(cards, "\n")
      {:error, _} -> "File does not exist"
    end
  end

end
