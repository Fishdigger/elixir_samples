defmodule Identicon do
  @moduledoc """
  Turns a string into a unique picture (identicon)
  """

  def main(input_string) do
    hash_input(input_string)
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input_string)
  end

  def hash_input(string) do
    hex = :crypto.hash(:md5, string)
    |> :binary.bin_to_list()
    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _]} = image) do
     %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = Enum.chunk(hex, 3)
    |> Enum.map(&mirror_row/1)
    |> List.flatten
    |> Enum.with_index
    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    odds_out = Enum.filter(grid, fn({g, _}) ->
      rem(g, 2) == 0
    end)
    %Identicon.Image{image | grid: odds_out}
  end

  @doc """
  Makes a grid of 50x50 px squares
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
     pixels = Enum.map(grid, fn({_, i}) ->
       horizontal = rem(i, 5) * 50
       vertical = div(i, 5) * 50
       top_left = {horizontal, vertical}

       bottom_right = {horizontal + 50, vertical + 50}
       {top_left, bottom_right}
     end)
     %Identicon.Image{image | pixel_map: pixels}
  end

  def draw_image(%Identicon.Image{pixel_map: pixels, color: color}) do
    id = :egd.create(250, 250)
    fill = :egd.color(color)
    Enum.each pixels, fn({start, stop}) ->
      :egd.filledRectangle(id, start, stop, fill)
    end
    :egd.render(id)
  end

  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

end
