# Crime and Safety
## About this project
This dataset contains 1,000 detailed crime reports collected over the past two years in an urban area. Each record includes the type of crime, precise location coordinates, date and time of occurrence, neighborhood information, 
and victim demographics such as age, gender, and ethnicity. Additional fields cover whether a weapon was involved and if the crime was reported to police. This data is ideal for building predictive models to identify
crime hotspots, improve public safety alerts, and support community policing efforts. The time span of this dataset is from the end of _July 2020_ to the end of _July 2025_.

## Thought process in analysis
<img width="700" height="170" alt="image" src="https://github.com/user-attachments/assets/d89b80a3-8995-48ed-9c11-5783b624bcb7" />

## Goal 
Understanding the patterns and behavior of criminals. Finding out the insight of best time and place for perpetrators to commit crimes. Is there a correlation between the type of crime and the characteristics of the victim?

### Task
1. Identify crime trends over time in the dataset. How many cases occurred within the time span in the dataset?
2. Where do crimes often occur? Which state has the most crime? Which city? Where exactly? How about the least?
3. Find the top 3 cities where crime occurs most frequently. What is the crime trend based on the top 3?
4. What time do crimes most often occur? Were there a specific time span?
5. Identify victim demographics
6. Were there any correlation between victim age and the type of crime? what type of crime occurs most often?
7. What are the crime trends based on the types of crimes that occur most frequently?


