-- =================================================
-- Revenue Management & Demand Forecasting Analysis
-- =================================================

-- Dataset note:
-- This analysis uses a fictional dataset of 7,468 hotel bookings created for
-- portfolio demonstration purposes.

-- Disclaimer:
-- This project was created for educational and portfolio purposes using
-- fictional data. Any similarities to actual hotels, guests, or business
-- results are purely coincidental.

-- Project Objective:
-- Analyze hotel revenue performance, pricing effectiveness,
-- occupancy trends, booking behavior, demand forecasting accuracy,
-- and cancellation risk to identify revenue optimization opportunities.


-- Preview data
SELECT *
FROM Fact_Bookings
LIMIT 10;


-- Key Performance Indicators:
-- • Total Revenue: $7.60M
-- • Total Bookings: 7,468
-- • ADR: $308.38
-- • Average Occupancy: 79.15%
-- • Forecast Accuracy: 93.52%
-- • Cancellation Rate: 13.08%


-- Query 1. How have bookings, ADR, and occupancy influenced monthly revenue performance throughout 2025?

SELECT
    strftime('%Y-%m', arrival_date) AS month,
    COUNT(*) AS bookings,
    ROUND(AVG(adr), 2) AS avg_adr,
    ROUND(AVG(occupancy_pct), 2) AS avg_occupancy,
    ROUND(SUM(room_revenue), 2) AS revenue
FROM vw_revenue_management
GROUP BY month
ORDER BY month;

-- Findings:
-- Revenue exhibited clear seasonal patterns throughout 2025, with performance driven by 
-- changes in booking volume, ADR, and occupancy levels.

-- Revenue peaked in July ($989,116), followed closely by August ($944,087).

-- These peak months also recorded the highest occupancy rates (92.97% and 89.55%) and 
-- highest ADRs ($364.41 and $342.55), indicating strong demand and pricing power.

-- Revenue increased steadily from February through July as bookings rose from 504 to 815, 
-- occupancy increased from 69.44% to 92.97%, and ADR climbed from $281.12 to $364.41.

-- Following the summer peak, revenue declined sharply in September as bookings, occupancy, 
-- and ADR all decreased.

-- Revenue rebounded during November and December, supported by occupancy above 80% and 
-- ADRs exceeding $300, suggesting strong holiday-season demand.

-- February generated the lowest revenue ($443,802) due to lower booking volume, lower 
-- occupancy, and reduced pricing compared to peak periods.

-- Revenue growth was primarily driven by a combination of higher occupancy and higher ADR 
-- during peak demand periods. The strongest-performing months achieved both high room 
-- utilization and premium pricing, demonstrating effective revenue management during 
-- periods of elevated demand.

-- Recommendation:
-- Continue leveraging dynamic pricing strategies during high-demand periods such as summer 
-- and holidays, while implementing targeted promotions and marketing campaigns during 
-- lower-demand months (February, May, and September) to stimulate occupancy and maximize 
-- revenue opportunities.


-- Query 2. Which guest segments contribute the greatest share of hotel revenue?

SELECT
    market_segment,
    ROUND(SUM(room_revenue),2) AS total_revenue
FROM vw_revenue_management
GROUP BY market_segment
ORDER BY total_revenue DESC;

-- Findings: 
-- The Family segment generated the highest revenue at $2.27 million, accounting for the 
-- largest share of total room revenue.

-- The Leisure segment followed closely at $2.01 million, indicating that vacation 
-- travelers are a major revenue driver for the property.

-- Together, the Family and Leisure segments generated approximately 58% of total revenue, 
-- demonstrating a strong dependence on leisure-oriented demand.

-- The Corporate segment contributed $1.05 million, making it the strongest 
-- business-related segment and an important source of revenue diversification.

-- Rewards Members generated nearly $782,000, highlighting the value of guest loyalty 
-- programs in driving repeat business.

-- Group, Convention, and Wedding/Social segments generated comparatively lower revenue, 
-- with Wedding/Social producing the lowest revenue at $324,000.

