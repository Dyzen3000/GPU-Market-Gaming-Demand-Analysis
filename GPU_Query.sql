SELECT
    CASE
		WHEN Launch_MSRP <= 199 THEN '$100-$199'
		WHEN Launch_MSRP BETWEEN 200 AND 299 THEN '$200-$299'
        WHEN Launch_MSRP BETWEEN 300 AND 399 THEN '$300-$399'
		WHEN Launch_MSRP BETWEEN 400 AND 499 THEN '$400-$499'
        WHEN Launch_MSRP BETWEEN 500 AND 599 THEN '$500-$599'
        WHEN Launch_MSRP BETWEEN 600 AND 699 THEN '$600-$699'
		WHEN Launch_MSRP BETWEEN 700 AND 799 THEN '$700-$799'
		WHEN Launch_MSRP BETWEEN 800 AND 899 THEN '$800-$899'
		WHEN Launch_MSRP BETWEEN 900 AND 999 THEN '$900-$999'
		WHEN Launch_MSRP >= 1000 THEN '$999+'
    END AS MSRP_Range,
    SUM(GPU_Share) AS Total_Share

FROM SHS_2

WHERE SHS_Date = (
    SELECT MAX(SHS_Date)
    FROM SHS_2
)
GROUP BY MSRP_Range
ORDER BY MSRP_Range DESC





SELECT
    Genre,

    COUNT(DISTINCT AppID) AS Game_Count,

    ROUND(AVG(GPU_Performance), 2)
        AS Avg_Required_Performance,

    ROUND(AVG(GPU_VRAM), 2)
        AS Avg_Required_VRAM

FROM ID_GPU

WHERE Genre_Flag = 'Y'
  AND GPU_Class IN ('Mid', 'Mid+', 'Top', 'Top+')
  AND GPU_Launch_Year >= 2018
  AND Release_Date >= '2023-01-01'
  AND Release_Date < '2026-01-01'

GROUP BY Genre

ORDER BY Avg_Required_Performance DESC;





SELECT
    Genre,

    COUNT(DISTINCT AppID) AS Game_Count,

    ROUND(AVG(Peak_CCU), 2)
        AS Avg_Player_Count

FROM ID_GPU

WHERE Genre_Flag = 'Y'
  AND Release_Date >= '2023-01-01'
  AND Release_Date < '2026-01-01'
  AND GPU_Class IN ('Mid', 'Mid+', 'Top', 'Top+')
  AND GPU_Launch_Year >= 2018

GROUP BY Genre

ORDER BY Avg_Player_Count DESC;





SELECT
    COUNT(DISTINCT AppID) AS Game_Count,

    ROUND(
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY GPU_Performance)::numeric,
        2
    ) AS P75_Required_Performance,

    ROUND(
        PERCENTILE_CONT(0.75)
        WITHIN GROUP (ORDER BY GPU_VRAM)::numeric,
        2
    ) AS P75_Required_VRAM

FROM ID_GPU

WHERE Genre IN ('Action', 'RPG', 'Adventure')
  AND Genre_Flag = 'Y'
  AND Release_Date >= '2023-01-01'
  AND Release_Date < '2026-01-01'
  AND GPU_Class IN ('Mid', 'Mid+', 'Top', 'Top+')
  AND GPU_Launch_Year >= 2018;




SELECT
    GPU_Model,
    GPU_Performance,
    GPU_VRAM,
    GPU_MSRP,
    GPU_PricePerDollar
FROM spec_gpu
WHERE GPU_Performance >= 75
  AND GPU_VRAM >= 11
  AND GPU_Availability = 'Y'
  AND GPU_MSRP BETWEEN 200 AND 599
ORDER BY GPU_priceperdollar DESC;





WITH eligible_gpus AS (
    SELECT
        GPU_Model,
        GPU_Performance,
        GPU_VRAM,
        GPU_MSRP,
        GPU_PricePerDollar
    FROM spec_gpu
    WHERE GPU_Performance >= 75
      AND GPU_VRAM >= 11
      AND GPU_Availability = 'Y'
      AND GPU_MSRP BETWEEN 200 AND 599
),

eligible_games AS (
    SELECT DISTINCT
        AppID,
        GPU_Performance AS Required_Performance,
        GPU_VRAM AS Required_VRAM
    FROM ID_GPU
    WHERE Genre IN ('Action', 'RPG', 'Adventure')
      AND Genre_Flag = 'Y'
      AND Release_Date >= '2023-01-01'
      AND Release_Date < '2026-01-01'
	  AND GPU_Class IN ('Mid', 'Mid+', 'Top', 'Top+')
)

SELECT
    g.GPU_Model,
    g.GPU_Performance,
    g.GPU_VRAM,
    g.GPU_MSRP,
    g.GPU_PricePerDollar,

    COUNT(DISTINCT e.AppID) AS Games_Covered,

    ROUND(
        COUNT(DISTINCT e.AppID) * 100.0 /
        (SELECT COUNT(*) FROM eligible_games),
        2
    ) AS Coverage_Percentage

FROM eligible_gpus g

LEFT JOIN eligible_games e
    ON g.GPU_Performance >= e.Required_Performance
   AND g.GPU_VRAM >= e.Required_VRAM

GROUP BY
    g.GPU_Model,
    g.GPU_Performance,
    g.GPU_VRAM,
    g.GPU_MSRP,
    g.GPU_PricePerDollar

ORDER BY
    Coverage_Percentage DESC,
    GPU_MSRP ASC;