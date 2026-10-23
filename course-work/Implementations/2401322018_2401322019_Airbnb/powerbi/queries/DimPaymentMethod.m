let
    Source = Sql.Database("localhost", "AirbnbDB"),
    Data = Source{[Schema="dw", Item="DimPaymentMethod"]}[Data]
in
    Data