-- Revenue is heavily concentrated within Family and Leisure travelers, suggesting the 
-- hotel's performance is strongly influenced by seasonal vacation demand. While these 
-- segments are highly valuable, expanding higher-yield business segments could help 
-- diversify revenue and reduce reliance on leisure travel patterns.

-- Recommendation:
-- Continue investing in family and leisure-focused marketing initiatives during peak 
-- travel periods while identifying opportunities to increase corporate, convention, and 
-- group business during lower-demand seasons. Expanding these segments may help stabilize 
-- occupancy, reduce seasonal revenue fluctuations, and improve overall revenue performance 
-- throughout the year.


-- Query 3a. Which distribution channels generate the highest revenue?

SELECT
    channel_type,
    ROUND(SUM(room_revenue), 2) AS total_revenue,
    ROUND(
        100.0 * SUM(room_revenue) /
        SUM(SUM(room_revenue)) OVER (),
        2
    ) AS revenue_share_pct
FROM vw_revenue_management
GROUP BY channel_type
ORDER BY total_revenue DESC;

-- Findings:
-- The Direct channel generated the highest revenue at $3.22 million, accounting for 
-- approximately 42.5% of total room revenue.

-- Third-Party channels generated $2.13 million, making them the second-largest revenue 
-- source.

-- Group and Corporate channels generated similar revenue levels at approximately $1.15 
-- million and $1.10 million, respectively.

-- Direct bookings generated approximately 51% more revenue than Third-Party channels, 
-- highlighting the strength of the hotel's direct distribution strategy.

-- Direct bookings are the hotel's most valuable distribution channel, generating the 
-- largest share of revenue while typically reducing commission expenses associated with 
-- third-party booking platforms.

-- Recommendation:
-- Continue investing in direct booking initiatives such as loyalty programs, website 
-- promotions, mobile booking capabilities, and targeted marketing campaigns. While 
-- third-party channels remain an important source of demand, increasing the proportion of 
-- direct bookings may improve profitability by reducing acquisition costs and 
-- strengthening guest relationships.


-- Query 3b. Which booking sources generate the highest revenue within each distribution channel?

SELECT
    channel_name,
    ROUND(SUM(room_revenue), 2) AS total_revenue,
    ROUND(
        100.0 * SUM(room_revenue) /
        SUM(SUM(room_revenue)) OVER (),
        2
    ) AS revenue_share_pct
FROM vw_revenue_management
GROUP BY channel_name
ORDER BY total_revenue DESC;

-- Findings:
-- The Direct Website generated the highest revenue at $2.15 million, accounting for 
-- approximately 28.3% of total room revenue.

-- Online Travel Agencies (OTAs) generated $1.52 million, representing 20.0% of total 
-- revenue and making them the second-largest booking source.

-- Group Sales and Corporate Portal channels contributed 15.1% and 14.5% of total revenue, 
-- respectively, demonstrating the importance of business and group demand.

-- The Mobile App generated over $1.07 million in revenue and accounted for 14.0% of total 
-- room revenue, highlighting the growing value of digital booking channels.

-- Travel Agents generated the lowest revenue at $617,010, contributing 8.1% of total 
-- revenue.

-- Direct Website bookings represent the hotel's largest individual booking source, 
-- generating more revenue than any other channel and reinforcing the importance of direct 
-- digital distribution.

-- Recommendation:
-- Continue investing in website optimization, loyalty program incentives, and direct 
-- booking promotions to increase direct channel performance. While OTA partnerships remain 
-- an important source of demand, expanding direct bookings may improve profitability and 
-- strengthen guest relationships by reducing reliance on intermediary channels.


-- Query 4. Which room types generate the highest revenue?

SELECT
    room_type,
    ROUND(SUM(room_revenue),2) AS total_revenue
FROM vw_revenue_management
GROUP BY room_type
ORDER BY total_revenue DESC;

-- Findings:
-- Standard King generated the highest total room revenue at $1.59 million.

-- Standard Queen generated $1.51 million, making it the second-highest revenue-producing 
-- room type.

-- Together, Standard King and Standard Queen rooms generated approximately 41% of total 
-- room revenue.

-- Suite categories generated lower total revenue despite higher nightly rates, likely due 
-- to lower inventory levels and fewer bookings.

