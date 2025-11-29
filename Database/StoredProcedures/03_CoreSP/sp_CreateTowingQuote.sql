-- sp_CreateTowingQuote.sql
SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.sp_CreateTowingQuote','P') IS NOT NULL
  DROP PROCEDURE dbo.sp_CreateTowingQuote;
GO
CREATE PROCEDURE dbo.sp_CreateTowingQuote
  @DistanceKm DECIMAL(9,2),
  @CarType NVARCHAR(50),
  @Condition NVARCHAR(50) = 'DRIVABLE',
  @LocationType NVARCHAR(50) = 'WITHIN_CITY',
  @RequestedAt DATETIME2 = NULL
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @Base DECIMAL(18,2)=0, @included INT=0, @perkm DECIMAL(18,2)=0, @undrivable DECIMAL(18,2)=0, @minCharge DECIMAL(18,2)=0, @nightMultiplier DECIMAL(5,2)=1.0, @weekendMultiplier DECIMAL(5,2)=1.0, @extraKm INT=0, @extraCharge DECIMAL(18,2)=0, @subtotal DECIMAL(18,2)=0, @total DECIMAL(18,2)=0, @locMultiplier DECIMAL(5,2)=1.0;

  SELECT TOP 1 @Base = BaseFare, @included = IncludedKm, @perkm = PerKmRate, @undrivable = UndrivableFee, @minCharge = MinCharge, @nightMultiplier = NightMultiplier, @weekendMultiplier = WeekendMultiplier
  FROM dbo.TowingRates
  WHERE CarType = @CarType AND Active = 1
  ORDER BY TowingRateId DESC;

  IF @Base IS NULL SET @Base = 0;
  SET @extraKm = CASE WHEN @DistanceKm > @included THEN CEILING(@DistanceKm - @included) ELSE 0 END;
  SET @extraCharge = @extraKm * ISNULL(@perkm,0);

  SET @subtotal = @Base + @extraCharge;
  IF UPPER(@Condition) LIKE '%UNDRIVABLE%' SET @subtotal = @subtotal + ISNULL(@undrivable,0);

  IF UPPER(@LocationType) = 'OUT_OF_CITY' SET @locMultiplier = 1.25;
  IF UPPER(@LocationType) = 'LONG_DISTANCE' SET @locMultiplier = 1.5;
  SET @subtotal = @subtotal * @locMultiplier;

  IF @RequestedAt IS NOT NULL AND (DATEPART(HOUR,@RequestedAt) >= 22 OR DATEPART(HOUR,@RequestedAt) < 6)
    SET @subtotal = @subtotal * ISNULL(@nightMultiplier,1.0);

  SET @total = CASE WHEN @subtotal < ISNULL(@minCharge,0) THEN ISNULL(@minCharge,0) ELSE @subtotal END;

  SELECT
    @Base AS BaseFare,
    @included AS IncludedKm,
    @extraKm AS ExtraKm,
    @extraCharge AS ExtraKmCharge,
    CASE WHEN UPPER(@Condition) LIKE '%UNDRIVABLE%' THEN @undrivable ELSE 0 END AS UndrivableFee,
    @locMultiplier AS LocationMultiplier,
    @subtotal AS SubTotalBeforeMin,
    ISNULL(@minCharge,0) AS MinCharge,
    @total AS Total;
END
GO
