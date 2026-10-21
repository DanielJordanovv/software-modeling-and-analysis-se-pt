let
    Source = Sql.Database("localhost", "AirbnbCoursework"),
    Data = Source{[Schema="dw", Item="DimPaymentMethod"]}[Data]
in
    Data
