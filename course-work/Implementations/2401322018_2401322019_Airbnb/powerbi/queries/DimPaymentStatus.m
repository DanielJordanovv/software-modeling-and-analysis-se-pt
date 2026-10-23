let
    Source = Sql.Database("localhost", "AirbnbDB"),
    Data = Source{[Schema="dw", Item="DimPaymentStatus"]}[Data]
in
    Data
