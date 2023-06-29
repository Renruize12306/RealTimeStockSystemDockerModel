module CreateTableCryptoaggregates

import SearchLight.Migrations: create_table, column, primary_key, add_index, drop_table, add_indices

function up()
  create_table(:cryptoaggregates) do
    [
      primary_key()
      column(:ev_pair, :string, limit = 20)
      column(:create_time, :integer)
      column(:c, :float)
      column(:e, :integer)
      column(:h, :float)
      column(:l, :float)
      column(:o, :float)
      column(:s, :integer)
      column(:v, :float)
      column(:vw, :float)
      column(:z, :integer)
    ]
  end

  add_index(:cryptoaggregates, :ev_pair)
  add_indices(:cryptoaggregates, :create_time, :s, :e)
end

function down()
  drop_table(:cryptoaggregates)
end

end
