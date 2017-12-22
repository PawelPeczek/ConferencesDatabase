CREATE PROC EditDayOfConf (
    @DayOfConfID INT,
    @ConfID INT,
    @Date DATE,
    @SpaceLimit SMALLINT
)
AS
BEGIN
  UPDATE DaysOfConf SET ConfID = @ConfID, Date = @Date, SpaceLimit = @SpaceLimit WHERE DayOfConfID = @DayOfConfID
END