-- Presidential Suites generated the lowest total revenue at $394,000, reflecting their 
-- limited availability and niche demand.

-- Standard room categories drive the largest share of total revenue because they represent 
-- the hotel's highest-volume inventory and serve the broadest range of guests.

-- Recommendation:
-- Continue optimizing occupancy and pricing strategies for Standard room categories, as 
-- they represent the hotel's primary revenue drivers. At the same time, evaluate 
-- opportunities to increase premium room upgrades and suite sales to improve overall ADR 
-- and revenue per booking.


-- Query 5. Which room types achieve the highest ADR?

SELECT
    room_type,
    ROUND(AVG(adr),2) AS avg_adr
FROM vw_revenue_management
GROUP BY room_type
ORDER BY avg_adr DESC;

-- Findings: 
-- The Presidential Suite achieved the highest ADR at $1,514.66, more than six times the 
-- ADR of a Standard King room.

-- Executive Suites generated the second-highest ADR at $658.28, followed by Junior Suites 
-- at $460.42.

-- Standard room categories generated the lowest ADRs, ranging from $225.90 to $248.98.
-- ADR increased consistently across room categories, with premium and suite accommodations 
-- commanding substantially higher nightly rates than standard rooms.

-- While Standard room categories generated the highest total revenue due to higher booking 
-- volume, premium suite categories achieved significantly higher ADRs and demonstrate the 
-- hotel's strongest pricing power.

-- Recommendation:
-- Continue maximizing occupancy within Standard room categories while promoting room 
-- upgrades and premium accommodations to increase ADR and overall revenue per guest. 
-- Targeted upsell strategies may help capture additional revenue from guests willing to 
-- pay for higher-tier room experiences.


-- Query 6. How does occupancy impact ADR and revenue performance?

SELECT
    CASE
        WHEN occupancy_pct < 60 THEN 'Below 60%'
        WHEN occupancy_pct < 70 THEN '60%-69%'
        WHEN occupancy_pct < 80 THEN '70%-79%'
        WHEN occupancy_pct < 90 THEN '80%-89%'
        ELSE '90%+'
    END AS occupancy_bucket,
    COUNT(*) AS bookings,
    ROUND(AVG(adr), 2) AS avg_adr,
    ROUND(SUM(room_revenue), 2) AS total_revenue
FROM vw_revenue_management
GROUP BY occupancy_bucket
ORDER BY
    CASE occupancy_bucket
        WHEN 'Below 60%' THEN 1
        WHEN '60%-69%' THEN 2
        WHEN '70%-79%' THEN 3
        WHEN '80%-89%' THEN 4
        WHEN '90%+' THEN 5
    END;

-- Findings:
-- As occupancy increased, both ADR and total revenue increased consistently across all 
-- occupancy groups.

-- Properties operating below 60% occupancy achieved an average ADR of $238.06 and 
-- generated $524,932 in room revenue.

-- At occupancy levels of 90% or higher, average ADR increased to $367.76, while total room 
-- revenue rose to $2.21 million.

-- ADR increased by approximately 54.5% between the lowest occupancy group ($238.06) and 
-- the highest occupancy group ($367.76).

-- Revenue increased by approximately 321%, growing from $524,932 in the lowest occupancy 
-- bucket to $2.21 million in the highest occupancy bucket.

-- The highest occupancy groups (80%-89% and 90%+) generated over 54% of total room 
-- revenue, demonstrating the significant impact of strong demand on financial performance.

-- Higher occupancy levels were strongly associated with higher ADRs and significantly 
-- greater revenue generation. This suggests the hotel successfully increased room rates 
-- during periods of elevated demand while maintaining strong occupancy levels, reflecting 
-- effective revenue management and pricing strategies.

-- Recommendation:
-- Continue leveraging dynamic pricing strategies during high-demand periods to maximize 
-- ADR without materially reducing occupancy. For lower-occupancy periods, consider 
-- targeted promotions, loyalty offers, and demand-generation initiatives to stimulate 
-- bookings while protecting rate integrity.


-- Query 7. What is the occupancy trend over time?

