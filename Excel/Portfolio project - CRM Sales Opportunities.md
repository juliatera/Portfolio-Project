# CRM Sales Opportunities

## About this project :
This is a portfolio project that captures data about the B2B sales pipeline from a fictitious company that sells computer hardware, including information on accounts, products, sales teams, and sales opportunities. The goal is to find useful information, identify patterns and trends, and make data-based decisions.
Link download File [Portfolio project - CRM Sales Opportunities.xlsx](https://github.com/user-attachments/files/21504673/Portfolio.project.-.CRM.Sales.Opportunities.xlsx)


## Thought Process Analysis
<img width="1207" height="219" alt="image" src="https://github.com/user-attachments/assets/d8c2e3d0-f7a9-4f91-940a-7089dfce7078" />

### Goal : Increase sales agent win rate
1. How is each sales team performing compared to the rest?
2. Who’s the best sales agent? Are any sales agents lagging behind?
3. Identify any quarter-over-quarter trends
4. Do any products have better win rates?

### Prepare Data
I use data from `Maven Analytics` [Download](https://maven-datasets.s3.amazonaws.com/CRM+Sales+Opportunities/CRM+Sales+Opportunities.zip)

### Process Data
I processed the data using Power Query in Excel. I cleaned and formatted the data to suit its data type.

### Analyze based on the questions that are the goal of this project
| 1. How is each sales team performing compared to the rest? | Tool | Key finding |
| --- | --- | --- |
| Using a pivot table to calculate the number of deals won by quarter | Pivot Table | In the first quarter of 2017, sales agents closed 531 deals. This figure is significantly lower because closing date data begins in March 2017. In the second and third quarters, the number of deals won was relatively the same, with 1,254 and 1,257 deals won, respectively. This was a slight decrease in the fourth quarter to 1,196.

<img width="460" height="275" alt="image" src="https://github.com/user-attachments/assets/ee28c000-8a70-41f2-b5a6-f802029b2625" />

| 2. Who’s the best sales agent? Are any sales agents lagging behind? | Tool | Key finding |
| --- | --- | --- |
| Using a pivot table to calculate the number of opportunities by sales agent, sorting largest to smallest, grouping by quarter and filtering by deal stage | Pivot Table | The best sales agent is Darcel Schlecht with 349 total deals won. There are 17 out of 30 sales agents who have a win rate below the average of the total rate of deals won.

<img width="452" height="871" alt="image" src="https://github.com/user-attachments/assets/e693f888-a098-41a1-b129-691972641268" />

| 3. Identify any quarter-over-quarter trends | Tool | Key finding |
| --- | --- | --- |
| Using a pivot table to calculate the percentage of the number of won and lost deal stages then grouping them by quarter | Pivot Table | The highest win rate occurred in the 1st quarter at 82.07% of the total and the highest loss rate occurred in the 4th quarter at 39.75% of the total

<img width="460" height="275" alt="image" src="https://github.com/user-attachments/assets/f3db1792-d5bb-4a1b-becf-ff758bfc4cc1" />

| 4. Do any products have better win rates? | Tool | Key finding |
| --- | --- | --- |
| Using a pivot table to calculate the percentage of the number of won deal stages, sorting from largest to smallest then grouping by product | Pivot Table | GTX Basic is the product with the highest win rate of 21.59%, while GTK 500 has the smallest win rate of 0.35%.

<img width="460" height="275" alt="image" src="https://github.com/user-attachments/assets/ed9166a9-bcfc-4eb7-9fa3-973e1e0b9395" />

## Recommended steps to increase sales win rate :
1. Recognize and analyze the strategies of top performers like **Darcel Schlecht**. Understand what makes them successful
2. **Improve Underperforming Agents' Win Rates**. Identify these agents and provide targeted training and coaching. Focus on areas where they might be struggling, such as **lead qualification, objection handling, negotiation skills, or product knowledge**.
3. **Optimize Product Focus and Training**.
The disparity in product win rates (GTX Basic at **21.59%** vs. GTK 500 at **0.35%**) suggests a need for strategic intervention.
For GTX Basic: Continue to **prioritize and promote GTX Basic**, as it's clearly a strong performer. Ensure sales agents are well-equipped to sell this product effectively.
For GTK 500: **Investigate why GTK 500 has such a low win rate**. Is it a product issue, pricing, lack of market demand, or inadequate sales training?


> [!NOTE]
> This is fictitious data intended for portfolio purposes. The results of this analysis project do not represent what happens in the real world !! Thank You..























































