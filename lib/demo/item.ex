defmodule Demo.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item" do
    field :value, :string
  end

  def changeset(item, params \\ %{}) do
    item
    |> cast(params, [:value])
  end
end
