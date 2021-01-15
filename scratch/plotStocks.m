function fig = plotStocks

% Load data for the stock indices
load IndexData dates values series
% Plot the stock index values versus time
fig = figure;
plot(dates, values)
% Use dateticks for the x axis
datetick('x')
% Add title and axis labels
xlabel('Date')
ylabel('Index Value')
title('Relative Daily Index Closings')
% Add a legend in the top, left corner
legend(series, 'Location', 'NorthWest')