SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_Dashboard_Overview]
(
    @BranchID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Today DATE = CAST(GETDATE() AS DATE);
    DECLARE @MonthStart DATE = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);

    /*------------------------------------
      A. TODAY'S OVERVIEW
    --------------------------------------*/

    -- Today’s Bookings
    SELECT 
        COUNT(*) AS TodayBookings
    INTO #TodayBookings
    FROM AppointmentBookings
    WHERE CAST(CreatedDate AS DATE) = @Today
      AND BranchID = @BranchID;

    -- Today’s Job Cards
    SELECT 
        COUNT(*) AS TodayJobCards
    INTO #TodayJobCards
    FROM JobCards
    WHERE CAST(CreatedDate AS DATE) = @Today
      AND BranchID = @BranchID;

    -- Today Deliveries
    SELECT 
        COUNT(*) AS TodayDeliveries
    INTO #TodayDeliveries
    FROM JobCards
    WHERE CAST(ActualDelivery AS DATE) = @Today
      AND BranchID = @BranchID;

    -- Payments Today
    SELECT 
        ISNULL(SUM(Amount), 0) AS TodayPayments
    INTO #TodayPayments
    FROM JobPayments
    WHERE CAST(PaymentDate AS DATE) = @Today
      AND BranchID = @BranchID;

    -- Pending JobCards
    SELECT 
        COUNT(*) AS PendingJobCards
    INTO #PendingJobCards
    FROM JobCards
    WHERE JobStatus NOT IN ('Delivered', 'Completed')
      AND BranchID = @BranchID;

    -- Pending Insurance Claims
    SELECT 
        COUNT(*) AS PendingInsuranceClaims
    INTO #PendingClaims
    FROM InsuranceClaims
    WHERE ClaimStatus NOT IN ('Approved', 'Rejected')
      AND BranchID = @BranchID;

    -- Low Stock Parts
    SELECT 
        COUNT(*) AS LowStockParts
    INTO #LowStock
    FROM InventoryParts
    WHERE StockQuantity <= ReorderLevel
      AND BranchID = @BranchID;

    -- Pending Approvals (Estimates)
    SELECT 
        COUNT(*) AS PendingApprovals
    INTO #PendingApprovals
    FROM JobEstimates
    WHERE ApprovalStatus = 'Pending'
      AND BranchID = @BranchID;

    /*------------------------------------
      B. MONTHLY SUMMARY
    --------------------------------------*/

    -- Jobs This Month
    SELECT 
        COUNT(*) AS JobsThisMonth
    INTO #JobsThisMonth
    FROM JobCards
    WHERE CreatedDate >= @MonthStart
      AND BranchID = @BranchID;

    -- Revenue This Month
    SELECT 
        ISNULL(SUM(GrandTotal), 0) AS RevenueThisMonth
    INTO #RevenueThisMonth
    FROM JobInvoices
    WHERE InvoiceDate >= @MonthStart
      AND BranchID = @BranchID;

    -- Total Customers
    SELECT 
        COUNT(*) AS TotalCustomers
    INTO #TotalCustomers
    FROM Customers
    WHERE BranchID = @BranchID;

    -- Total Vehicles
    SELECT 
        COUNT(*) AS TotalVehicles
    INTO #TotalVehicles
    FROM Vehicles
    WHERE BranchID = @BranchID;


    /*------------------------------------
      FINAL OUTPUT
    --------------------------------------*/
    SELECT 
        (SELECT TodayBookings FROM #TodayBookings) AS TodayBookings,
        (SELECT TodayJobCards FROM #TodayJobCards) AS TodayJobCards,
        (SELECT TodayDeliveries FROM #TodayDeliveries) AS TodayDeliveries,
        (SELECT TodayPayments FROM #TodayPayments) AS TodayPayments,
        (SELECT PendingJobCards FROM #PendingJobCards) AS PendingJobCards,
        (SELECT PendingInsuranceClaims FROM #PendingClaims) AS PendingInsuranceClaims,
        (SELECT LowStockParts FROM #LowStock) AS LowStockParts,
        (SELECT PendingApprovals FROM #PendingApprovals) AS PendingApprovals,
        (SELECT JobsThisMonth FROM #JobsThisMonth) AS JobsThisMonth,
        (SELECT RevenueThisMonth FROM #RevenueThisMonth) AS RevenueThisMonth,
        (SELECT TotalCustomers FROM #TotalCustomers) AS TotalCustomers,
        (SELECT TotalVehicles FROM #TotalVehicles) AS TotalVehicles;
    
END;

GO
