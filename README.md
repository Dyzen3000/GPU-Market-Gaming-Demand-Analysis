# GPU Market & Gaming Demand Analysis

## Business Problem

The PC gaming GPU market contains products with different performance levels, VRAM capacities, prices, and generations. Manufacturers, retailers, and consumers need a structured way to evaluate which GPUs offer an appropriate balance between gaming requirements, performance, memory capacity, and value. This is all the more important right now because of the upcomming release of the biggest game of the 2020s, GTA VI.

The objective of this project is to identify GPU segments and individual GPU models in the **$200–$599 price range** that can address the requirements of recent games, particularly in the **Action, Adventure, and RPG** genres.

The project combines PostgreSQL, Python, Excel, and Power BI to analyze game requirements, player activity, GPU specifications, price-to-performance value, and Steam Hardware Survey (SHS) adoption.

## Objectives

1. Analyze game counts and player activity by genre.
2. Measure recent game GPU performance and VRAM requirements.
3. Calculate mean, median, P75, P90, and maximum requirements.
4. Evaluate GPU models in the $200–$599 price range.
5. Compare performance, VRAM, MSRP, and price-to-performance.
6. Apply scenario-based sensitivity analysis.
7. Analyze SHS market share by GPU series, class, and price segment.
8. Present findings through Power BI dashboards.

## North Star Metrics 

| Column | Description |
|---|---|
| `Genre` | Game genre |
| `GPU_Performance` | Estimated GPU performance requirement |
| `GPU_VRAM` | Estimated VRAM requirement in GB |
| `GPU_MSRP` | GPU price associated with the requirement |

## Meanings of Gaming Terms 

1. AAA - The Biggest, Most anticipated and most usually also the most Taxing games on the system
2. VRAM - Is the amount of superfast onboard memory on the GPU itself, required for rendering game world
3. GPU Class - The Class of GPU tells the amount of performance it's expected to deliver and price point it aims for.

## Data Structure and Overview

### Game ID Database

Lists all the games on steam with corresponding release date, player numbers and genre tags. Required to collect player numbers and slice by Genre(Action, Adventure, RPG, Indie, Strategy) and Game types(Multiplayer, Single Player, Free to play). Only top 970 games are used in this analysis because they account for 95% of the player base and the remaining 123899 only account for 5%.

<img width="653" height="367" alt="Cutoff" src="https://github.com/user-attachments/assets/9ea98c45-dd1b-42fb-9f22-36873f15b780" />


### Game Requirements Dataset

Lists the Games and the hardware configuration that is required to run it(GPU, RAM, CPU). Minimum system requirements are hardware specification to run game at low resolution and settings while recommended specs are to run game at higher settings and resolution. **Latest games(released in last 3 years)** are used at the end of analysis to determine best GPU as they have the newest rendering techniques and are the most taxing on Hardware.

### Steam Hardware Survey Dataset

Steam Hardware Survey(SHS) is used as an indicator of installed hardware adoption, not as a direct measure of sales. It gives us an idea of the hardware gamers have and thus a price point to target. Only DX12 numbers for GPUs share is used as it accounts for 91% of all games and the software all new games run on.

<img width="710" height="236" alt="Direct X" src="https://github.com/user-attachments/assets/6a1c10c3-d68b-474c-9f14-4382a9fa7da0" />

### GPU Specifications Dataset

Lists all the popular GPUs of last 10+ years and is used as the broader GPU model universe for the final selection process. It contains model-level information such as performance, VRAM, MSRP, price-to-performance, GPU class, GPU series, and availability-related fields to narrow down the best GPUs based on several factors.

The specification dataset is used for model selection because SHS does not include every GPU model.

## Tools and Technologies

- **PostgreSQL / SQL:** Cleaning, transformation, aggregation, filtering, and market-share analysis.
- **Python:** Statistical analysis, percentile calculations, candidate filtering, and sensitivity scoring.
- **Pandas:** Data manipulation.
- **Matplotlib:** Performance and VRAM histograms.
- **Excel:** Pivot tables and supporting analysis.
- **Power BI:** Interactive dashboards and data visualization.

## Methodology

### Game Requirement Analysis

The analysis examines:

- Game counts by genre.
- Releases by year and genre.
- Player activity by genre.
- Average GPU performance requirements.
- Average VRAM requirements.
- Requirement distributions using mean, median, P75, P90, and maximum.

### GPU Candidate Filtering

The candidate set is restricted to GPUs with an MSRP between **$200 and $599**, as they account for 50% of the market and no GPUs below $200 are recommended for any of the Latest AAA games. GPUs of Mid and Mid+ Class are present in this range. Models are evaluated using performance, VRAM, and price-to-performance.

### Sensitivity Analysis

The following metrics are normalized using min-max normalization:

```python
Score = (Value - Minimum Value) / (Maximum Value - Minimum Value)
```

The scoring scenarios are:

