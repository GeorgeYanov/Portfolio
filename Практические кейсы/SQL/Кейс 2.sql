
WITH daily_changes AS (
    -- Вычисляем дневное отклонение (close - предыдущий close)
    SELECT 
        p.symbol,
        p.date,
        p.close,
        LAG(p.close) OVER (PARTITION BY p.symbol ORDER BY p.date) AS prev_close,
        p.close - LAG(p.close) OVER (PARTITION BY p.symbol ORDER BY p.date) AS daily_delta
    FROM prices p
),
filtered_stocks AS (
    -- Фильтруем по условиям: max(high) > 200, min(low) < 30
    SELECT 
        symbol,
        MAX(high) AS max_high,
        MIN(low) AS min_low
    FROM prices
    GROUP BY symbol
    HAVING MAX(high) > 200 AND MIN(low) < 30
),
trading_days AS (
    -- Считаем количество торговых дней для каждой акции
    SELECT 
        symbol,
        COUNT(*) AS trading_days_count
    FROM prices
    GROUP BY symbol
    HAVING COUNT(*) > 504  -- менее 504 торговых дней
),
total_volume AS (
    -- Суммируем объем торгов (volume * close) для каждой акции
    SELECT 
        symbol,
        SUM(volume * close) AS total_trading_value
    FROM prices
    GROUP BY symbol
    HAVING SUM(volume * close) > 5000000  -- более 5 млн долларов
),
avg_daily_delta AS (
    -- Считаем среднее дневное отклонение для каждой акции
    SELECT 
        symbol,
        AVG(daily_delta) AS avg_daily_delta
    FROM daily_changes
    WHERE daily_delta IS NOT NULL  -- исключаем первый день (где нет prev_close)
    GROUP BY symbol
    HAVING AVG(daily_delta) > 0  -- среднее отклонение больше 0
)
-- Объединяем все условия и добавляем название компании
SELECT 
    ad.symbol, s.security,
    ad.avg_daily_delta
FROM avg_daily_delta ad
JOIN filtered_stocks fs ON ad.symbol = fs.symbol
JOIN trading_days td ON ad.symbol = td.symbol
JOIN total_volume tv ON ad.symbol = tv.symbol
JOIN securities s ON ad.symbol = s.symbol
ORDER BY ad.avg_daily_delta DESC