## Prepare Data
I used data from `Kaggle`. **[Download](https://www.kaggle.com/datasets/shamimhasan8/crime-and-safety-dataset)**


Here is my `Excel` file **[Portfolio Project - Crime Safety.xlsx](https://github.com/user-attachments/files/21531164/Portfolio.Project.-.Crime.Safety.xlsx)**



## Process Data
The downloaded dataset is in csv format, so I separated ',' with Text To Column. This dataset is already clean and formatted so it does not require further data cleaning.

## Analyze based on the questions that are the goal of this project

|1. Identify crime trends over time in the dataset. How many cases occurred within the time span in the dataset? | Metric | Dimension | Key Finding
|---|---|---|---|
|I used Pivot table to count Case id, then grouping by date. Insert line chart to identify the trend over years |id|date|There have been 1,000 cases in the last five years. In late mid-2020, there were 92 cases, then they surged to a peak of 215 cases in 2022. Cases decreased to 107 cases by the end of July 2025.

<img width="400" height="300" alt="image" src="https://github.com/user-attachments/assets/1121e783-8a84-4484-b15b-c380153b546a" />

|2. Where do crimes often occur? Which state has the most crime? Which city? Where exactly? How about the least?| Metric | Dimension | Key Finding
|---|---|---|---|
| I used Pivot table to count id based on city and state | id |state, city, location|In Texas, both Dallas and Houston had the most crimes with 106 cases each. San Diego, CA has the fewest number of cases at 91. The specific locations where crimes occur vary widely. This indicates that crimes can occur anywhere without a specific location.|

<img width="400" height="300" alt="image" src="https://github.com/user-attachments/assets/fc6adead-1e6d-4350-9279-fcf8a1569117" />

|3. Find the top 3 cities where crime occurs most frequently. What is the crime trend based on the top 3?| Metric | Dimension | Key Finding
|---|---|---|---|
| Count id, grouping by city and then filter the value of id to find Top 3. Change the value to % of row total, then used conditional formating to get quick insight of the highest percent | id | city, date | The top 3 cities with the most crime cases are Dallas, Houston and New York. This is the crime rate trend based on the top 3 cities |

<img width="400" height="300" alt="image" src="https://github.com/user-attachments/assets/40894280-e546-4a06-859d-7c6e9c116dbb" />

|4. What time do crimes most often occur? Were there a specific time span? | Metric | Dimension | Key Finding
|---|---|---|---|
|Add weekday field to dataset and return days like Sunday, Monday etc using TEXT function. Used pivot table to count id based on weekdays and show value as % total. Put time field to Rows and select Hours only | id | time, weekday | On a weekly basis, 16% of the highest crime rates occur on Fridays. This is 2% higher than the 14% average, with no significant difference in crime rates on other days. In terms of hours the highest crime rate occurs at 6 pm to 10 pm at 5.4% and 5,1%. This may happen because people are on their way home after finishing their activities.

<img width="400" height="300" alt="image" src="https://github.com/user-attachments/assets/6d90d619-3899-4284-9916-e89d0dbc2f69" />

<img width="600" height="300" alt="image" src="https://github.com/user-attachments/assets/4948a895-3212-41e1-96e8-f5245fd418df" />


|5. Identify victim demographics| Metric | Dimension | Key Finding
|---|---|---|---|
|Filtered victim_age to find age range. Used pivot table to count id based on gender and ethnic. Then change the value to % of total| Id | victim_gender, victim_race, victim_age | The age range of crime victims is between 12-90 years. The highest number of victims of crime are men at 27% of the total and the lowest were non-binary at 23%. The distribution of crime rates against gender is quite even at 25%. The same goes for Asian and other ethnic groups. Similarly, ethnicity has an average crime rate of 20%.

<img width="201" height="121" alt="image" src="https://github.com/user-attachments/assets/1e5b3eec-fed2-4e46-82f3-1abf62f25f21" /> <img width="175" height="121" alt="image" src="https://github.com/user-attachments/assets/2edde8df-37b9-4501-8f1f-e75ebcbc1db5" />

|6. Were there any correlation between victim age and the type of crime? what type of crime occurs most often?| Metric | Dimension | Key Finding
|---|---|---|---|
|I put victim_age to Rows and crime_type to Column. Then count id in Value area. Copied and paste pivot table to new sheet as crime_type vs age then create scatter plot chart based on 2 variables victim_age and each of crime_type to find if any corelation between the two| Id | crime_type, date | The distribution of the two variables between age and type of crime is quite even. There was no positive or negative correlation between the two variables. Types of crimes such as robbery and domestic violence occurred most frequently in the last 5 years with a total of 121 cases each. 

<img width="1300" height="900" alt="image" src="https://github.com/user-attachments/assets/dc292ff3-b12e-481d-a096-e56c8169403a" />

|7. What are the crime trends based on the types of crimes that occur most frequently?| Metric | Dimension | Key Finding
|---|---|---|---|
|Count id in Value area, date(year) in Rows and crime_type in Columns with pivot table then create line chart based on the fields| Id | crime_type, date | Cases of robbery and domestic violence increased from late-mid July to early 2021. This was due to the absence of data from early 2021. Throughout 2021-2023, cases of robbery and domestic violence remained fairly stable at between 24 and 26 cases. Domestic violence cases increased drastically in 2024 with a total of 33 cases then it decreased drastically until mid-2025 with a total of 20 cases of robbery and domestic violence.

<img width="600" height="900" alt="image" src="https://github.com/user-attachments/assets/b6ff0d0b-8eeb-4807-9dfe-ed13d694b0d0" />


## Analysis Conclusion
Over the past five years, a total of 1,000 crime cases were recorded. The trend shows a significant fluctuation, starting with 92 cases in late-mid 2020, peaking at 215 cases in 2022, and then decreasing to 107 cases by the end of July 2025.
Geographically, Dallas, Texas, and Houston, Texas, reported the highest number of crimes, each with 106 cases. In contrast, San Diego, California, had the fewest cases at 91. 


The widespread nature of crime locations suggests that incidents are not concentrated in specific areas but can occur anywhere. The top three cities with the most crime cases are Dallas, Houston, and New York. The crime rate trend in these cities shows variations: Houston led in 2020 (40%) and 2022 (39%), Dallas in 2021 (38%), and New York in 2023 (36%) and 2024 (44%).
By mid-2025, Dallas and New York both reported 34%.Analysis of crime timing reveals that Fridays have the highest crime rate at 16%, which is 2% higher than the 14% average for other days, indicating no significant daily variations otherwise.
Hourly data shows a peak in crime rates between 6 PM and 10 PM, with 5.4% and 5.1% respectively. This could be attributed to people commuting home after daily activities. Regarding victims, the age range is broad, spanning from 12 to 90 years old. 
Men constitute the largest group of victims at 27%, while non-binary individuals are the least affected at 23%. 


The distribution of crime rates across genders is relatively even, around 25%. Similarly, for ethnic groups, Asian and other ethnicities show an average crime rate of 20%, with a fairly even distribution. There's no significant correlation, positive or negative, between victim age and crime type.
In terms of crime types, robbery and domestic violence were the most frequent in the last five years, each accounting for 121 cases. These cases saw an increase from late-mid July 2020 to early 2021, likely due to a lack of data for early 2021. From 2021 to 2023, both types remained stable, ranging between 24 and 26 cases. However, domestic violence cases surged in 2024 to 33 cases before significantly decreasing by mid-2025, alongside robbery, to a total of 20 cases for both.


> [!NOTE]
> This analysis project was created for educational purposes only. No organizations or third parties were involved!
