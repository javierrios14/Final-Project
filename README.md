## Project Overview
This project analyzes whether financial fundamentals can predict stock performance using S&P 500 data (2010–2016).

## Tools Used
- R (linear regression, data analysis)
- Excel (data cleaning)
- Data visualization (ggplot2, gtsummary)

## Key Findings
- Earnings Per Share (EPS) was the strongest predictor of stock returns
- Model showed very low predictive power (R² = 0.0007), highlighting market complexity
- Demonstrates limitations of using financial fundamentals alone for prediction

# Final-Project
This is a final project for my Intro to Data Science class. My project uses a Kaggle stock market dataset on S&P 500 companies from 2010 to 2016.

## Research Question: Can we predict how well a stock can perform by using public financial data?
The data that was pulled from Kaggle is the S&P 500 companies fundamentals and prices on the stock from the years 2010-2016. Experienced analysts from Wall Street to hedge funds spend tons of hours and money to predict what will happen on the market. I wanted to see if I could do a much simpler test on prediction using linear regression and NYSE stock data to figure out if I can predict the market. 

# Data
https://www.kaggle.com/datasets/dgawlik/nyse

Above is the link to the Kaggle Data Set I used to complete this project.
The link shows four different excel files but only two were used for this project. The two are the fundamentals.csv, which contains the companies details and KPI's, and the prices.csv, which has all the stock price information.

I had to clean the data by removing all N/A scattered in the excel file. Then I needed to engineer my target variable which is the annual return of the company. I did this by calculating the percentage change between a stock's first and last closing price each year. Finally, I merged all the data into one clean dataset with all the information I needed to create the graphs.


# Regression Table
This is my regression table I created using a new library called gtsummary. It's just the summary of my linear regression model (can be seen in the r file) but in a visualized table to be used in the presentation. 

The table shows which indicator is significant to our predictions. Earnings Per Share is seen to have the highest significance level among all the other indicators. It shows that for every dollar increase in EPS the company should expect a 0.38% increase in annual return. Current Ratio and Total Revenue show to have some influence but nowhere near what EPS can do.

<img width="1707" height="771" alt="Rplot" src="https://github.com/user-attachments/assets/4a2a4933-6dab-4c01-9f20-b8736dbdc8a7" />


# Coefficient Plot
This graph shows the same as the sumamry table but in a fun visual showing the large gap in how significant each idnicator is. Each bar represents an indicator with blue being significant and gray being not significant. 

First thing you see is how dominant EPS is compared to the other indicators. Current Ratio shows a small but positive effect on returns, while the other indicators show non-existent changes adn even negative impacts. These things we cannot ignore. The objective of this chart was to make it very easy to see which indicator matters and which do not.

<img width="1709" height="773" alt="what_matters" src="https://github.com/user-attachments/assets/ad3c7665-ace9-4f14-95b7-bcf8be012fbb" />


# EPS Scatter Plot
This scatter plot zooms in on our strongest indicator and the relationship EPS has with our annual stock return. Each dot represents one company in one year. The red line is the regression line showing the overall upward trend.

You can clearly see the red line sloping upward which matches the small percentage change seen in the table. It visually explains that higher earnings per share tend to have better annual stock returns. The dashed line at zero helps show the negative EPS companies tend to cluster below zero returns. At first glance, the scatter plot seems like a wide, random scatter of dots around the line but this shows that the relationship is real and random. This is not a correlated event and the stock returns can be influenced by many factors.

The orange circle lines in the middel of the graph show the density of data located there. Think of it as topography.


<img width="1709" height="773" alt="eps_vs_return" src="https://github.com/user-attachments/assets/00362914-4e88-4d8e-b7ab-6205d706862e" />


# Residual Plot
This is the model diagnostic plot. It shows how far off my predictions were from reality. In other words, am i being delusional? Each dot is the gap between what my model predicted and what actaully happened. Best case scenario these dots should be randomly scattered arund the red dashed line. Thankfully, that is exactly what we see. The orange smooth line sit right on zero which confirms my model is not underscoring or overscoring the predictions. There is a limit to my model and that is how wide my data gets in the middle. All that says is the model is less precise on certain predictions.

<img width="1709" height="773" alt="how_far_off" src="https://github.com/user-attachments/assets/cc4ce1de-3fe0-49ed-9ea6-541813f6b5c7" />

# Conclusion
What happened? Fundamental financial indicators do have a statiscally significant realtionship with annual stock returns with EPS doing all the havy lifting. I will mention that the R-Squared = 0.0007 does tell me that the indicators only explain about 0.7% of the variations in returns. It sounds bad when you look at it like that, but markets are incredibly difficult to predict in teh first place. This is due to the stock prices reflecting not only the fundamentals, but also news, global events, and human behavior. 

Financial analysis is not useless because it can be a small part and a small step towards predictions.









