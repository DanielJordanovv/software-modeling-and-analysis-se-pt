let
    Source = Sql.Database("localhost", "AirbnbDB"),
    Data = Source{[Schema="dw", Item="DimDate"]}[Data]
in
    Data
