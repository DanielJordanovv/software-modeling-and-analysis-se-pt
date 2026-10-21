let
    Source = Sql.Database("localhost", "AirbnbCoursework"),
    Data = Source{[Schema="dw", Item="DimLocation"]}[Data]
in
    Data
