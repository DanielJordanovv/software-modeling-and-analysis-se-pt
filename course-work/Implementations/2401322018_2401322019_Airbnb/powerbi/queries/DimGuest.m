let
    Source = Sql.Database("localhost", "AirbnbDB"),
    Data = Source{[Schema="dw", Item="DimGuest"]}[Data]
in
    Data