| Scenario | Performance | VRAM | Price-to-Performance |
|---|---:|---:|---:|
| Value Focused | 0.15 | 0.10 | 0.75 |
| Balanced | 0.25 | 0.25 | 0.50 |
| Performance Focused | 0.75 | 0.20 | 0.05 |

The final score is calculated as:

```text
Fit Score =
    Performance Score × Performance Weight
  + VRAM Score × VRAM Weight
  + Price-to-Performance Score × Price-to-Performance Weight
```

## Executive Summary

Action games have the highest average GPU performance requirement among the three focus genres, while RPG games have the highest average VRAM requirement.

| Genre | Game Count | Average Required Performance | Average Required VRAM |
|---|---:|---:|---:|
| Action | 94 | 67.50 | 8.68 GB |
| RPG | 61 | 66.64 | 8.75 GB |
| Adventure | 74 | 65.74 | 8.62 GB |

The results indicate that:

- Action has the highest average performance requirement.
- RPG has the highest average VRAM requirement.
- A performance score near 75 is relevant to the P75 requirement for Action and RPG.
- A 12 GB VRAM level is relevant to the P90 requirement across the focus genres.
- The $200–$599 segment contains GPUs with different performance, VRAM, and value trade-offs.
- The selected GPU changes according to the scenario weights.

## Insights Deep Dive

### 1. Genre Distribution

The Power BI visualization shows the following game counts:

| Genre | Number of Games |
|---|---:|
| Action | 406 |
| Adventure | 290 |
| Simulation | 256 |
| Indie | 255 |
| RPG | 235 |
| Strategy | 192 |

These values reflect the genre visualization and depend on the dataset's genre-record structure. Action, Adventure and RPG have the most games in top 1970 games.

### 2. Player Activity

Approximate total peak concurrent users shown in Power BI:

| Genre | Total Peak Concurrent Users |
|---|---:|
| Action | 2.6M |
| Adventure | 1.7M |
| RPG | 1.2M |
| Indie | 0.9M |
| Simulation | 0.8M |
| Strategy | 0.6M |

Peak concurrent users are an activity measure and should not be interpreted as unique users, sales, or revenue. Once again the 3 most popular genre are Action, Adventure and RPG thus the need to focus on these 3 more. 

### 3. Requirement Statistics

#### GPU Performance

| Genre | Mean | Median | P75 | P90 | Maximum |
|---|---:|---:|---:|---:|---:|
| Action | 67.50 | 65.00 | 75.00 | 80.00 | 85.00 |
| Adventure | 65.74 | 65.00 | 70.00 | 78.50 | 85.00 |
| RPG | 66.64 | 65.00 | 75.00 | 80.00 | 85.00 |

The P75 metric is the most realistic as it account for majority latest games and thus GPUs with those specifications will deliver very good perf even if they struggle with the most demanding games at Max settings, P90 is more usefull if the need is to play at Max settings. For this analysis P75 metric is most relavent as it represents the upper end of system requirements without getting skewed by the very most demanding games. 

#### VRAM

| Genre | Mean | Median | P75 | P90 | Maximum |
|---|---:|---:|---:|---:|---:|
| Action | 8.68 GB | 8.00 GB | 10.75 GB | 12.00 GB | 16 GB |
| Adventure | 8.62 GB | 8.00 GB | 8.00 GB | 12.00 GB | 16 GB |
| RPG | 8.75 GB | 8.00 GB | 12.00 GB | 12.00 GB | 16 GB |

The P75 and P90 values provide reference thresholds for comparing GPU specifications. They do not guarantee a particular frame rate or graphical setting but genreally a higher VRAM is better for future proofing as games will continue to need more VRAM.

### 4. GPU Models in the Target Price Range

Examples of GPU models identified in the $200–$599 specification dataset include:

| GPU Model | Performance | VRAM | MSRP |
|---|---:|---:|---:|
| RTX 5060 Ti | 85 | 16 GB | $429 |
| RX 9070 XT | 90 | 16 GB | $499 |
| RX 7900 GRE | 85 | 16 GB | $549 |
| RX 9070 | 85 | 16 GB | $550 |
| RX 9060 XT | 80 | 16 GB | $359 |
| RX 7800 XT | 80 | 16 GB | $499 |
| RTX 4060 Ti | 80 | 16 GB | $499 |
| RTX 5070 | 85 | 12 GB | $549 |
| RTX 4070 SUPER | 85 | 12 GB | $599 |
| RX 7700 XT | 80 | 12 GB | $449 |
| Arc B580 | 75 | 12 GB | $249 |
| RX 7600 XT | 75 | 16 GB | $329 |

This comparison highlights the trade-off between performance, VRAM, MSRP, and price-to-performance.

### 5. Action-Focused Sensitivity Analysis

| Scenario | Model | Performance | VRAM | Launch MSRP | Price-to-Performance | Fit Score |
|---|---|---:|---:|---:|---:|---:|
| Balanced | RX 9070 XT | 90 | 16 GB | $499 | 18.04 | 0.6967 |
| Performance Focused | RX 9070 XT | 90 | 16 GB | $499 | 18.04 | 0.9242 |
| Price Sensitive | Arc B580 | 75 | 12 GB | $249 | 30.12 | 0.7500 |