SELECT
    strftime('%Y-%m', arrival_date) AS month,
    ROUND(AVG(occupancy_pct),2) AS avg_occupancy
FROM vw_revenue_management
GROUP BY month
ORDER BY month;

-- Findings:
-- Occupancy exhibited clear seasonal fluctuations throughout 2025, ranging from a low of 
-- 65.80% in September to a high of 92.97% in July.

-- Occupancy increased significantly during the summer travel season, rising from 67.42% in 
-- May to 88.61% in June and peaking at 92.97% in July.

-- Strong occupancy levels continued through August (89.55%), indicating sustained 
-- peak-season demand.

-- Following the summer peak, occupancy declined sharply to 65.80% in September, 
-- representing the lowest occupancy level of the year.

-- Demand recovered during the holiday season, with occupancy reaching 81.99% in November 
-- and 84.77% in December.

-- Occupancy remained relatively stable between 67% and 70% during January, February, May, 
-- and October, suggesting these periods experienced more moderate demand.

-- The hotel experienced strong seasonality, with occupancy peaking during the summer 
-- travel season and recovering again during the holiday period. These demand patterns 
-- align closely with the revenue and ADR trends observed throughout the year, indicating 
-- that high-demand periods supported both stronger occupancy and higher room rates.

-- Recommendation:
-- Continue implementing dynamic pricing and inventory management strategies during peak 
-- summer and holiday periods to maximize revenue opportunities. During lower-demand months 
-- such as September, February, and May, consider targeted promotions, loyalty offers, and 
-- marketing campaigns designed to stimulate occupancy while maintaining rate integrity.


-- Query 8. How far in advance do guests typically book?

SELECT
    CASE
        WHEN lead_time_days <= 7 THEN '0-7 Days'
        WHEN lead_time_days <= 30 THEN '8-30 Days'
        WHEN lead_time_days <= 60 THEN '31-60 Days'
        WHEN lead_time_days <= 90 THEN '61-90 Days'
        ELSE '90+ Days'
    END AS booking_window,
    COUNT(*) AS bookings,
    ROUND(AVG(adr),2) AS avg_adr,
	ROUND(SUM(room_revenue),2) AS total_revenue
FROM vw_revenue_management
GROUP BY booking_window
ORDER BY
    CASE booking_window
        WHEN '0-7 Days' THEN 1
        WHEN '8-30 Days' THEN 2
        WHEN '31-60 Days' THEN 3
        WHEN '61-90 Days' THEN 4
        ELSE 5
    END;

-- Findings:
-- Guests most frequently booked more than 90 days in advance, accounting for 3,006 
-- bookings and generating approximately $2.98 million in room revenue.

-- Reservations made 61–90 days before arrival generated 1,608 bookings and $1.66 million 
-- in revenue.

-- Guests booking 31–60 days in advance contributed 1,570 bookings and $1.60 million in 
-- revenue.

-- Short-term bookings within 7 days of arrival were relatively uncommon, totaling only 242 
-- bookings, but achieved the highest ADR ($328.31) of any booking window.

-- ADR generally declined as the booking window increased, ranging from $328.31 for 
-- last-minute reservations to $304.76 for bookings made more than 90 days in advance.

-- Long-term bookings drive the majority of reservation volume and revenue, providing 
-- strong demand visibility for forecasting and inventory planning. However, last-minute 
-- bookings command the highest room rates, indicating that urgent travel demand supports 
-- premium pricing opportunities.

-- Recommendation:
-- Continue encouraging advance bookings through early-booking promotions and package 
-- offers to secure future occupancy and improve forecast accuracy. Simultaneously, 
-- maintain dynamic pricing strategies for short-term booking windows to capitalize on 
-- higher willingness to pay among last-minute travelers.


-- Query 9. Which rate plans generate the most revenue?

SELECT
    rate_plan,
    ROUND(SUM(room_revenue),2) AS total_revenue
FROM vw_revenue_management
GROUP BY rate_plan
ORDER BY total_revenue DESC;

-- Findings:
-- The Best Available Rate (BAR) generated the highest revenue at $2.35 million, making it 
-- the hotel's most valuable pricing strategy.

