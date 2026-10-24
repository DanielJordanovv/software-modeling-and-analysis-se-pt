let
    Source = Sql.Database("localhost", "AirbnbCoursework"),
    Data = Source{[Schema="dw", Item="DimBookingStatus"]}[Data]
in
    Data
