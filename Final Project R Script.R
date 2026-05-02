# Final Project - NYSE Prediction Models

#loading libraries
install.packages("gtsummary")
library(tidyverse)
library(ggplot2)
library(broom)
library(gtsummary)


# load in data
fundamentals = read.csv("fundamentals.csv")
adjusted_prices = read.csv("prices-split-adjusted.csv")
securities = read.csv("securities.csv")

# Exploring data and checking for missing values
sum(is.na(fundamentals))
sum(is.na(securities))
sum(is.na(adjusted_prices))

# clean up the NA and remove X column in fundamentals
fundamentals = fundamentals |>
  select(-x) |>
  drop_na() 
  
# time to setup the merger of datasets to keep only companies that show up in both
stocks_names = fundamentals |>
  inner_join(
    adjusted_prices, by = c("Ticker.Symbol" = "symbol") #both of these show the same info
  )

# now that we have our datasets merged
# ill target annual returns predictions 

annual_returns = adjusted_prices |>
  mutate(year = format(as.Date(date), "%Y")) |>
  group_by(symbol, year) |>
  summarise(
    start_price = first(close),
    end_price = last(close),
    .groups = "drop"
  ) |>
  mutate(annual_return = (end_price - start_price) / start_price * 100)

# merging of fundamentals with newly made dataset to have all the info in set
stocks = annual_returns |>
  inner_join(fundamentals, by = c("symbol" = "Ticker.Symbol")) |>
  select(-Period.Ending) # removed due to being filler

# selecting the financial indicators to create our linear regression model
data_model = stocks |>
  select(
    annual_return,
    `Earnings.Per.Share`,
    `Profit.Margin`,
    `Operating.Margin`,
    `After.Tax.ROE`,
    `Total.Revenue`,
    `Current.Ratio`
  ) |>
  drop_na()

# build the LR model
model = lm(annual_return ~ `Earnings.Per.Share` + `Profit.Margin` + `Operating.Margin` + `After.Tax.ROE` + `Total.Revenue` + `Current.Ratio`,
           data = data_model)

summary(model)

# now ill turn this into a clean table that i can present using gtsummary

tbl_regression(model,
               label = list(
                 Earnings.Per.Share ~ "Earnings Per Share",
                 Profit.Margin ~ "Profit Margin",
                 Operating.Margin ~ "Operating Margin",
                 After.Tax.ROE ~ "Return on Equity",
                 Total.Revenue ~ "Total Revenue",
                 Current.Ratio ~ "Current Ratio"
               )) |>
  bold_p(t = 0.05) |>
  bold_labels() |>
  add_significance_stars() |>
  modify_header( label = "Financial Indicator") |>
  modify_caption("Linear Regression of Predictors of Annual Stock Return")


# scatter plot of EPS vs Annual return

ggplot(data_model|>
         filter(Earnings.Per.Share > -30,
                Earnings.Per.Share < 30,
                annual_return > -50,
                annual_return < 100),
       aes(x = Earnings.Per.Share, y = annual_return)) +
  geom_point(alpha = 0.2, color = "steelblue", size = 1.5) +
  geom_density_2d(color = "orange", alpha = 1) +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray40") +
  labs(
    title = "Does Higher EPS Predict Better Returns",
    subtitle = "Each dot equals one S&P 500 company in a given year (2010-2016)",
    x = "Earnings Per Share (USD)",
    y = "Annual Return (%)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "gray40", size = 10)
  )


# residual plot (how well does our model fit)
data_model$fitted = fitted(model)
data_model$residuals = residuals(model)

ggplot(data_model |>
         filter(fitted > 5, fitted < 25,
         residuals > -75, residuals < 100),
         aes(x = fitted, y = residuals)) +
  geom_point(alpha = 0.2, color = "steelblue", size = 1.5) +
  geom_hline(yintercept = 0, color = "red", linetype = "dashed", linewidth = 0.8) +
  geom_smooth(se = FALSE, color = "orange", linewidth = 1) +
  labs(
    title = "How Far Off Were Our Predictions?",
    subtitle = "Each dot shows the gap between predicted and actual stock return",
    x = "Predicted Annual Return (%)",
    y = "Prediction Error (%)",
    caption = "A perfect model would have all dots randomly scattered around the red line"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "gray40", size = 10)
  )


# coefficient plot

tidy(model) %>%
  filter(term != "(Intercept)") |>
  mutate(term = recode(term,
                       "Earnings.Per.Share" = "Earnings Per Share",
                       "Profit.Margin" = "Profit Margin",
                       "Operating.Margin" = "Operating Margin",
                       "After.Tax.ROE" = "Return on Equity",
                       "Total.Revenue" = "Total Revenue",
                       "Current.Ratio" = "Current Ratio"
  ),
  significant = p.value < 0.05) |>
  ggplot(aes(x = reorder(term, estimate), y = estimate)) +
  geom_col(aes(fill = significant), show.legend = TRUE) +
  geom_errorbar(aes(ymin = estimate - std.error,
                    ymax = estimate + std.error),
                width = 0.3) +
  coord_flip() +
  scale_fill_manual(values = c("gray70", "steelblue"),
                    labels = c("Not Significant", "Significant"),
                    name = "") +
  labs(
    title = "Which Financial Indicators Actually Matter?",
    subtitle = "Longer bars = stronger effect on annual stock return",
    x = "",
    y = "Effect on Annual Return (%)",
    caption = "Error bars show uncertainty. Gray bars are not statistically significant."
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "gray40", size = 10),
    legend.position = "top"
  )
  
  