-- Advance Purchase generated approximately $1.37 million in revenue, ranking second among 
-- all rate plans.

-- Package Rate generated $1.32 million, demonstrating the effectiveness of bundled 
-- offerings in driving revenue.

-- Group Block bookings contributed $1.03 million, highlighting the importance of group 
-- business to overall performance.

-- Rewards Member Rate generated approximately $800,000, reflecting the value of 
-- loyalty-program participation.

-- Corporate Negotiated rates produced the lowest revenue at $738,000, although these 
-- agreements may provide demand stability and repeat business.

-- The Best Available Rate significantly outperformed all other rate plans, generating 
-- approximately 71% more revenue than the second-highest performing rate plan (Advance 
-- Purchase). This suggests that standard pricing strategies remain the hotel's primary 
-- revenue driver despite the availability of discounted and negotiated rate options.

-- Recommendation:
-- Continue optimizing Best Available Rate pricing during high-demand periods while using 
-- Advance Purchase, Package, and Loyalty rate plans strategically to stimulate demand 
-- during lower-occupancy periods. Regularly evaluate the performance of negotiated and 
-- discounted rate plans to ensure they support occupancy goals without unnecessarily 
-- diluting revenue.


-- Query 10. Which rate plans achieve the highest ADR?
SELECT
    rate_plan,
    ROUND(AVG(adr),2) AS avg_adr
FROM vw_revenue_management
GROUP BY rate_plan
ORDER BY avg_adr DESC;

-- Findings:
-- The Package Rate achieved the highest ADR at $370.91, outperforming all other rate plans.

-- The Best Available Rate (BAR) generated the second-highest ADR at $330.15 while also 
-- producing the highest total revenue.

-- Rewards Member Rates achieved an ADR of $304.81, outperforming both Advance Purchase and 
-- negotiated rate plans.

-- Advance Purchase bookings generated an ADR of $297.51, reflecting the discounted pricing 
-- often used to secure bookings further in advance.

-- Corporate Negotiated and Group Block rates produced the lowest ADRs at $269.31 and 
-- $254.16, respectively.

-- The ADR difference between the highest-performing rate plan (Package Rate) and the 
-- lowest-performing rate plan (Group Block) was approximately 46%.

-- While the Best Available Rate generated the highest overall revenue, the Package Rate 
-- demonstrated the strongest pricing power by achieving the highest ADR. This suggests 
-- that bundled offerings may encourage guests to pay premium rates while enhancing 
-- perceived value.

-- Recommendation:
-- Continue promoting Package Rates during high-demand periods to maximize ADR and overall 
-- guest spend. At the same time, monitor discounted and negotiated rate plans to ensure 
-- occupancy gains justify the lower average room rates associated with these segments.


-- Query 11. What was the overall accuracy of hotel demand forecasts?

SELECT
    ROUND(AVG(ABS(forecast_error_pct)),2) AS avg_forecast_error_pct,
    ROUND(100 - AVG(ABS(forecast_error_pct)),2) AS forecast_accuracy_pct
FROM vw_revenue_management;

-- Findings:
-- Hotel demand forecasts achieved an overall accuracy rate of 93.52%.

-- The average forecast error was 6.48%, indicating that projected demand was generally 
-- within a relatively narrow range of actual demand.

-- Forecast performance remained strong despite fluctuations in occupancy, pricing, and 
-- seasonal demand throughout the year.

-- The relatively low forecasting error suggests that demand planning processes were 
-- effective in anticipating booking patterns and occupancy levels.

-- Demand forecasts demonstrated a high degree of accuracy, with actual demand varying by 
-- an average of only 6.48% from projected demand levels. This level of forecasting 
-- precision supports more effective pricing, staffing, inventory management, and revenue 
-- optimization decisions.

-- The hotel maintained a forecast accuracy rate exceeding 93%, indicating that revenue 
-- management teams were generally successful in anticipating demand and adjusting pricing 
-- and inventory strategies accordingly.

-- Recommendation:
-- Continue leveraging historical demand patterns, booking behavior,
-- and seasonal trends to support forecasting efforts. Regularly
-- reviewing forecast deviations may help further improve forecast
-- precision and enhance revenue management decision-making.


