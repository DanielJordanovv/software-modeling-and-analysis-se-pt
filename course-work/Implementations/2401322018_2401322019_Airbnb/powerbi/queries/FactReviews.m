let
    Source = Sql.Database("localhost", "AirbnbCoursework"),
    Data = Source{[Schema="dw", Item="FactReviews"]}[Data]
in
    Data
