let
    Source = Sql.Database("localhost", "AirbnbDB"),
    Data = Source{[Schema="dw", Item="DimLocation"]}[Data]
in
    Data
