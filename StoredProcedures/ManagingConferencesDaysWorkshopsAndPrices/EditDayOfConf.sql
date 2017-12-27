CREATE PROC EditDayOfConf (
    @DayOfConfID INT,
    @Date DATE,
    @SpaceLimit SMALLINT
)
AS
BEGIN
  UPDATE DaysOfConf SET Date = @Date, SpaceLimit = @SpaceLimit WHERE DayOfConfID = @DayOfConfID
END