The sensitivity analysis shows that different weighting schemes lead to different model selections. The Fit Score is a relative score within the candidate set and is not an objective probability of gaming success.

### 6. Steam Hardware Survey

The latest SHS visualization shows the following GPU series shares:

| GPU Series | SHS Share |
|---|---:|
| GF30 | 16.6 |
| GF40 | 15.7 |
| GF50 | 10.6 |
| GF16 | 6.4 |
| GF10 | 5.6 |
| GF20 | 4.6 |
| R7000 | 2.3 |
| R6000 | 2.3 |
| R500 | 1.7 |
| R5000 | 1.3 |

SHS provides context about installed hardware adoption. It does not represent all GPU sales or every GPU currently available.

### 7. Excel Supporting Analysis

#### Average GPU MSRP by launch year and GPU class.

<img width="476" height="232" alt="Screenshot 2026-09-18 212408" src="https://github.com/user-attachments/assets/03ad8f75-4d73-46c6-a85f-d974b24508f5" />

#### Average VRAM by Year and GPU Class.

<img width="351" height="181" alt="Screenshot 2026-08-27 003550" src="https://github.com/user-attachments/assets/8bf1225b-b7c1-4e2c-88c1-ddf4e533d824" />

#### Average GPU performance by launch year and GPU class.

<img width="350" height="239" alt="Screenshot 2026-09-18 212526" src="https://github.com/user-attachments/assets/3625d6d2-fc28-4b3a-9b3c-b1ecb0b1a4d3" />

#### SHS GPU share by GPU class and year.

<img width="467" height="148" alt="Screenshot 2026-09-18 212633" src="https://github.com/user-attachments/assets/5e5d4843-e1da-4f00-a96d-51cd41d7a971" />

#### VRAM comparison of available GPUs by series.

<img width="173" height="129" alt="image" src="https://github.com/user-attachments/assets/32554420-a021-4043-aae4-7ebecfb3fdaa" />


### 8. Power BI Supporting Analysis

1. **Game Genre Attributes**
   - Game count by genre.
   - Game releases by year and genre.
   - Player activity by genre.

2. **Hardware Required to Play Latest Games**
   - Recent game counts.
   - Player numbers by GPU price segment.
   - Average required performance and VRAM.
   - Recommended GPU specifications.

3. **GPUs That Meet Latest Game Requirements**
   - GPU performance versus requirement thresholds.
   - Models meeting the average Action game requirement.

4. **Latest SHS GPU Market Share**
   - Share by GPU series.
   - Performance by GPU series.
   - Launch MSRP by GPU series.

5. **GPU Share Over Time**
   - GPU class share over time.
   - Price-segment share over time.

6. **Best Available GPUs in the Price Bracket**
   - Price-to-performance comparison.
   - VRAM comparison.
   - Model-level GPU specifications.

## Next Steps

1. Add current retail prices in addition to launch MSRP.
2. Include regional pricing, taxes, discounts, and stock availability.
3. Separate performance requirements by resolution, such as 1080p, 1440p, and 4K.
4. Distinguish minimum, recommended, and ultra-quality requirements.
5. Add consistent benchmark data and FPS measurements.
6. Separate rasterization and ray-tracing performance.
7. Analyze VRAM requirements by resolution and graphics preset.
9. Test alternative scoring methods and scenario weights.
10. Report missing SHS model matches explicitly.

## Limitations

- The datasets may not represent the entire PC gaming or GPU market.
- GPU performance values may be estimated or derived rather than standardized benchmark scores.
- SHS does not include every GPU model in the specification dataset.
- SHS share represents installed hardware adoption, not direct sales.
- Launch MSRP is not the same as current retail price.
- Prices vary by country, retailer, model variant, and time.
- Genre averages and percentiles do not guarantee performance in every individual game.
- The analysis does not fully account for CPU requirements, system RAM, storage, drivers, power consumption, or ray-tracing performance.

## Conclusion

This project combines game requirements, GPU specifications, market-share data, statistical analysis, and dashboard reporting to evaluate GPUs in the **$200–$599 price range**.

Action games show the highest average performance requirement among the three focus genres, while RPG games show the highest average VRAM requirement. The sensitivity analysis demonstrates that the selected GPU depends on the relative importance assigned to performance, VRAM, and price-to-performance. 

The project provides a structured comparison framework for GPU positioning and selection rather than a single universal recommendation.

## Project Workflow

```text
Raw Datasets
    |
    v
PostgreSQL Data Cleaning and Transformation
    |
    v
Python Statistical and Exploratory Analysis
    |
    v
Requirement Thresholds and GPU Candidate Filtering
    |
    v
Sensitivity Analysis and GPU Fit Scoring
    |
    v
Excel Pivot Tables
    |
    v
Power BI Dashboards
```

## Author

**Rohan S**

**Tools:** PostgreSQL | Python | Pandas | Matplotlib | Excel | Power BI
