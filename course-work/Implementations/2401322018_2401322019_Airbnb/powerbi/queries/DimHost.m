let
    Source = Sql.Database("localhost", "AirbnbCoursework"),
    Data = Source{[Schema="dw", Item="DimHost"]}[Data]
in
    Data