-- Query 12. Which months experienced the largest forecast errors?

SELECT
    strftime('%Y-%m', arrival_date) AS month,
    ROUND(AVG(ABS(forecast_error_pct)),2) AS avg_forecast_error_pct
FROM vw_revenue_management
GROUP BY month
ORDER BY avg_forecast_error_pct DESC;

-- Findings:
-- Forecast error remained relatively stable throughout 2025, ranging from 6.24% to 6.79%.

-- February recorded the highest forecast error at 6.79%, making it the most challenging 
-- month to predict accurately.

-- July experienced the second-highest forecast error at 6.73%, suggesting that peak summer 
-- demand introduced additional forecasting complexity.

-- May recorded the lowest forecast error at 6.24%, indicating the highest forecasting 
-- accuracy of any month.

-- Despite seasonal fluctuations in occupancy, ADR, and revenue, forecast errors remained 
-- within a narrow range of approximately 0.55 percentage points, demonstrating a high 
-- level of forecasting consistency throughout the year.

-- Demand forecasts remained consistently accurate across all months, with forecast errors 
-- varying by less than one percentage point between the highest- and lowest-error periods. 
-- This suggests that forecasting processes were effective at anticipating demand 
-- regardless of seasonality or occupancy fluctuations.

-- Recommendation:
-- Continue leveraging historical demand patterns and seasonal booking trends within 
-- forecasting models. While overall forecast accuracy remains strong, additional analysis 
-- of February and July may help identify factors contributing to slightly higher 
-- forecasting errors during those periods.


-- Query 13. Which market segments have the highest cancellation rates?

SELECT
    market_segment,
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings,
    ROUND(
        100.0 * SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS cancellation_rate
FROM vw_revenue_management
GROUP BY market_segment
ORDER BY cancellation_rate DESC;

-- Findings:
-- The Corporate segment recorded the highest cancellation rate at 14.48%, with 170 
-- cancelled bookings out of 1,174 total reservations.

-- The Family segment generated the largest number of cancelled bookings (263) despite a 
-- lower cancellation rate (12.89%) because it represented the hotel's largest booking 
-- segment (2,040 reservations).

-- Leisure travelers accounted for 244 cancelled bookings, the second-highest cancellation 
-- volume, while maintaining a cancellation rate of 13.02%.

-- Rewards Members experienced a cancellation rate of 13.96%, resulting in 105 cancelled 
-- bookings.

-- Convention and Group segments demonstrated the strongest booking commitment, recording 
-- the lowest cancellation rates at 11.84% and 11.92%, respectively.

-- Cancellation rates remained relatively consistent across segments, varying by only 2.64 
-- percentage points between the highest- and lowest-performing groups.

-- While Corporate travelers exhibited the highest cancellation rate, the Family and 
-- Leisure segments had the greatest operational impact due to their larger booking 
-- volumes, accounting for a combined 507 cancelled reservations. This suggests that both 
-- cancellation rates and booking volume should be considered when evaluating revenue risk.

-- Although Corporate bookings experienced the highest cancellation rate, all market 
-- segments remained within a relatively narrow range of approximately 12%–15%, suggesting 
-- that cancellation behavior was broadly consistent across the hotel's customer base.

-- Recommendation:
-- Continue monitoring Corporate bookings due to their elevated cancellation rate while 
-- prioritizing forecasting and inventory management strategies for Family and Leisure 
-- travelers, as these segments contribute the largest number of cancelled reservations. 
-- Understanding both cancellation frequency and cancellation volume can help improve 
-- occupancy forecasting and revenue optimization efforts.


-- Query 14. Which booking channels have the highest cancellation rates?

SELECT
    channel_type,
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings,
    ROUND(
        100.0 * SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END)
        / COUNT(*),
    2) AS cancellation_rate
FROM vw_revenue_management
GROUP BY channel_type
ORDER BY cancellation_rate DESC;

-- Findings:
-- The Corporate channel recorded the highest cancellation rate at 13.83%, with 168 
-- cancelled bookings out of 1,215 total reservations.

