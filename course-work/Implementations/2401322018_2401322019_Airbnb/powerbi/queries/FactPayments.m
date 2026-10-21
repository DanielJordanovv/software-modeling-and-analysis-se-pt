let
    Source = Sql.Database("localhost", "AirbnbCoursework"),
    Data = Source{[Schema="dw", Item="FactPayments"]}[Data]
in
    Data
