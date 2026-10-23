let
    Source = Sql.Database("localhost", "AirbnbDB"),
    Data = Source{[Schema="dw", Item="FactReviews"]}[Data]
in
    Data