-- The Direct channel generated the highest volume of cancelled bookings (404) despite a 
-- slightly lower cancellation rate (13.31%) because it represented the hotel's largest 
-- booking channel (3,036 reservations).

-- Third-Party channels experienced a cancellation rate of 13.00%, resulting in 259 
-- cancelled bookings.

-- Group bookings demonstrated the strongest booking commitment, recording the lowest 
-- cancellation rate at 11.92% and only 146 cancelled reservations.

-- Cancellation rates remained relatively consistent across distribution channels, ranging 
-- from 11.92% to 13.83%, a difference of less than two percentage points.

-- While Corporate bookings exhibited the highest cancellation rate, Direct channels 
-- generated the greatest cancellation volume due to significantly higher booking activity. 
-- This suggests that cancellation risk should be evaluated using both cancellation 
-- percentages and booking volume to fully understand operational and revenue impacts.

-- Recommendation:
-- Continue monitoring Corporate bookings due to their elevated cancellation rate while 
-- prioritizing forecasting and inventory management efforts within Direct channels, where 
-- cancellation volume is highest. Understanding both cancellation frequency and 
-- cancellation volume can support more accurate demand forecasts and revenue optimization 
-- strategies.


-- =================================================
-- Executive Summary
-- =================================================

-- This analysis evaluated hotel revenue performance, pricing strategy,
-- occupancy trends, booking behavior, demand forecasting accuracy,
-- and cancellation risk using a fictional dataset of 7,468 hotel bookings.

-- Revenue performance exhibited strong seasonality throughout 2025,
-- with July emerging as the highest-performing month in terms of
-- revenue, occupancy, ADR, and booking volume.

-- Family and Leisure travelers generated the largest share of room
-- revenue, while Direct booking channels accounted for the highest
-- overall revenue contribution and represented the hotel's most
-- valuable distribution strategy.

-- Standard room categories served as the primary revenue drivers due
-- to high booking volume, while premium suite categories achieved the
-- highest ADRs and demonstrated the strongest pricing power.

-- Analysis of occupancy and pricing performance showed that higher
-- demand levels supported both increased ADRs and significantly higher
-- revenue generation, reflecting effective revenue management and
-- dynamic pricing practices.

-- Booking window analysis revealed that reservations made more than
-- 90 days in advance generated the majority of bookings and revenue,
-- while last-minute reservations achieved the highest ADRs.

-- Best Available Rate generated the highest overall revenue, while
-- Package Rates achieved the highest ADR, highlighting the balance
-- between volume-driven revenue and pricing optimization.

-- Demand forecasting performance remained strong throughout the year,
-- achieving an overall forecast accuracy rate of 93.52% with
-- consistently low forecast error across all months.

-- Cancellation rates remained relatively stable across market
-- segments and booking channels. However, Family, Leisure, and Direct
-- bookings generated the highest volume of cancelled reservations,
-- creating the greatest operational impact on occupancy forecasting
-- and inventory management.

-- Overall findings suggest opportunities to maximize revenue through
-- continued investment in direct booking channels, dynamic pricing
-- strategies, premium room upselling, demand-generation initiatives
-- during lower-demand periods, and ongoing refinement of forecasting
-- and inventory management practices.


-- =================================================
-- Conclusion
-- =================================================

-- This analysis demonstrated how pricing strategy, occupancy,
-- booking behavior, forecasting accuracy, and cancellation risk
-- collectively influence hotel revenue performance.

-- Results showed that revenue growth was driven by both increased
-- occupancy and stronger pricing power during peak demand periods.
-- Direct booking channels, Family and Leisure travelers, and
-- Standard room categories served as the primary revenue drivers,
-- while premium accommodations achieved the strongest pricing
-- performance.

-- Demand forecasting remained highly accurate throughout the year,
-- supporting effective inventory and revenue management decisions.

-- Overall, the findings highlight opportunities to maximize
-- revenue through continued investment in direct booking channels,
-- dynamic pricing strategies, premium room upselling, targeted
-- demand-generation initiatives, and ongoing refinement of
-- forecasting and inventory management practices.
